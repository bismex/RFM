function DB_R = OTHER_TEST_SVM(DB_R, DB_P, DB_G)

label = zeros(1, DB_G.num.person);
score = zeros(1, DB_G.num.person);
for i = 1 : DB_G.num.person
    if DB_P.opt.GaitFeatureTest_dim == 0
        [a, b]= predict(DB_G.feature.model{i},DB_P.feature.all);
    else
        [a, b]= predict(DB_G.feature.model{i},DB_P.feature.all * DB_G.feature.pca_mat);
    end
    label(i) = a;
    score(i) = abs(b(1));
end
DB_R.score = label.*score;


end