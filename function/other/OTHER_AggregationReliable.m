function DB = OTHER_AggregationReliable(DB)

localmax_bin = 20;

%% median feature(in video levels)
new_feature = [];
for j = 1 : numel(DB.feature.end_idx)
    old_feature = [];
    head_z = DB.feature.all(DB.feature.srt_idx(j):DB.feature.end_idx(j), end);
    reliable_frames = head_z > 1.8 & head_z < 3;
    if sum(reliable_frames) == 0
        fprintf('reliable frame x \n');
        reliable_frames(:) = 1;
    end
    
    for k = 1 : DB.feature.dim - 1 %% because last feature is steplength
        feat = DB.feature.all(DB.feature.srt_idx(j):DB.feature.end_idx(j), k);
        feat = feat(reliable_frames);
        feat = mean(feat);
        old_feature = cat(1, old_feature, feat); % concat 40 x 16
    end
    new_feature = cat(1, new_feature, old_feature');
end
DB.feature.all = new_feature;
DB.feature.dim = DB.feature.dim - 1;

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