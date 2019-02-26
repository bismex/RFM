function DB = OTHER_TRAIN_BAYES(DB)

DB.feature.model = fitcnb(DB.feature.all+randn(size(DB.feature.all))/10000000000000, DB.feature.label);
% DB.feature.model = fitNaiveBayes([DB.feature.all;DB.feature.all], [DB.feature.label;DB.feature.label]);

end