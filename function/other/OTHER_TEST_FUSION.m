function DB_R = OTHER_TEST_FUSION(DB_R, DB_P, DB_G)

switch DB_R.opt.method_rec_sub
    case {7, 8}
        score_gal = zeros(1, DB_R.num.G_person);
        for ph = 1 : numel(DB_R.dist)
            metric_P = DB_R.metric_P{ph};
            label_G = DB_R.label_G{ph};
            dist = DB_R.dist{ph};
            if ~isempty(dist)
                sol_mat = [];
                for g = 1 : DB_R.num.G_person
                    idx_local = find(label_G == g);
                    dist_local = dist(:, idx_local);
                    score_local = exp(-dist_local/DB_R.num.G_person); % parameter!
                    sol_vec = max(score_local')';
                    sol_mat = cat(2, sol_mat, sol_vec);
                end
                % score normalization (min-max normalization)
                if DB_R.opt.method_rec_sub == 7
                    min_sol = repmat(min(sol_mat, [], 2), [1, size(sol_mat, 2)]);
                    max_sol = repmat(max(sol_mat, [], 2), [1, size(sol_mat, 2)]);
                    sol_mat = (sol_mat - min_sol)./(max_sol - min_sol);
                elseif DB_R.opt.method_rec_sub == 8
                    mean_sol = repmat(mean(sol_mat, 2), [1, size(sol_mat, 2)]);
                    std_sol = zeros(size(mean_sol));
                    for i = 1 : size(sol_mat, 1)
                         std_sol(i, :) = std(sol_mat(i, :));
                    end
                    sol_mat = 0.5 * (tanh(0.01 * (sol_mat - mean_sol)./std_sol)+1);
                end

                weight_mat = repmat(metric_P, [1, size(sol_mat, 2)]);
                score_gal = score_gal + sum(weight_mat.*sol_mat, 1);
            end
        end
        DB_R.score = score_gal;
    case 6
        dist_gal = zeros(1, DB_R.num.G_person);
        for ph = 1 : numel(DB_R.dist)
            metric_P = DB_R.metric_P{ph};
            label_G = DB_R.label_G{ph};
            video_G = DB_R.video_G{ph};
            dist = DB_R.dist{ph};
            if ~isempty(dist)
                sol_mat = [];
                for g = 1 : DB_R.num.G_person
                    idx_local = find(label_G == g);
                    for v = 1 : DB_R.num.G_video
                        idx_local2 = idx_local(find(video_G(idx_local) == v));
                        dist_local = dist(:, idx_local2);
                        sol_vec = min(dist_local')';
                        sol_mat = cat(2, sol_mat, sol_vec);
                    end
                end
                weight_mat = repmat(metric_P, [1, size(sol_mat, 2)]);
                dist_all = weight_mat.*sol_mat;
                dist_all = sum(dist_all, 1);
                for g = 1 : DB_R.num.G_person
                    idx_local = (g-1)*DB_R.num.G_video + 1 : (g-1)*DB_R.num.G_video + 2;
                    dist_gal(g) = dist_gal(g) + min(dist_all(idx_local));
                end
            end
        end
        DB_R.score = exp(-dist_gal/DB_R.num.G_person);
    case {3, 4, 5, 9, 10, 11}
        score_gal = zeros(1, DB_R.num.G_person);
        for ph = 1 : numel(DB_R.dist)

            label_G = DB_R.label_G{ph};
            dist = DB_R.dist{ph};
            if ~isempty(dist)
                sol_mat = [];
                if sum(DB_R.opt.method_rec_sub == [3, 4])
                    quality_G = [];
                elseif DB_R.opt.method_rec_sub == 5
                    confidence = zeros(size(dist, 1), 2);
                    [confidence(:, 1), idx] = min(dist, [], 2);
                    for i = 1 : numel(idx)
                        tmp = dist(i, :);
                        tmp(idx(i)) = [];
                        confidence(i, 2) = mean(tmp);
                    end
                    confidence = abs(confidence(:, 1) - confidence(:, 2))./confidence(:, 2);
                    confidence = repmat(confidence, [1, DB_R.num.G_person]);
                end
                for g = 1 : DB_R.num.G_person
                    idx_local = find(label_G == g);
                    dist_local = dist(:, idx_local);
                    [sol_vec, idx] = min(dist_local, [], 2);

                    if sum(DB_R.opt.method_rec_sub == [3, 4])
                        metric_G = DB_R.metric_G{ph}(idx_local(idx));
                        quality_G = cat(2, metric_G, quality_G);
                    end
                    sol_mat = cat(2, sol_mat, sol_vec);
                end

                for i = 1 : size(sol_mat, 1) % minimum is best
                    [~, rank_idx] = sort(sol_mat(i, :), 'ascend');
                    rank_idx2 = 1 : DB_R.num.G_person;
                    rank_idx(rank_idx(rank_idx2)) = rank_idx2;
                    sol_mat(i, :) = rank_idx;
                end

                if sum(DB_R.opt.method_rec_sub == [3, 4])
                    metric_P = DB_R.metric_P{ph};
                    quality_P = repmat(metric_P, [1, size(sol_mat, 2)]);
                end

                switch DB_R.opt.method_rec_sub
                    case 3
                        sol_rank = sum(sol_mat.*min(quality_P, quality_G), 1);
                    case 4
                        sol_rank = sum(sol_mat.*max(quality_P, quality_G), 1);
                    case 5
                        sol_rank = sum(sol_mat.*confidence, 1);
                    case 9
                        sol_rank = min(sol_mat, [], 1) + sum(sol_mat, 1)/(size(sol_mat, 1)*DB_R.num.G_person);
                    case 10
                        sol_rank = sum(sol_mat, 1);
                    case 11
                        sol_mat(sol_mat==DB_R.num.G_person) = 0;
                        sol_rank = sum(sol_mat, 1);
                end

                score_gal = score_gal + sol_rank;
            end
        end
        DB_R.score = exp(-score_gal/DB_R.num.G_person);
    case {12, 13}
        score_gal = zeros(1, DB_R.num.G_person);
        for ph = 1 : numel(DB_R.dist)
            metric_P = DB_R.metric_P{ph};
            dist = DB_R.dist{ph};
            label_G = DB_R.label_G{ph};
            if ~isempty(dist)
                [~, idx] = min(dist, [], 2);
                sol_vec = label_G(idx);
                for g = 1 : DB_R.num.G_person
                    if DB_R.opt.method_rec_sub == 12
                        score_gal(g) = score_gal(g) + sum(sol_vec == g);
                    elseif DB_R.opt.method_rec_sub == 13
                        score_gal(g) = score_gal(g) + sum((sol_vec == g).*metric_P);
                    end
                end
            end
        end
        DB_R.score = score_gal;
    case {14}

        score_gal = zeros(1, DB_R.num.G_person);
        dist_mat = zeros(numel(DB_R.dist), DB_R.num.G_person);
        qual_mat = zeros(numel(DB_R.dist), DB_R.num.G_person);
        for ph = 1 : numel(DB_R.dist)
            label_G = DB_R.label_G{ph};
            metric_P = DB_R.metric_P{ph};
            dist = DB_R.dist{ph};
            if ~isempty(dist)
                sol_mat = [];
                for g = 1 : DB_R.num.G_person
                    idx_local = find(label_G == g);
                    dist_local = dist(:, idx_local);
                    [sol_vec, idx] = min(dist_local, [], 2);
                    metric_G = DB_R.metric_G{ph}(idx_local(idx));
                    metric_all = metric_P + metric_G;
                    max_val = max(metric_all); 
                    max_idx = find(metric_all == max_val); 
                    max_quality_sol = mean(sol_vec(max_idx));
                    dist_mat(ph, g) = max_quality_sol; 
                    qual_mat(ph, g) = max_val; 
                end
            end
        end
        
        for g = 1 : DB_R.num.G_person
            max_val = max(qual_mat(:, g)); 
            max_idx = find(qual_mat(:, g) == max_val); 
            score_gal(g) = exp(-mean(dist_mat(max_idx, g))/DB_R.num.G_person); 
        end


        DB_R.score = score_gal;

end

end