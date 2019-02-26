function DB_R = IndexingFrame(DB_R, DB_P, DB_G, p, v) % frame indexing

if DB_P.opt.realtime
    frame = DB_P.T.param.node{p, v}.num;
    DB_R.idx_frame = DB_P.opt.realtime:DB_P.opt.realtime:frame;
    if DB_R.idx_frame(end) ~= frame
        DB_R.idx_frame = cat(2, DB_R.idx_frame, frame);
    end
else
    DB_R.idx_frame = DB_P.T.param.node{p, v}.num;
end
DB_R.num_rec = numel(DB_R.idx_frame);
DB_R.num.P_person = DB_P.num.person;
DB_R.num.G_person = DB_G.num.person;
DB_R.num.P_video = DB_P.num.video;
DB_R.num.G_video = DB_G.num.video;

end