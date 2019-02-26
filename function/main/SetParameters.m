%% 1) Experimental setting
% You can change the experimental setting.
% Annotations are described in detail.
% If you select a fixed experimental set, please refer to SetFlagGen.m
% If you choose parameters manually, make DB_R.manual = 1 and change them

function [DB, DB_P, DB_G] = SetParameters(DB_R)

if DB_R.iter == 1
    fprintf('=========================================================\n');
end
DB.break = 0;

%% Settings
DB.opt.time = 0;
DB.opt.print = 0;
DB.opt.manual_numbering = 0;
DB.opt.log = 1;
DB.opt.log_front = '';
DB.opt.mail = 0;
DB.opt.mail_front = '';
DB.opt.visualize = 0;
DB.opt.figure = 0;
DB.opt.conf = 0;
DB.opt.short_version = 0;

%% Parameters for gait recognition
if DB_R.manual == 1 % Manually change
    
    % For data construction(Gallery) [DB_G]       
    DB_G.opt.rotation = 0;      % Rotate skeletons [0 or 1]
    DB_G.opt.translation = 0;   % Translate skeletons [0 or 1]
    DB_G.opt.scaling = 0;       % Change scale of skeletons [0 or 1]
    DB_G.opt.error = 0;         % Pose estimation error for each joint [0 ~ 4] (%)
    DB_G.opt.loss = 0;          % Lower-limb occlusion(LO) [0.2, 0.4, 0.6, 0.8] (0.2 == 20%)
                                % Upper-limb occlusion(LO) [1.2, 1.4, 1.6, 1.8] (1.2 == 20%)
                                % Mixed-limb occlusion(LO) [2.2, 2.4, 2.6, 2.8] (2.2 == 20%)
    DB_G.opt.missing = 0;       % Missing data (center) [0.1~0.9]
                                % Missing data (sampling) [1.1~1.9]

    % For data construction(Probe) [DB_P] Same as gallery parameters
    DB_P.opt.rotation = 0;      % Rotate skeletons [0 or 1]
    DB_P.opt.translation = 0;   % Translate skeletons [0 or 1]
    DB_P.opt.scaling = 0;       % Change scale of skeletons [0 or 1]
    DB_P.opt.error = 0;         % Pose estimation error for each joint [0 ~ 4] (%)
    DB_P.opt.loss = 0;          % Lower-limb occlusion(LO) [0.2, 0.4, 0.6, 0.8] (0.2 == 20%)
                                % Upper-limb occlusion(LO) [1.2, 1.4, 1.6, 1.8] (1.2 == 20%)
                                % Mixed-limb occlusion(LO) [2.2, 2.4, 2.6, 2.8] (2.2 == 20%)
    DB_P.opt.missing = 0;       % Missing data (center) [0.1~0.9]
                                % Missing data (sampling) [1.1~1.9]

    
    % Basic parameters
    DB.num.probe = 3; % The number of probe video
    DB.opt.dataset_idx = 1; % Dataset index -> refer to NodeComposition.m
    DB.opt.dataset_subidx = 0; % Subidx (protocol) -> refer to NodeComposition.m
    
    % Special parameters
    DB.opt.quat = 0; % Quaternion for CILgait dataset (not used)
    DB.opt.openset_result = 0; % [Only for openset exp] 1 : precision, 2 : recall, 3 : precision & recall for seen
    DB.opt.openset_score = 0; % [Only for openset exp] 
    DB.opt.openset_ratio = 0; % [Only for openset exp] 
    DB.opt.realtime = 0; % [Only for realtime exp]  1 / 5
    
    % Alignment
    DB.opt.frame_moving = 0; % Gap for estimating moving direction (0 is automatic, 1~5 is manual)
    DB.opt.align_method = 0; % Alignment method (0: Proposed, 2: Pelvis, 3: TorsoPCA)

    % Feature extraction
    DB.opt.GaitFeatureMethod = 1; % Feature extraction methods (1: Proposed, watch SetNames.m)
    DB.opt.method_feat_sub = 1; % Feature extraction sub-methods (1: Proposed, watch SetNames.m)

    % Temporal segmentation
    DB.opt.PhaseDivisionNumber = 4; % The number of temporal phases (4 is default)
    DB.opt.gaitphase_method = 1; % Temporal segmentation methods (1: Proposed(RF), 2: SVM, 3: GMM, 4: poly fitting)
    DB.opt.new_temporal_feature = 2; % Feature extraction for training temporal classifier (0: original, 1:new feature, 2:normalize(default))

    % Recognition
    DB.opt.GaitRecogMethod = 1; % Gait recognition methods (1: Proposed, watch SetNames.m)
    DB.opt.method_rec_sub = 1; % Gait recognition methods (1: Proposed, watch SetNames.m)
    DB.opt.quality_method = 1; % Quality assessment methods (1:default, 2,3,4:different versions, watch GaitQualityAssessment.m)

    % Not used
    DB.opt.new_temporal_selection = 1; % (not used)
    DB.opt.paramsmooth_span = 0; % Temporal smoothing (not used)
    DB_G.opt.PhaseSelection = 0; % Phase selection (not used)
    DB_P.opt.PhaseSelection = 0; % Phase selection (not used)
    DB.opt.feature_recognition_test = 0; % not used
    DB.opt.feature_temporal_test = 0; % not used
    DB.opt.temporal_test = 0; % not used
    DB.opt.GaitPhase_min_gap = 0; % Delete a phase when period is under this value (not used)
    DB.opt.delete_setting_noise_min = 0.00; % Delete a phase when derivative is under this value (not used)
    DB.opt.delete_setting_noise_max = inf; % Delete a phase when derivative is over this value (not used)
