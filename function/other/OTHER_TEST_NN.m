function DB_R = OTHER_TEST_NN(DB_R, DB_G)

dist = pdist2(DB_G.feature.dissim, DB_R.test_vector, 'euclidean');
label =  ceil((1:DB_G.num.person*DB_G.num.video)/(DB_G.num.video));

[~, min_idx] = min(dist);
class = label(min_idx);
DB_R.score(class) = 1;

end