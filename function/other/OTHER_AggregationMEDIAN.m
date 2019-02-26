function DB = OTHER_AggregationMEDIAN(DB)

localmax_bin = 20;

%% median feature(in video levels)
new_feature = [];
for j = 1 : numel(DB.feature.end_idx)
    old_feature = [];
    if DB.opt.GaitFeatureMethod == 4 % median with local maximum
        for k = 1 : DB.feature.dim - 1 %% because last feature is steplength
            med_feat = DB.feature.all(DB.feature.srt_idx(j):DB.feature.end_idx(j), k);
            med_feat = median(med_feat); % histogram
            old_feature = cat(1, old_feature, med_feat); % concat 40 x 16
        end
        localmax_feat = DB.feature.all(DB.feature.srt_idx(j):DB.feature.end_idx(j), DB.feature.dim);
        if numel(localmax_feat)>localmax_bin %local minimum
            idx = ceil(numel(localmax_feat)/2) - floor(localmax_bin/2) : ceil(numel(localmax_feat)/2) + ceil(localmax_bin/2) - 1;
            localmax_feat = max(localmax_feat(idx));
        else
            localmax_feat = max(localmax_feat);
        end
        old_feature = cat(1, old_feature, localmax_feat);
    else % only median
        for k = 1 : DB.feature.dim %% because last feature is steplength
            med_feat = DB.feature.all(DB.feature.srt_idx(j):DB.feature.end_idx(j), k);
            med_feat = median(med_feat); % histogram
            old_feature = cat(1, old_feature, med_feat); % concat 40 x 16
        end
    end
    new_feature = cat(1, new_feature, old_feature');
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