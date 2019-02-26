function [DB_G, DB_P, DB] = SetMethods_tmp(DB_G, DB_P, DB_R, DB)

% ETC experiments.... (not used)


% %% For comparison of phase selection methods (not used)
% case 70
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 1;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 4;
%     DB.opt.quality_method = 1;
% case 71
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 1;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 3;
%     DB.opt.quality_method = 1;
% case 72
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 1;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 2;
%     DB.opt.quality_method = 1;
% case 73
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 1;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 1;
%     DB.opt.quality_method = 1;
% 
% %% For comparison of alignment methods when WW-test + SPR (not used)
% case 30
%     DB.opt.GaitFeatureMethod = 2;
%     DB.opt.GaitRecogMethod = 2;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 0;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 0;
% case 31
%     DB.opt.GaitFeatureMethod = 2;
%     DB.opt.GaitRecogMethod = 2;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 2;
%     DB.opt.PhaseDivisionNumber = 0;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 0;
% case 32
%     DB.opt.GaitFeatureMethod = 2;
%     DB.opt.GaitRecogMethod = 2;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 3;
%     DB.opt.PhaseDivisionNumber = 0;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 0;
% case 33
%     DB.opt.GaitFeatureMethod = 2;
%     DB.opt.GaitRecogMethod = 2;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 4;
%     DB.opt.PhaseDivisionNumber = 0;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 0;
% case 34
%     DB.opt.GaitFeatureMethod = 2;
%     DB.opt.GaitRecogMethod = 3;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 0;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 0;
% case 35
%     DB.opt.GaitFeatureMethod = 2;
%     DB.opt.GaitRecogMethod = 3;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 2;
%     DB.opt.PhaseDivisionNumber = 0;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 0;
% case 36
%     DB.opt.GaitFeatureMethod = 2;
%     DB.opt.GaitRecogMethod = 3;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 3;
%     DB.opt.PhaseDivisionNumber = 0;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 0;
% case 37
%     DB.opt.GaitFeatureMethod = 2;
%     DB.opt.GaitRecogMethod = 3;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 4;
%     DB.opt.PhaseDivisionNumber = 0;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 0;
% 
% %% Feature analysis for temporal segmentation (not used)
% case {140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151}
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = flag_method - 140 + 1;
%     DB.opt.new_temporal_feature = 0;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;
% 
% %% Quality analysis (not used)
% case {120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132}
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 8; % own methods
%     DB.opt.method_feat_sub = 1;
%     DB.opt.method_rec_sub = flag_method - 120 + 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;
% 
% %% Quality-based fusion methods (phase x)
% case {100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112}
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 7; % multimodal fusion
%     DB.opt.method_feat_sub = 1;
%     DB.opt.method_rec_sub = flag_method - 100 + 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 0; 
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;
% 
% %% For comparison of feature extraction methods (our, not used)
% case 50 % Projection(M)
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 2;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;
% case 51 % Projection(L)
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 3;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;
% case 52 % Projection(T)
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 4;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;
% case 53 % Projection(ML)
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 5;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;
% case 54 % Projection(MT)
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 6;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;
% case 55 % Projection(TL)
%     DB.opt.GaitFeatureMethod = 1;
%     DB.opt.GaitRecogMethod = 1;
%     DB.opt.method_feat_sub = 7;
%     DB.opt.method_rec_sub = 1;
%     DB.opt.align_method = 1;
%     DB.opt.PhaseDivisionNumber = 4;
%     DB_G.opt.PhaseSelection = 0;
%     DB.opt.quality_method = 1;




end

