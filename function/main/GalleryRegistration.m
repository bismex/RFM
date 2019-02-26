%% 3) Registration (gallery sets)
% Gallery sets are enrolled in this process.
% Thus, it is off-line training process.
% Our method (unsupervised matching) does not use gallery ID
% Our method (frame-level approach) does not apply feature aggregation

function DB = GalleryRegistration(DB)

tic;
DB = GaitPoseAlignment(DB); % Skeleton alignment
DB = GaitQualityAssessment(DB, 0); % Gait quality assessment
DB = GaitPhaseAnalysis(DB, []); % Phase analysis
DB = GaitFeatureExtraction(DB); % Feature extraction
if DB.opt.PhaseDivisionNumber > 1 
    DB = GaitPhaseTraining(DB); % Training temporal gait classifier (Pseudo labeling)
end
DB = GaitFeatureAggregation(DB, 0); % Feature aggregation (It is not used for our method) 
DB = TrainingGaitFeature(DB); % Training gait classifier (It is not used for our method) 
DB.time.reg = toc;

end