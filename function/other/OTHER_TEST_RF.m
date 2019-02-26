function DB_R = OTHER_TEST_RF(DB_R, DB_Pt, DB_G)

label = DB_G.feature.model.predict(DB_Pt.feature.all);
label = str2num(label{1});
DB_R.score(label) = 1;

end