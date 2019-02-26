%% Change detail methods

function DB = SetNames(DB)

DB.opt.proj_method = [1,1,1]; % ON/OFF, [M, L, T]
DB.opt.not_estimate_phase = 0;

%% Various feature extraction methods
switch DB.opt.GaitFeatureMethod
    case 1, DB.opt.name_feat = '(1) Proposed, (Position vector)';
        switch DB.opt.method_feat_sub 
            case 1 % Proposed method
                DB.opt.proj_method = [1,1,1]; % ON/OFF, [M, L, T]
            case 2
                DB.opt.proj_method = [1,0,0]; % ON/OFF, [M, L, T]
                DB.opt.name_feat = [DB.opt.name_feat, '-Projection(M)'];
            case 3
                DB.opt.proj_method = [0,1,0]; % ON/OFF, [M, L, T]
                DB.opt.name_feat = [DB.opt.name_feat, '-Projection(L)'];
            case 4
                DB.opt.proj_method = [0,0,1]; % ON/OFF, [M, L, T]
                DB.opt.name_feat = [DB.opt.name_feat, '-Projection(T)'];
            case 5
                DB.opt.proj_method = [1,1,0]; % ON/OFF, [M, L, T]
                DB.opt.name_feat = [DB.opt.name_feat, '-Projection(ML)'];
            case 6
                DB.opt.proj_method = [1,0,1]; % ON/OFF, [M, L, T]
                DB.opt.name_feat = [DB.opt.name_feat, '-Projection(MT)'];
            case 7
                DB.opt.proj_method = [0,1,1]; % ON/OFF, [M, L, T]
                DB.opt.name_feat = [DB.opt.name_feat, '-Projection(LT)'];
        end
    case 2, DB.opt.name_feat = '(2) Kas, (Euler angle)';
    case 3, DB.opt.name_feat = '(3) Ahmed, (JRD, JRA)';
    case 4, DB.opt.name_feat = '(4) Preis, (13 features)';
    case 5, DB.opt.name_feat = '(5) Ball, (18 features)';
    case 6, DB.opt.name_feat = '(6) Skeleton distance';
    case 7, DB.opt.name_feat = '(7) Static, (8 features)';
end

if DB.opt.new_temporal_feature == 2 && DB.opt.GaitFeatureMethod ~= 1
    DB.opt.new_temporal_feature = 0;
end

