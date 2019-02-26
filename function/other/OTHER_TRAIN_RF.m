function DB = OTHER_TRAIN_RF(DB)

DB.feature.model = TreeBagger(DB.opt.num_tree,DB.feature.all,DB.feature.label,'OOBPrediction','On',...
    'Method','classification');

% label = DB.feature.model.predict(DB.feature.all);
end