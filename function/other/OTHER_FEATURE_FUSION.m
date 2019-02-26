function DB_R = OTHER_FEATURE_FUSION(DB_R, DB_P, DB_G)


feature_P = DB_P.feature.all;
phase_P = DB_P.feature.phase;
metric_P = DB_P.feature.metric;

feature_G = DB_G.feature.all;
phase_G = DB_G.feature.phase;
label_G = DB_G.feature.label;
metric_G = DB_G.feature.metric;
video_G = DB_G.feature.video;
% video_G(:) = 1;
% DB_G.num.video = 1;
num_proto = 10 * DB_R.opt.method_rec_sub;
alpha = 1.5;
beta = 1;


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
            fp = feature_P(idx_P, :);
            metric_P_local = metric_P(idx_P);
            if num_proto == 0 || num_proto >= size(fp, 1)
                feat_weight = ones(size(fp, 1), 1);
                feat_weight = feat_weight./sum(feat_weight);
                feat_weight = repmat(feat_weight, [1, size(fp, 2)]);
            else
                [~, good_idx] = sort(metric_P_local, 'descend');
                good_idx = good_idx(1:num_proto);
                fp_good = fp(good_idx, :);
                dist_criterion = pdist2(fp, fp_good, 'euclidean');
                sum_of_dist = sum(dist_criterion, 2);
                sum_of_dist = exp(-sum_of_dist.^alpha./beta);
                feat_weight = sum_of_dist./sum(sum_of_dist);
                feat_weight = repmat(feat_weight, [1, size(fp, 2)]);
            end
            
            fp_new = sum(fp.*feat_weight, 1);
            fg_new = [];
            metric_G_new = [];
            label_G_new = [];
            video_G_new = [];
            for g = 1 : DB_G.num.person
                for v = 1 : DB_G.num.video
                    idx_G = find(phase_G==ph & label_G == g & video_G == v);
                    fg_new_local = mean(feature_G(idx_G, :), 1);
                    fg_new = cat(1, fg_new, fg_new_local);
                    metric_G_new = cat(1, metric_G_new, mean(metric_G(idx_G)));
                    label_G_new = cat(1, label_G_new, g);
                    video_G_new = cat(1, video_G_new, v);
                end
            end
            fp = fp_new;
            fg = fg_new;
            
            all_dist = pdist2(fp, fg, 'cityblock');
            
            all_dist(isnan(all_dist)) = 100000000;
            all_dist(isinf(all_dist)) = 100000000;
            all_dist(0==(all_dist)) = eps;
            
            DB_R.dist{ph} = all_dist;
            DB_R.metric_P{ph} = mean(metric_P_local);
            DB_R.metric_G{ph} = metric_G_new;
            DB_R.label_G{ph} = label_G_new;
            DB_R.video_G{ph} = video_G_new;
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
    
    if num_proto == 0 || num_proto >= size(fp, 1)
        feat_weight = ones(size(fp, 1), 1);
        feat_weight = feat_weight./sum(feat_weight);
        feat_weight = repmat(feat_weight, [1, size(fp, 2)]);
    else
        [~, good_idx] = sort(metric_P, 'descend');
        good_idx = good_idx(1:num_proto);
        fp_good = fp(good_idx, :);
        dist_criterion = pdist2(fp, fp_good, 'euclidean');
        sum_of_dist = sum(dist_criterion, 2);
        sum_of_dist = exp(-sum_of_dist.^alpha./beta);
        feat_weight = sum_of_dist./sum(sum_of_dist);
        feat_weight = repmat(feat_weight, [1, size(fp, 2)]);
    end
    
    
    fp_new = sum(fp.*feat_weight, 1);
    fg_new = [];
    metric_G_new = [];
    label_G_new = [];
    video_G_new = [];
    for g = 1 : DB_G.num.person
        for v = 1 : DB_G.num.video
            idx_G = find(label_G == g & video_G == v);
            fg_new_local = mean(feature_G(idx_G, :), 1);
            fg_new = cat(1, fg_new, fg_new_local);
            metric_G_new = cat(1, metric_G_new, mean(metric_G(idx_G)));
            label_G_new = cat(1, label_G_new, g);
            video_G_new = cat(1, video_G_new, v);
        end
    end
    fp = fp_new;
    fg = fg_new;

    all_dist = pdist2(fp, fg, 'cityblock');

    all_dist(isnan(all_dist)) = 100000000;
    all_dist(isinf(all_dist)) = 100000000;
    all_dist(0==(all_dist)) = eps;

    DB_R.dist{1} = all_dist;
    DB_R.metric_P{1} = mean(metric_P(:));
    DB_R.metric_G{1} = metric_G_new;
    DB_R.label_G{1} = label_G_new;
    DB_R.video_G{1} = video_G_new;
    
end


score_gal = zeros(1, DB_R.num.G_person);
all_dist = [];
all_quality_P = [];
all_quality_G = [];
for ph = 1 : numel(DB_R.dist)
    dist = DB_R.dist{ph};
    all_dist = cat(1, all_dist, dist);
    all_quality_P = cat(1, all_quality_P, DB_R.metric_P{ph});
    all_quality_G = cat(1, all_quality_G, DB_R.metric_G{ph});
end
final_dist = mean(all_dist, 1);
gap = size(final_dist, 2)/DB_R.num.G_person;
for g = 1 : DB_R.num.G_person
    idx = (g-1)*gap+1 : g*gap;
    score_gal(g) = exp(-min(final_dist(idx))/DB_R.num.G_person);
end

DB_R.score = score_gal;

end

