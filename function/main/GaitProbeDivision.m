function DB_Pt = GaitProbeDivision(DB_P, local_idx)

DB_Pt.opt = DB_P.opt;
DB_Pt.num = DB_P.num;
all_idx = 1 : numel(DB_P.feature.video);
all_idx(local_idx) = [];
DB_Pt.feature = DB_P.feature;
DB_Pt.feature.all(all_idx, :) = [];
DB_Pt.feature.label(all_idx, :) = [];
DB_Pt.feature.video(all_idx, :) = [];
DB_Pt.feature.phase(all_idx) = [];
DB_Pt.feature.metric(all_idx, :) = [];

end