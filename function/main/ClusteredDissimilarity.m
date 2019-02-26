function DB_R = ClusteredDissimilarity(DB_R, DB_P, DB_G)

feature_P = DB_P.feature.all;
phase_P = DB_P.feature.phase;
metric_P = DB_P.feature.metric;

feature_G = DB_G.feature.all;
phase_G = DB_G.feature.phase;
label_G = DB_G.feature.label;
metric_G = DB_G.feature.metric;
video_G = DB_G.feature.video;

if DB_P.opt.PhaseDivisionNumber 
    DB_P.opt.PhaseDivisionNumber = round(DB_P.opt.PhaseDivisionNumber);
    DB_R.dist = cell(1, DB_P.opt.PhaseDivisionNumber);
    DB_R.label_P = cell(1, DB_P.opt.PhaseDivisionNumber);
    DB_R.metric_P = cell(1, DB_P.opt.PhaseDivisionNumber);
    DB_R.label_G = cell(1, DB_P.opt.PhaseDivisionNumber);
    DB_R.metric_G = cell(1, DB_P.opt.PhaseDivisionNumber);
    DB_R.video_G = cell(1, DB_P.opt.PhaseDivisionNumber);
    for ph = 1 : DB_P.opt.PhaseDivisionNumber
        idx_P = find(phase_P==ph);
        if idx_P
            idx_G = find(phase_G==ph);
            fp = feature_P(idx_P, :);
            fg = feature_G(idx_G, :);
            all_dist = pdist2(fp, fg, 'cityblock'); % L1 norm
            all_dist(isnan(all_dist)) = 100000000;
            all_dist(isinf(all_dist)) = 100000000;
            all_dist(0==(all_dist)) = eps;
            
            DB_R.dist{ph} = all_dist;
            DB_R.metric_P{ph} = metric_P(idx_P);
            DB_R.label_G{ph} = label_G(idx_G);
            DB_R.metric_G{ph} = metric_G(idx_G);
            DB_R.video_G{ph} = video_G(idx_G);
        else
            DB_R.dist{ph} = [];
            DB_R.metric_P{ph} = [];
            DB_R.label_G{ph} = [];
            DB_R.metric_G{ph} = [];
            DB_R.video_G{ph} = [];
        end
    end
else
    fp = feature_P;
    fg = feature_G;
    all_dist = pdist2(fp, fg, 'cityblock');% L1 norm
    
    all_dist(isnan(all_dist)) = 100000000;
    all_dist(isinf(all_dist)) = 100000000;
    all_dist(0==(all_dist)) = eps;
    
    DB_R.dist{1} = all_dist;
    DB_R.metric_P{1} = metric_P;
    DB_R.label_G{1} = label_G;
    DB_R.metric_G{1} = metric_G;
    DB_R.video_G{1} = video_G;
end

end