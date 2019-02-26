%% Recognition step
% DB_R.opt.GaitRecogMethod = 1 -> Two-stage linear matching 
%                                 & weighted majority voting
% DB_R.opt.GaitRecogMethod = 2 -> SPR, kNN, NN
% DB_R.opt.GaitRecogMethod = 3 -> SVM
% DB_R.opt.GaitRecogMethod = 4 -> DTW, majority voting
% DB_R.opt.GaitRecogMethod = 5 -> RF / Bayes
% DB_R.opt.GaitRecogMethod = 6 -> RF / Bayes
% DB_R.opt.GaitRecogMethod = 7 -> quality based fusion

function DB_R = TestGaitFeature(DB_R, DB_P, DB_G)

switch DB_R.opt.GaitRecogMethod 
    case 1 % Proposed
        DB_R = ClusteredDissimilarity(DB_R, DB_P, DB_G);
        DB_R = MultipleLinearMatching(DB_R);
        DB_R = FrameLevelWeightedVoting(DB_R, DB_P);
    case 2 % Kas
        DB_R = OTHER_TEST_AGGREGATION(DB_R, DB_P, DB_G);
        switch DB_P.opt.GaitFeatureTest
            case 1, DB_R = OTHER_TEST_SPR(DB_R, DB_G);
            case 2, DB_R = OTHER_TEST_KNN(DB_R, DB_G);
            case 3, DB_R = OTHER_TEST_NN(DB_R, DB_G);
        end
    case 3 % Kas
        switch DB_P.opt.GaitFeatureTest
            case 1, DB_R = OTHER_TEST_SVM(DB_R, DB_P, DB_G);
            case 2, DB_R = OTHER_TEST_SVM(DB_R, DB_P, DB_G);
        end
    case 4 % Ahmed
        DB_R = OTHER_TEST_AGGREGATION(DB_R, DB_P, DB_G);
        DB_R = OTHER_MAJORITY_VOTING(DB_R, DB_G);
    case 5 % Preis
        switch DB_P.opt.GaitFeatureTest
            case 3, DB_R = OTHER_TEST_RF(DB_R, DB_P, DB_G);
            case 4, DB_R = OTHER_TEST_BAYES(DB_R, DB_P, DB_G);
        end
    case 6 % Ball
        switch DB_P.opt.GaitFeatureTest
            case 3, DB_R = OTHER_TEST_RF(DB_R, DB_P, DB_G);
            case 4, DB_R = OTHER_TEST_BAYES(DB_R, DB_P, DB_G);
        end
    case 7 % Multi-modal fusion
        switch DB_R.opt.method_rec_sub
            case {3,4,5,6,7,8}
                DB_R = ClusteredDissimilarity(DB_R, DB_P, DB_G);
                DB_R = OTHER_TEST_FUSION(DB_R, DB_P, DB_G);
            case {1, 2}
                DB_R = OTHER_FEATURE_FUSION(DB_R, DB_P, DB_G);
        end
    case 8
        DB_R = new_recognition(DB_R, DB_P, DB_G);
    case 9
        DB_R = ClusteredDissimilarity(DB_R, DB_P, DB_G);
        score_gal = zeros(1, DB_R.num.G_person);
        dist = DB_R.dist{1};
        num_gap = numel(dist)/DB_R.num.G_person;
        for i = 1 : DB_R.num.G_person
            score_gal(i) = mean(dist((i-1)*num_gap+1 : i*num_gap));
        end
        
        DB_R.score = exp(-score_gal/DB_R.num.G_person);
end
  

end
