function DB_R = OTHER_TEST_BAYES(DB_R, DB_Pt, DB_G)

label = DB_G.feature.model.predict(DB_Pt.feature.all);
DB_R.score(label) = 1;

end