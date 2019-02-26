function DB_R = OTHER_TEST_SPR(DB_R, DB_G)

DB_R.test_vector = DB_R.test_vector * DB_G.feature.eigenvector;
label = ceil((1:DB_G.num.person*DB_G.num.video)/(DB_G.num.video));
[Class, SCI] = SRC(DB_R.test_vector, DB_G.feature.dissim, label, 1E-3);
DB_R.score(Class) = 1;

end