%% Various gait recognition methods
switch DB.opt.GaitRecogMethod 
    case 1 % Our recognition method (Robust frame-level matching)
        DB.opt.name_rec = '(1) Robust frame-level matching';
    	switch DB.opt.method_rec_sub % 1 : prop, 2 : LM(no phase), 3 : NN(no phase)
            case 1
                DB.opt.name_rec = [DB.opt.name_rec, ', (Default, G-TLM, P-fusion)'];
                DB.opt.LinearMatching = 1; % 1 : LM, 2: min
                DB.opt.quality = 1; % 1 : quality (o), 2 : quality (x)
                DB.opt.score = 1; % 1 : P-fusion, 2 : 1-fusion, 0 : majority
            case 2
                DB.opt.name_rec = [DB.opt.name_rec, ', (GP-TLM, P-fusion)'];
                DB.opt.LinearMatching = 1; % 1 : LM, 0: min
                DB.opt.quality = 2; % 1 : quality (o), 0 : quality (x)
                DB.opt.score = 1; 
            case 3
                DB.opt.name_rec = [DB.opt.name_rec, ', (1-TLM, P-fusion)'];
                DB.opt.LinearMatching = 1; % 1 : LM, 0: min
                DB.opt.quality = 0; % 1 : quality (o), 0 : quality (x)
                DB.opt.score = 1; 
            case 4
                DB.opt.name_rec = [DB.opt.name_rec, ', (G-TLM, 1-fusion)'];
                DB.opt.LinearMatching = 1; % 1 : LM, 0: min
                DB.opt.quality = 1; % 1 : quality (o), 0 : quality (x)
                DB.opt.score = 2; 
            case 5 % w/o quality
                DB.opt.name_rec = [DB.opt.name_rec, ', (LM, 1-fusion)'];
                DB.opt.LinearMatching = 1; % 1 : LM, 0: min
                DB.opt.quality = 0; % 1 : quality (o), 0 : quality (x)
                DB.opt.score = 0; 
            case 6
                DB.opt.name_rec = [DB.opt.name_rec, ', (LM, Majority)'];
                DB.opt.LinearMatching = 0; % 1 : LM, 0: min
                DB.opt.quality = 0; % 1 : quality (o), 0 : quality (x)
                DB.opt.score = 0;
        end
    case 2 % WWtest + SPR / WWtest + kNN
        DB.opt.not_estimate_phase = 1;
        DB.opt.name_rec = '(2) kas';
        switch DB.opt.method_rec_sub
            case 1
                DB.opt.GaitFeatureAggregation = 1; % 1 : WWTEST, 2 : MNPD, 3 : DTW
                DB.opt.name_rec = [DB.opt.name_rec, ', (WWTEST)'];
                DB.opt.GaitFeatureTest = 1; % 1: SPR, 2: KNN, 3: NN 3: DTW+RANK LEVEL FUSION
                DB.opt.name_rec = [DB.opt.name_rec, ', (SPR)'];
            case 2
                DB.opt.GaitFeatureAggregation = 1; % 1 : WWTEST, 2 : MNPD, 3 : DTW
                DB.opt.name_rec = [DB.opt.name_rec, ', (WWTEST)'];
                DB.opt.GaitFeatureTest = 2; % 1: SPR, 2: KNN, 3: NN 3: DTW+RANK LEVEL FUSION
                DB.opt.name_rec = [DB.opt.name_rec, ', (KNN)'];
                DB.opt.GaitFeatureTest_dim = 3; % number of K (KNN) (if DB.opt.GaitFeatureTest = 2)
                DB.opt.name_rec = [DB.opt.name_rec, '-dim : ', num2str(DB.opt.GaitFeatureTest_dim)];
            case 3
                DB.opt.GaitFeatureAggregation = 1; % 1 : WWTEST, 2 : MNPD, 3 : DTW
                DB.opt.name_rec = [DB.opt.name_rec, ', (WWTEST)'];
                DB.opt.GaitFeatureTest = 3; % 1: SPR, 2: KNN, 3: NN 3: DTW+RANK LEVEL FUSION
                DB.opt.name_rec = [DB.opt.name_rec, ', (1NN)'];
            case 4
                DB.opt.GaitFeatureAggregation = 2; % 1 : WWTEST, 2 : MNPD, 3 : DTW
                DB.opt.name_rec = [DB.opt.name_rec, ', (MNPD)'];
                DB.opt.GaitFeatureTest = 1; % 1: SPR, 2: KNN, 3: NN 3: DTW+RANK LEVEL FUSION
                DB.opt.name_rec = [DB.opt.name_rec, ', (SPR)'];
            case 5
                DB.opt.GaitFeatureAggregation = 2; % 1 : WWTEST, 2 : MNPD, 3 : DTW
                DB.opt.name_rec = [DB.opt.name_rec, ', (MNPD)'];
                DB.opt.GaitFeatureTest = 2; % 1: SPR, 2: KNN, 3: NN 3: DTW+RANK LEVEL FUSION
                DB.opt.name_rec = [DB.opt.name_rec, ', (KNN)'];
                DB.opt.GaitFeatureTest_dim = 3; % number of K (KNN) (if DB.opt.GaitFeatureTest = 2)
                DB.opt.name_rec = [DB.opt.name_rec, '-dim : ', num2str(DB.opt.GaitFeatureTest_dim)];
            case 6
                DB.opt.GaitFeatureAggregation = 2; % 1 : WWTEST, 2 : MNPD, 3 : DTW
                DB.opt.name_rec = [DB.opt.name_rec, ', (MNPD)'];
                DB.opt.GaitFeatureTest = 3; % 1: SPR, 2: KNN, 3: NN 3: DTW+RANK LEVEL FUSION
                DB.opt.name_rec = [DB.opt.name_rec, ', (1NN)'];
        end
    case 3 % Histogram + GSVM
        DB.opt.not_estimate_phase = 1;
        DB.opt.name_rec = '(3) kas';
        DB.opt.GaitFeatureAggregation = 1; % 1 : HIST, 2 : MEDIAN, 3 : MAXMEANSTD
        DB.opt.name_rec = [DB.opt.name_rec, ', (histogram)'];
        DB.opt.GaitFeatureTest_dim = 0;
        DB.opt.name_rec = [DB.opt.name_rec, '-dim : ', num2str(DB.opt.GaitFeatureTest_dim)];
        switch DB.opt.method_rec_sub
            case 1
                DB.opt.GaitFeatureTest = 1; % 1 : GSVM, 2 : LSVM, 3 : RF, 4 : BAYES
                DB.opt.name_rec = [DB.opt.name_rec, ', (GSVM)'];
            case 2
                DB.opt.GaitFeatureTest = 2; % 1 : GSVM, 2 : LSVM, 3 : RF, 4 : BAYES
                DB.opt.name_rec = [DB.opt.name_rec, ', (LSVM)'];
        end
    case 4 % Rank-level fusion + majority voting
        DB.opt.name_rec = '(4) Ahmed, (DTW) / (rank-level fusion)';
        DB.opt.GaitFeatureAggregation = 3; % 1 : WWTEST, 2 : MNPD, 3 : DTW
        DB.opt.name_rec = [DB.opt.name_rec, ', (DTW)'];
        DB.opt.GaitFeatureTest = 4; % 1: SPR, 2: KNN, 3: NN 4: DTW+RANK LEVEL FUSION
        DB.opt.name_rec = [DB.opt.name_rec, ', (Rank-level fusion)'];
        DB.opt.PhaseSelection = 0;
        DB.opt.name_rec = [DB.opt.name_rec, ', (**selection 0)'];
    case 5 % Median / RF or BAYES
        DB.opt.not_estimate_phase = 1;
        DB.opt.name_rec = '(5) Preis';
        DB.opt.GaitFeatureAggregation = 2; % 1 : HIST, 2 : MEDIAN, 3 : MAXMEANSTD
        DB.opt.name_rec = [DB.opt.name_rec, ', (Median)'];
        switch DB.opt.method_rec_sub
            case 1
                DB.opt.GaitFeatureTest = 3; % 1 : GSVM, 2 : LSVM, 3 : RF, 4 : BAYES
                DB.opt.num_tree = 30;
                DB.opt.name_rec = [DB.opt.name_rec, ', (RF)'];
                DB.opt.name_rec = [DB.opt.name_rec, '-tree : ', num2str(DB.opt.num_tree)];
            case 2
                DB.opt.GaitFeatureTest = 4; % 1 : GSVM, 2 : LSVM, 3 : RF, 4 : BAYES
                DB.opt.name_rec = [DB.opt.name_rec, ', (Bayes)'];
        end
        DB.opt.PhaseSelection = 0;
        DB.opt.name_rec = [DB.opt.name_rec, ', (**selection 0)'];
    case 6 % Median / RF or BAYES
        DB.opt.not_estimate_phase = 1;
        DB.opt.name_rec = '(6) Ball';
        DB.opt.GaitFeatureAggregation = 3; % 1 : HIST, 2 : MEDIAN, 3 : MAXMEANSTD
        DB.opt.name_rec = [DB.opt.name_rec, ', (MAX, MEAN, STD)'];
        switch DB.opt.method_rec_sub
            case 1
                DB.opt.GaitFeatureTest = 3; % 1 : GSVM, 2 : LSVM, 3 : RF, 4 : BAYES
                DB.opt.num_tree = 30;
                DB.opt.name_rec = [DB.opt.name_rec, ', (RF)'];
                DB.opt.name_rec = [DB.opt.name_rec, '-tree : ', num2str(DB.opt.num_tree)];
            case 2
                DB.opt.GaitFeatureTest = 4; % 1 : GSVM, 2 : LSVM, 3 : RF, 4 : BAYES
                DB.opt.name_rec = [DB.opt.name_rec, ', (Bayes)'];
        end
    case 7 % Quality-based fusion...!
        DB.opt.name_rec = '(7) Quality-based fusion';
    	switch DB.opt.method_rec_sub             
            case {1, 2},DB.opt.name_rec = [DB.opt.name_rec, ', (1,2) TSMC12, feature fusion'];
            case 3, DB.opt.name_rec = [DB.opt.name_rec, ', (3) BTAS09, rank fusion, Q-borda count with nanson function, Q=min(PQ)'];
            case 4, DB.opt.name_rec = [DB.opt.name_rec, ', (4) BTAS12, rank fusion, Q-borda count with nanson function, Q=max(PQ)'];
            case 5, DB.opt.name_rec = [DB.opt.name_rec, ', (5) PRL15,  rank fusion, Q-borda count with nanson function, Q=statistically'];
            case 6, DB.opt.name_rec = [DB.opt.name_rec, ', (6) BTAS08, score fusion'];
            case 7, DB.opt.name_rec = [DB.opt.name_rec, ', (7) ICB05, score fusion, min-max norm'];
            case 8, DB.opt.name_rec = [DB.opt.name_rec, ', (8) ICB05, score fusion, tanh estimator'];
            % - The above experiments are described in the manuscript
            case 9, DB.opt.name_rec = [DB.opt.name_rec, ', (9) BTAS09, rank fusion, HRF with pertubation'];
            case 10, DB.opt.name_rec = [DB.opt.name_rec, ', (10) BTAS09, rank fusion, Borda count'];
            case 11, DB.opt.name_rec = [DB.opt.name_rec, ', (11) BTAS09, rank fusion, Borda count with nanson function'];
            case 12, DB.opt.name_rec = [DB.opt.name_rec, ', (12) Majority voting'];
            case 13, DB.opt.name_rec = [DB.opt.name_rec, ', (13) Weighted majority voting'];
            case 14, DB.opt.name_rec = [DB.opt.name_rec, ', (14) ICSMC12, submodal, max quality -> matching'];

        end
        
    case 8
        DB.opt.name_rec = '(8) New metric for quality validation';
    	switch DB.opt.method_rec_sub % Quality analysis (not used)
            case 1 
                DB.opt.quality_method = 2;
                DB.opt.flag_c = 1;
                DB.opt.flag_s = 1;
            case 2 
                DB.opt.quality_method = 2;
                DB.opt.flag_c = 1;
                DB.opt.flag_s = 2;
            case 3
                DB.opt.quality_method = 1;
                DB.opt.flag_c = 2;
                DB.opt.flag_s = 2;
            case 4 
                DB.opt.quality_method = 3;
                DB.opt.flag_c = 1;
                DB.opt.flag_s = 1;
            case 5 
                DB.opt.quality_method = 1;
                DB.opt.flag_c = 2;
                DB.opt.flag_s = 4;
            case 6 
                DB.opt.quality_method = 1;
                DB.opt.flag_c = 2;
                DB.opt.flag_s = 5;
            case 7 
                DB.opt.quality_method = 2;
                DB.opt.flag_c = 2;
                DB.opt.flag_s = 4;
            case 8 
                DB.opt.quality_method = 2;
                DB.opt.flag_c = 2;
                DB.opt.flag_s = 5;
            case 9
                DB.opt.quality_method = 1;
                DB.opt.flag_c = 4;
                DB.opt.flag_s = 4;
            case 10 
                DB.opt.quality_method = 1;
                DB.opt.flag_c = 4;
                DB.opt.flag_s = 5;
            case 11
                DB.opt.quality_method = 2;
                DB.opt.flag_c = 4;
                DB.opt.flag_s = 4;
            case 12
                DB.opt.quality_method = 2;
                DB.opt.flag_c = 4;
                DB.opt.flag_s = 5;
            case 13 
                DB.opt.quality_method = 3;
                DB.opt.flag_c = 2;
                DB.opt.flag_s = 4;
        end
    case 9
        DB.opt.name_rec = '(8) Sun (nearest neighbor)';
