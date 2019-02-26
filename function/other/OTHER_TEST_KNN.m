function DB_R = OTHER_TEST_KNN(DB_R, DB_G)

dim = min(DB_G.opt.GaitFeatureTest_dim, DB_G.num.person);
dist = pdist2(DB_G.feature.dissim, DB_R.test_vector, 'euclidean');
label =  ceil((1:DB_G.num.person*DB_G.num.video)/(DB_G.num.video));

[~, idx] = sort(dist, 'ascend');
[~, idx] = sort(idx, 'ascend');
idx(idx>dim) = 0;
idxfind = find(idx~=0);
valfind = dist(idxfind);
score_val = zeros(1, DB_G.num.person);
idxlabel = label(idxfind);
for i = 1 : dim
    DB_R.score(idxlabel(i)) = DB_R.score(idxlabel(i)) + 1; 
    score_val(idxlabel(i)) = score_val(idxlabel(i)) + valfind(i);
end

maxvote = max(DB_R.score);
if sum(maxvote==DB_R.score) > 1
    maxidx = find(maxvote==DB_R.score);
    [~, idx] = min(score_val(maxidx));
    DB_R.score(maxidx(idx)) = DB_R.score(maxidx(idx)) + 0.1;
end

end