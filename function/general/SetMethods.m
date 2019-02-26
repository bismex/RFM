function [DB_G, DB_P, DB] = SetMethods(DB_G, DB_P, DB_R, DB)

flag_method = DB_R.flag_method;

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

%% method flag
switch flag_method 
    %% Various gait recognition algorithms
    case 0 % Proposed
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 1 % Kas feature / WWTEST / SPR
        DB.opt.GaitFeatureMethod = 2;
        DB.opt.GaitRecogMethod = 2;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 2;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 0;
    case 2 % Kas feature / WWTEST / KNN
        DB.opt.GaitFeatureMethod = 2;
        DB.opt.GaitRecogMethod = 2;
        DB.opt.method_rec_sub = 2;
        DB.opt.align_method = 2;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 0;
    case 3 % Ahmed, (DTW) / (rank-level fusion)
        DB.opt.GaitFeatureMethod = 3;
        DB.opt.GaitRecogMethod = 4;
        DB.opt.align_method = 0;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 0;
    case 4 % Preis / median / RF
        DB.opt.GaitFeatureMethod = 4;
        DB.opt.GaitRecogMethod = 5;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 0;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 0;
    case 5 % Kas feature / histogram / GSVM
        DB.opt.GaitFeatureMethod = 2;
        DB.opt.GaitRecogMethod = 3;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 3;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 0;
    case 6 % Ball / max,mean,std / RF
        DB.opt.GaitFeatureMethod = 5;
        DB.opt.GaitRecogMethod = 6;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 0;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 0;
    case 7 % etc (not used)
        DB.opt.GaitFeatureMethod = 7;
        DB.opt.GaitRecogMethod = 9;
        DB.opt.align_method = 0;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 0;
    
    %% For robustness evaluation (fixed alignment method)
    case 10 % Proposed feature / Proposed recognition
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 11 % Kas feature / WWTEST / SPR
        DB.opt.GaitFeatureMethod = 2;
        DB.opt.GaitRecogMethod = 2;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 12 % Kas feature / WWTEST / KNN
        DB.opt.GaitFeatureMethod = 2;
        DB.opt.GaitRecogMethod = 2;
        DB.opt.method_rec_sub = 2;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 13 % Kas feature / histogram / GSVM
        DB.opt.GaitFeatureMethod = 2;
        DB.opt.GaitRecogMethod = 3;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4; % impossible 
        DB.opt.quality_method = 1;
    case 14 % Ahmed, (DTW) / (rank-level fusion)
        DB.opt.GaitFeatureMethod = 3;
        DB.opt.GaitRecogMethod = 4;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 15 % Preis / median / RF
        DB.opt.GaitFeatureMethod = 4;
        DB.opt.GaitRecogMethod = 5;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 16 % Ball / max,mean,std / RF
        DB.opt.GaitFeatureMethod = 5;
        DB.opt.GaitRecogMethod = 6;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        
    %% For comparison of alignment methods
    case 20 % Direct
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 2;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 21 % TorsoPCA
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 3;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 22 % etc (not used)
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 4;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        
    %% For comparison of alignment methods (ours, gap)
    case {25, 26, 27, 28, 29}
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        DB.opt.frame_moving = flag_method - 25 + 1;
      
    %% For comparison of feature extraction methods (ours)
    case 30 % Static
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 8;
        DB.opt.new_temporal_feature = 0;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 31 % Dynamic
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 9;
        DB.opt.new_temporal_feature = 0;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        
    %% For comparison of feature extraction methods (other)
    case 40 % Kas, (Euler angle)
        DB.opt.GaitFeatureMethod = 2;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 41 % Ahmed, (JRD, JRA)
        DB.opt.GaitFeatureMethod = 3;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 42 % Preis, (13 features)
        DB.opt.GaitFeatureMethod = 4;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 43 % Ball, (18 features)
        DB.opt.GaitFeatureMethod = 5;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 44 % Skeleton distance (not used)
        DB.opt.GaitFeatureMethod = 6;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        
    %% For comparison of gait recognition methods (ours)
    case 50 % Linear matching
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 5;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 51 % majority voting
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 6;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 1;
        
    %% For comparison of gait recognition methods (others)
    case 60 % Kas2 SPR
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 2;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 61 % Kas2 kNN
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 2;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 2;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 62 % Ahmed
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 4;
        DB.opt.method_feat_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 63 % Preis
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 5;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 64 % Kas1
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 3;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
    case 65 % Ball
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 6;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        
    %% Quality-based fusion methods 
    case {70, 71, 72, 73, 74, 75, 76, 77} 
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 7; % multimodal fusion
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = flag_method - 70 + 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4; % (phase 4)
        DB.opt.quality_method = 1;
        
    %% Temporal segmentation test
    case 90 
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 0;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 1; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 91
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 2;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 4; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 92
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 2;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 1; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 93
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 3;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 4; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 94
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 3;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 1; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 95
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 4; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 96        
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4.1;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 1; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 97
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 5;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 4; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 98
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 5;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 1; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 99
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 6;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 4; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
    case 100
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 6;
        DB.opt.quality_method = 1;
        DB.opt.gaitphase_method = 1; % 1 : RF, 2 : SVM, 3 : GMM, 4 : poly 
        
    case {110, 111, 112, 113, 114, 115, 116, 117, 118, 119}
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        DB.opt.align_sub = flag_method - 110 + 1;
        
    case 120 % w/ temporal smoothing
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        DB.opt.paramsmooth_span = 5;
        
    case 121 % w/ temporal smoothing + manual frame_moving
        DB.opt.GaitFeatureMethod = 1;
        DB.opt.GaitRecogMethod = 1;
        DB.opt.method_feat_sub = 1;
        DB.opt.method_rec_sub = 1;
        DB.opt.align_method = 1;
        DB.opt.PhaseDivisionNumber = 4;
        DB.opt.quality_method = 1;
        DB.opt.paramsmooth_span = 5;
        DB.opt.frame_moving = 2;
        
end


end