else
    DB.opt.dataset_idx = 1;
    [DB_G, DB_P, DB] = SetSituations(DB_R, DB); % Situations.. (DB1,2,3,4 and simulation, ablation studies..)
    [DB_G, DB_P, DB] = SetMethods(DB_G, DB_P, DB_R, DB); % Methods... (ours, others, etc..)
end


[DB_P, DB_G] = SetPG(DB, DB_P, DB_G); % not important
DB_P = SetNames(DB_P); % Setting methods in detail
DB_G = SetNames(DB_G); % Setting methods in detail
% GaitFeatureMethod, method_feat_sub, GaitRecogMethod, method_rec_sub...
% The above parameters are defined


if DB_R.iter == 1 % printing
    fprintf('=========================================================\n');
    fprintf(['[File number : ', num2str(DB_P.opt.GaitFeatureMethod), '.', num2str(DB_P.opt.GaitRecogMethod), '-', ...
        num2str(DB_P.opt.method_feat_sub), '.', num2str(DB_P.opt.method_rec_sub),']\n']);
    fprintf(['[Feature extraction : ', DB_P.opt.name_feat, ']\n'])
    fprintf(['[Gait recognition : ', DB_P.opt.name_rec,']\n'])
    fprintf(['[Dataset : DB', num2str(DB.opt.dataset_idx),']\n']);
    fprintf(['[Dataset : sub_idx', num2str(DB.opt.dataset_subidx),']\n']);
    fprintf(['[Probe : ', num2str(DB.num.probe), ' Phase : ', num2str(DB_P.opt.PhaseDivisionNumber), ' Align : ', num2str(DB_P.opt.align_method), ']\n']);
    fprintf(['[Situation(Gallery) - ', 'Error : ', num2str(DB_G.opt.error), ...
        ' RTS : ', num2str(DB_G.opt.rotation), '/', num2str(DB_G.opt.translation), '/', num2str(DB_G.opt.scaling), ...
        ' LM : ', num2str(DB_G.opt.loss), '/', num2str(DB_G.opt.missing), ...
        ' Ph : ', num2str(DB_G.opt.PhaseSelection), ']\n']);
    fprintf(['[Situation(  Probe) - ', 'Error : ', num2str(DB_P.opt.error), ...
        ' RTS : ', num2str(DB_P.opt.rotation), '/', num2str(DB_P.opt.translation), '/', num2str(DB_P.opt.scaling), ...
        ' LM : ', num2str(DB_P.opt.loss), '/', num2str(DB_P.opt.missing), ...
        ' Ph : ', num2str(DB_P.opt.PhaseSelection), ']\n']);
    fprintf('--------------------------------------------------------\n');
end

end