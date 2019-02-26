function DB = OTHER_TRAIN_SPR(DB)

[~,~,V] = svds(DB.feature.dissim,20);
DB.feature.dissim = DB.feature.dissim * V;
DB.feature.eigenvector = V;


end