function DB = OTHER_AggregationHIST(DB)

% Histogram
bin = 40;
hist_vector = 0:pi/bin:pi;
dim_pca = DB.opt.GaitFeatureTest_dim;

%% histogram feature(in video levels)
new_feature = [];
for j = 1 : numel(DB.feature.end_idx)
    old_feature = [];
    for k = 1 : DB.feature.dim
        if DB.opt.GaitFeatureMethod == 2
            hist_feat = histc(DB.feature.all(DB.feature.srt_idx(j):DB.feature.end_idx(j), k), hist_vector(1:bin)); % histogram
        else
            hist_feat = histc(DB.feature.all(DB.feature.srt_idx(j):DB.feature.end_idx(j), k), -1:2/bin:0.99); % histogram
        end
        if size(hist_feat, 1) == 1
            hist_feat = hist_feat';
        end
        hist_feat = hist_feat / (sum(hist_feat)+eps); % norm
        old_feature = cat(1, old_feature, hist_feat); % concat 40 x 16
    end
    new_feature = cat(1, new_feature, old_feature');
end
if DB.num.person ~= 1 && DB.opt.GaitFeatureTest_dim ~= 0
    [coeff, ~] = pca(new_feature);
    reducedDimension = coeff(:,1:min(size(coeff, 2), dim_pca));
    new_feature = new_feature * reducedDimension;
    DB.feature.pca_mat = reducedDimension;
end
DB.feature.all = new_feature;



DB.feature.label = ceil([1:DB.num.video*DB.num.person]/DB.num.video)';
DB.feature.video = repmat([1 : DB.num.video], [1, DB.num.person])';
if DB.num.video == 1
    label = DB.feature.label;
else
    label = DB.feature.video;
end
DB.feature.srt_idx = cat(2, 1, find(diff(label)~=0)'+1);
DB.feature.end_idx = cat(2, find(diff(label)~=0)', numel(label));
if DB.feature.end_idx(end) ~= numel(label)
    fprintf('end_idx error\n'); 
end

end