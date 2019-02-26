%% 4) Verification (probe sets)
% Probe sets are verified in this process.
% Thus, it is online recognition process.

function DB_R = ProbeIdentification(DB_R, DB_P, DB_G)

if DB_R.iter == 1 % Initialization
    DB_R.identification_all = zeros(DB_P.num.video * DB_P.num.person, DB_G.num.person, DB_R.iterMAX);
    DB_R.score_all = zeros(DB_P.num.video * DB_P.num.person, DB_R.iterMAX);
    DB_R.rank = zeros(DB_P.num.video * DB_P.num.person, DB_R.iterMAX);
    DB_R.opt = DB_P.opt;
    if DB_P.opt.realtime
        DB_R.rank1ratio = zeros(DB_P.num.video * DB_P.num.person, DB_R.iterMAX);
        DB_R.rank_all_mat = zeros(floor(200/DB_P.opt.realtime), DB_P.num.video * DB_P.num.person, DB_R.iterMAX);
    end
end

DB_P = GaitPoseAlignment(DB_P); % Skeleton alignment
DB_P = GaitQualityAssessment(DB_P, 1); % Gait quality assessment
DB_P = GaitFeatureExtraction(DB_P); % Feature extraction
DB_P = GaitPhaseAnalysis(DB_P, DB_G); % Phase analysis (after feature extraction)
% (the phase analysis step requires feature vector for each frame)

cnt = 1;
for p = 1 : DB_P.num.person % for each person
    for v = 1 : DB_P.num.video % for each video
        DB_R = IndexingFrame(DB_R, DB_P, DB_G, p, v); % Frame indexing
        for f = 1 : DB_R.num_rec % for realtime test
            DB_Pf = InitializeFrame(DB_R, DB_P, f, cnt); % Initialization
            DB_Pf = GaitFeatureAggregation(DB_Pf, 1); % Feature aggregation
            DB_Pf.feature.label = p;
            DB_Pf.feature.video = v;
            if DB_P.opt.GaitRecogMethod == 1 
                if f == 1 % for realtime test
                    DB_R.score = zeros(1, DB_G.num.person); 
                end
            else
                DB_R.score = zeros(1, DB_G.num.person);
            end
            % Most important function !!! (recognition)
            DB_R = TestGaitFeature(DB_R, DB_Pf, DB_G); 
            clear DB_Pf;
            if DB_P.opt.GaitRecogMethod == 1
                if f == 1 % for realtime test
                    DB_R.score_tmp = DB_R.score;
                else
                    DB_R.score = DB_R.score + DB_R.score_tmp;
                    DB_R.score_tmp = DB_R.score;
                end
            end
            [~, idx] = sort(-DB_R.score, 'ascend');
            [~, idx] = sort(idx, 'ascend'); % rank for each gallery
            if DB_P.opt.realtime % realtime
                DB_R.rank_all_mat(f, cnt, DB_R.iter) = idx(p);
                DB_R.rank1ratio(cnt, DB_R.iter) = DB_R.rank1ratio(cnt, DB_R.iter) + (idx(p)==1); % 
            end
        end
        DB_R.identification_all(cnt, :, DB_R.iter) = idx;
        if p <= numel(idx)
            DB_R.rank(cnt, DB_R.iter) = idx(p); % ranking
        end
        DB_R.score_all(cnt, DB_R.iter) = max(DB_R.score);

        % realtime
        if DB_P.opt.realtime
            DB_R.num_all_mat(cnt, DB_R.iter) = DB_R.num_rec;
            DB_R.rank1ratio(cnt, DB_R.iter) = DB_R.rank1ratio(cnt, DB_R.iter)/DB_R.num_rec; % average
        end
        cnt = cnt + 1;
    end
end

DB_R.time.rec = toc;

end