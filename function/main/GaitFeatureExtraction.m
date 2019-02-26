%% Feature extraction
% DB.opt.GaitFeatureMethod = 1 -> proposed
% DB.opt.GaitFeatureMethod = 2 -> Euler angles
% DB.opt.GaitFeatureMethod = 3 -> JRD, JRA
% DB.opt.GaitFeatureMethod = 4 -> Height, length, speed
% DB.opt.GaitFeatureMethod = 5 -> Leg angles

function DB = GaitFeatureExtraction(DB)

switch DB.opt.GaitFeatureMethod 
    case 1 % Proposed
        if sum(DB.opt.method_feat_sub == [1:7])
            DB = PositionVector(DB); % proposed
        else
            DB = new_feature(DB); % including only static & dynamic
        end
    case 2, DB = OTHER_FeatureKastaniotis(DB);  % Kastaniotis (8limbs, 2euler)
    case 3, DB = OTHER_FeatureAhmed(DB); % Ahmed (JRD, JRA)
    case 4, DB = OTHER_FeaturePreis(DB); % preis (height, length, speed, 13dim per video) [same length]
    case 5, DB = OTHER_FeatureBall(DB); % ball (mean, std, max, 18dim per video) [same length]
    case 6, DB = OTHER_SkeletonDistance(DB); % not used
    case 7, DB = OTHER_FeatureSun(DB); % not used
end

%% NaN Detection
if numel(DB.feature.all(isnan(DB.feature.all)))
    fprintf('NaN is detected\n');
    DB.feature.all(isnan(DB.feature.all)) = abs(randn(1, numel(find(isnan(DB.feature.all))))/1000000);
    DB.feature.all(isinf(DB.feature.all)) = abs(randn(1, numel(find(isinf(DB.feature.all))))/1000000);
    DB.feature.all(find(DB.feature.all==0)) = abs(randn(1, numel(find(DB.feature.all==0)))/1000000);
end    

% DB.feature.num_test = DB.video
%% Feature label
DB.feature.label = [];
DB.feature.video = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        DB.feature.label = cat(1, DB.feature.label, p * ones(DB.T.param.node{p, v}.num, 1));
        DB.feature.video = cat(1, DB.feature.video, v * ones(DB.T.param.node{p, v}.num, 1));
    end
end
if numel(DB.feature.label) ~= size(DB.feature.all, 1)
    fprintf('feature labeling error \n'); 
end

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

%% Output
% DB.num.feature
% DB.feature.all
% DB.feature.dim
% DB.feature.method

end