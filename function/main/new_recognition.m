function DB_R = new_recognition(DB_R, DB_P, DB_G)


feature_P = DB_P.feature.all;
phase_P = DB_P.feature.phase;
metric_P = DB_P.feature.metric;
feature_G = DB_G.feature.all;
phase_G = DB_G.feature.phase;
label_G = DB_G.feature.label;
metric_G = DB_G.feature.metric;
video_G = DB_G.feature.video;

if DB_P.opt.PhaseDivisionNumber
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
            all_dist = pdist2(fp, fg, 'cityblock');
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
    all_dist = pdist2(fp, fg, 'cityblock');
    all_dist(isnan(all_dist)) = 100000000;
    all_dist(isinf(all_dist)) = 100000000;
    all_dist(0==(all_dist)) = eps;
    DB_R.dist{1} = all_dist;
    DB_R.metric_P{1} = metric_P;
    DB_R.label_G{1} = label_G;
    DB_R.metric_G{1} = metric_G;
    DB_R.video_G{1} = video_G;
end

num_frame = 0;
for i = 1 : numel(DB_R.dist)
    num_frame = num_frame + size(DB_R.dist{i}, 1);
end

dim = 2;
Vp = zeros(num_frame, dim+1);
Rp = zeros(num_frame, dim);
cnt = 1;

Cp = zeros(num_frame, 2);
mean_p = zeros(num_frame, 1);

for i = 1 : numel(DB_R.dist)
    if numel(DB_R.dist{i})
        DB_R.metric_P{i}(DB_R.metric_P{i}>DB_R.opt.quality_P_score) = 1;
        DB_R.metric_G{i}(DB_R.metric_G{i}>DB_R.opt.quality_G_score) = 1;
        X = DB_R.dist{i};
        if size(X, 1) > size(X, 2)
            sum_dist = sum(X, 2);
            [~, max_idx] = sort(sum_dist, 'descend');
            delete_idx = max_idx(1:size(X, 1) - size(X, 2));
            X(delete_idx, :) = [];
            DB_R.metric_P{i}(delete_idx) = [];
            Vp(end-numel(delete_idx)+1:end, :) = [];
            Rp(end-numel(delete_idx)+1:end, :) = [];
            Cp(end-numel(delete_idx)+1:end, :) = [];
            mean_p(end-numel(delete_idx)+1:end, :) = [];
        end

        num_frame_ph = size(X, 1);
        local_idx = cnt:cnt+num_frame_ph-1;
        Vp(local_idx, dim+1) = DB_R.metric_P{i};

        X_ori = X;

        Q_ratio_P = (repmat(DB_R.metric_P{i}, [1, size(X, 2)])+eps);
        Q_ratio_G = (repmat(DB_R.metric_G{i}', [size(X, 1), 1])+eps);
        switch DB_R.opt.flag_c
            case 1
                Q_ratio = Q_ratio_P./ Q_ratio_G;
                X = X.*Q_ratio;
            case 2
                Q_ratio = 1./ Q_ratio_G;
                X = X.*Q_ratio;
            case 3
                Q_ratio = Q_ratio_P./ Q_ratio_G;
                Q_ratio(X < 1) = 1./Q_ratio(X < 1);
                X = X.^Q_ratio;
            case 4
                Q_ratio = 1./ Q_ratio_G;
                Q_ratio(X < 1) = 1./Q_ratio(X < 1);
                X = X.^Q_ratio;
        end
        
        constraint = ones(size(X));

        for j = 1 : dim % multiple linear matching
            Xd = discretisationMatching_hungarian(-X, constraint); % discrete
            for r = 1 : num_frame_ph
                Vp(local_idx(r), j) = X_ori(r, find(Xd(r, :) == 1)); % value of solution for each frame
                Rp(local_idx(r), j) = DB_R.label_G{i}(Xd(r, :) == 1); % p index of solution for each frame
                mean_p(local_idx(r)) = mean(X_ori(r, find(Xd(r, :) == 0)));
            end
            if j == 1
                constraint_idx = Rp(local_idx, j) == DB_R.label_G{i}';
                constraint(constraint_idx) = 0;
            end
            
            
        end
        cnt = cnt + num_frame_ph;
    end
end

DB_R.Rp = Rp;
DB_R.Vp = Vp;

d1 = DB_R.Vp(:, 1)+eps;
d2 = DB_R.Vp(:, 2)+eps;
qual_p = DB_R.Vp(:, 3);
logical_on = d1 < d2;


switch DB_R.opt.flag_s
    case 1, score = (d2./d1).*(1./d1);
    case 2, score = qual_p.*(d2./d1).*(1./d1);
    case 3, score = ((d2./d1).^qual_p).*(1./d1);
    case 4, score = ((d2-d1)./d2).*(1./d1);
    case 5, score = qual_p.*((d2-d1)./d2).*(1./d1);
end


score = score.*logical_on;
        

label_estim = DB_R.Rp(:,1);
score_all = zeros(1, DB_R.num.G_person);
for i = 1 : numel(label_estim)
    score_all(label_estim(i)) = score_all(label_estim(i)) + score(i);
end
DB_R.score = score_all;

end