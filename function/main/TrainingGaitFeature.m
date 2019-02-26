%% Training gait feature
function DB = TrainingGaitFeature(DB)

switch DB.opt.GaitRecogMethod 
    case 1 % none
    case 2
        if DB.opt.GaitFeatureTest == 1
            DB = OTHER_TRAIN_SPR(DB); % SPR
        end
    case 3
        switch DB.opt.GaitFeatureTest % SVM
            case 1, DB = OTHER_TRAIN_GSVM(DB);
            case 2, DB = OTHER_TRAIN_LSVM(DB);
        end
    case 4
        if DB.opt.GaitFeatureTest == 4
        end
    case 5
        switch DB.opt.GaitFeatureTest % RF and Bayes
            case 3, DB = OTHER_TRAIN_RF(DB);
            case 4, DB = OTHER_TRAIN_BAYES(DB);
        end
    case 6
        switch DB.opt.GaitFeatureTest % RF and Bayes
            case 3, DB = OTHER_TRAIN_RF(DB);
            case 4, DB = OTHER_TRAIN_BAYES(DB);
        end
    case 7
    case 8 
end
        

end