end

%% Quality measurement (Ablation studies)
if DB.opt.quality_method ~= 0
    DB.opt.name_rec = [DB.opt.name_rec, ', (qual:',  num2str(DB.opt.quality_method), '='];
    switch DB.opt.quality_method
        case 1 
            DB.opt.quality_G_method = 2; 
            DB.opt.quality_G_score = 0.5; % Threshold
            DB.opt.quality_P_method = 2;
            DB.opt.quality_P_score = 0.5;
        case 2
            DB.opt.quality_G_method = 2; 
            DB.opt.quality_G_score = 1;
            DB.opt.quality_P_method = 2;
            DB.opt.quality_P_score = 0.5;
        case 3 
            DB.opt.quality_G_method = 2; 
            DB.opt.quality_G_score = 0.5;
            DB.opt.quality_P_method = 2;
            DB.opt.quality_P_score = 1;
        case 4 
            DB.opt.quality_G_method = 2; 
            DB.opt.quality_G_score = 1;
            DB.opt.quality_P_method = 2;
            DB.opt.quality_P_score = 1;
        case 5
            DB.opt.quality_G_method = 1; 
            DB.opt.quality_G_score = 0.7;
            DB.opt.quality_P_method = 1;
            DB.opt.quality_P_score = 0.7;
        case 6
            DB.opt.quality_G_method = 1; 
            DB.opt.quality_G_score = 1;
            DB.opt.quality_P_method = 1;
            DB.opt.quality_P_score = 0.7;
        case 7
            DB.opt.quality_G_method = 1; 
            DB.opt.quality_G_score = 0.7;
            DB.opt.quality_P_method = 1;
            DB.opt.quality_P_score = 1;
        case 8
            DB.opt.quality_G_method = 1; 
            DB.opt.quality_G_score = 1;
            DB.opt.quality_P_method = 1;
            DB.opt.quality_P_score = 1;
	end
    
    DB.opt.name_rec = [DB.opt.name_rec, 'Gm:',  num2str(DB.opt.quality_G_method), ','];
    DB.opt.name_rec = [DB.opt.name_rec, 'Gs:',  num2str(DB.opt.quality_G_score), ','];
    DB.opt.name_rec = [DB.opt.name_rec, 'Pm:',  num2str(DB.opt.quality_P_method), ','];
    DB.opt.name_rec = [DB.opt.name_rec, 'Ps:',  num2str(DB.opt.quality_P_score), ')'];
end


end