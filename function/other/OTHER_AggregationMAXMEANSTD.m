function DB = OTHER_AggregationMAXMEANSTD(DB)


local_bin = 40;

%% max,mean,std feature(in video levels)
new_feature = [];
for j = 1 : numel(DB.feature.end_idx)
    feat = DB.feature.all(DB.feature.srt_idx(j):DB.feature.end_idx(j), :);
    if numel(feat)>local_bin %local
        idx = max(1, ceil(size(feat, 1)/2) - floor(local_bin/2)) : min(size(feat, 1), ceil(size(feat, 1)/2) + ceil(local_bin/2) - 1);
    else
        idx = 1 : size(feat, 1);
    end
    if numel(idx) == 1
        feat = cat(2, max(feat(idx, :), [], 1), mean(feat(idx, :), 1), feat(idx, :)); % histogram
    else
        feat = cat(2, max(feat(idx, :), [], 1), mean(feat(idx, :), 1), std(feat(idx, :))); % histogram
    end
    new_feature = cat(1, new_feature, feat);
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