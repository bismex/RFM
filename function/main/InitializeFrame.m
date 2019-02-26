function DB_Pf = InitializeFrame(DB_R, DB_P, f, cnt)

DB_Pf.opt = DB_P.opt;
DB_Pf.num = DB_P.num;
DB_Pf.num.person = 1;
DB_Pf.num.video = 1;
DB_Pf.num.frame = DB_R.idx_frame(f);
local_idx = DB_P.feature.srt_idx(cnt) : DB_P.feature.end_idx(cnt);
all_idx = 1 : DB_P.num.frame;
all_idx(local_idx) = [];
DB_Pf.feature = DB_P.feature;
DB_Pf.feature.all(all_idx, :) = [];
DB_Pf.feature.label(all_idx, :) = [];
DB_Pf.feature.video(all_idx, :) = [];
DB_Pf.feature.phase(all_idx) = [];
DB_Pf.feature.metric(all_idx, :) = [];
if DB_P.opt.GaitRecogMethod == 1 && f ~=1
    DB_Pf.num.frame = DB_R.idx_frame(f) - DB_R.idx_frame(f-1);
    DB_Pf.T.param.node{1, 1}.num = DB_R.idx_frame(f) - DB_R.idx_frame(f-1);
    DB_Pf.feature.srt_idx = DB_R.idx_frame(f-1) + 1;
    DB_Pf.feature.end_idx = DB_R.idx_frame(f);
else
    DB_Pf.num.frame = DB_R.idx_frame(f);
    DB_Pf.T.param.node{1, 1}.num = DB_R.idx_frame(f);
    DB_Pf.feature.srt_idx = 1;
    DB_Pf.feature.end_idx = DB_R.idx_frame(f);
end
DB_Pf.feature.all = DB_Pf.feature.all(DB_Pf.feature.srt_idx : DB_Pf.feature.end_idx, :);
DB_Pf.feature.label = DB_Pf.feature.label(DB_Pf.feature.srt_idx : DB_Pf.feature.end_idx, :);
DB_Pf.feature.video = DB_Pf.feature.video(DB_Pf.feature.srt_idx : DB_Pf.feature.end_idx, :);
DB_Pf.feature.phase = DB_Pf.feature.phase(DB_Pf.feature.srt_idx : DB_Pf.feature.end_idx, :);
DB_Pf.feature.metric = DB_Pf.feature.metric(DB_Pf.feature.srt_idx : DB_Pf.feature.end_idx, :);

% for evidence
DB_Pf.SC.node = DB_P.SC.node;

end