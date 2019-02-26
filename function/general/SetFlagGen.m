%% Experimental set generator!

function DB = SetFlagGen(DB)

% index for DB
DB1 = [100]; % UPCV1
DB2 = [105]; % UPCV2
DB3 = [110:112]; % SDUgait
DB4 = [120:122]; % CILgait
DB_all = [DB1, DB2, DB3, DB4];
DB_error = [101, 106];
DB_all_error = [DB1, 101, DB2, 106, DB3, DB4];
exp_cases = DB.flag_gen;

DB.flag_total = [];
for i = 1 : numel(exp_cases)
    switch exp_cases{i}
        case 'DB_all', DB.flag_total = cat(2, DB.flag_total, case_gen(0, DB_all_error, 0)); 
        case 'basic', DB.flag_total = cat(2, DB.flag_total, case_gen(0, 0, 0:6));
            
        %% Ablation studies of our method (exp0)
        case 'D', DB.flag_total = cat(2, DB.flag_total, case_gen(100, [DB_all, 123:124], 0:6)); % Overall performance !! (basic experiment) ***
        case 'Ap', DB.flag_total = cat(2, DB.flag_total, case_gen(200, DB_all, 25:29)); % Alignment methods (change T_m)
        case 'Aq', DB.flag_total = cat(2, DB.flag_total, case_gen(300, [DB4+10, DB4+20], 0)); % Alignment methods (quat)
        case 'Fp', DB.flag_total = cat(2, DB.flag_total, case_gen(400, DB_all, 30:31)); % Feature extraction methods (static / dynamic)
        case 'Rp', DB.flag_total = cat(2, DB.flag_total, case_gen(500, DB_all, 50:51)); % Gait recognition
        case 'T1', DB.flag_total = cat(2, DB.flag_total, case_gen(600, DB_all, 90:92)); % Temporal segmentation methods (original) ***
        case 'T2', DB.flag_total = cat(2, DB.flag_total, case_gen(700, DB_all, 93:100)); % Temporal segmentation methods (original)
            
        %% Ablation studies of other methods (exp1)
        case 'Ao', DB.flag_total = cat(2, DB.flag_total, case_gen(1000, DB_all, 20:21)); % Alignment methods (others)
        case 'Fo', DB.flag_total = cat(2, DB.flag_total, case_gen(1100, DB_all, 40:43)); % Feature extraction methods (others)
        case 'Ro', DB.flag_total = cat(2, DB.flag_total, case_gen(1200, DB_all, 60:65)); % Gait recognition methods (others) ***
        case 'Rq', DB.flag_total = cat(2, DB.flag_total, case_gen(1300, DB_all, 70:77)); % Quality-based fusion methods
        case 'Rq_sample', DB.flag_total = cat(2, DB.flag_total, case_gen(1400, DB_all, [74, 77])); % Quality-based fusion methods
            
        %% Simulation (Pose estimation error) (exp2))
        case 'E', DB.flag_total = cat(2, DB.flag_total, case_gen(2000, 31:34, 10:16)); % Pose estimation error(E) - probe 
        case 'EE', DB.flag_total = cat(2, DB.flag_total, case_gen(2100, 35:38, 10:16)); % Pose estimation error(EE) - gallery
        case 'LO', DB.flag_total = cat(2, DB.flag_total, case_gen(2200, 40:43, 10:16)); % Lower-limb occlusion(LO)
        case 'UO', DB.flag_total = cat(2, DB.flag_total, case_gen(2300, 50:53, 10:16)); % Upper-limb occlusion(UO)
        case 'MO', DB.flag_total = cat(2, DB.flag_total, case_gen(2400, 60:63, 10:16)); % Mixed-limb occlusion(MO)
        case 'MOE', DB.flag_total = cat(2, DB.flag_total, case_gen(2500, 70:73, 10:16)); % Mixed-limb occlusion with E3(MOE)

        %% Simulation (Data amount) -> plot (exp3)
        case 'G', DB.flag_total = cat(2, DB.flag_total, case_gen(3000, [10,20,30], 0:6)); % Registration video amount(G 4/3/1)
        case 'Gs1', DB.flag_total = cat(2, DB.flag_total, case_gen(3100, 1:4, 0:6)); % Data sampling(Gs) - gallery
        case 'Gs2', DB.flag_total = cat(2, DB.flag_total, case_gen(3200, 5:7, 0:6)); % Data sampling(Gs) - gallery
        case 'Ps1', DB.flag_total = cat(2, DB.flag_total, case_gen(3300, 21:24, 0:6)); % Data sampling(Ps) - probe
        case 'Ps2', DB.flag_total = cat(2, DB.flag_total, case_gen(3400, 25:27, 0:6)); % Data sampling(Ps) - probe
            
        %% Extension to real-world applications (exp4)
        case 'REAL1', DB.flag_total = cat(2, DB.flag_total, case_gen(4000, 90, 0:6)); % Realtime application (N = 1) ***
        case 'REAL2', DB.flag_total = cat(2, DB.flag_total, case_gen(4100, 91, 0:6)); % Realtime application (N = 5) ***
        case 'OPENSET1', DB.flag_total = cat(2, DB.flag_total, case_gen(4200, [305:308, 315:318], 0)); % Openset
        case 'OPENSET2', DB.flag_total = cat(2, DB.flag_total, case_gen(4300, [325:328, 335:338], 0));
        case 'OPENSET3', DB.flag_total = cat(2, DB.flag_total, case_gen(4400, [345:348, 355:358], 0));
        case 'OPENSET4', DB.flag_total = cat(2, DB.flag_total, case_gen(4500, [365:368, 375:378], 0));
        case 'OPENSET5', DB.flag_total = cat(2, DB.flag_total, case_gen(4600, [380:381, 386:388, 390:391, 396:398], 0));
        case 'RPcurve1', DB.flag_total = cat(2, DB.flag_total, case_gen(5000, [400:429], 0)); % Openset
        case 'RPcurve2', DB.flag_total = cat(2, DB.flag_total, case_gen(5100, [430:459], 0));
        case 'RPcurve3', DB.flag_total = cat(2, DB.flag_total, case_gen(5200, [460:489], 0));
        case 'RPcurve4', DB.flag_total = cat(2, DB.flag_total, case_gen(5300, [490:519], 0));
        case 'RPcurve5', DB.flag_total = cat(2, DB.flag_total, case_gen(5400, [520:549], 0));
        case 'RPcurve6', DB.flag_total = cat(2, DB.flag_total, case_gen(5500, [550:579], 0));
        case 'RPcurve7', DB.flag_total = cat(2, DB.flag_total, case_gen(5600, [580:609], 0));
        case 'RPcurve8', DB.flag_total = cat(2, DB.flag_total, case_gen(5700, [610:639], 0));
            
        %% UPCV1+ UPCV2+
        case 'D+', DB.flag_total = cat(2, DB.flag_total, case_gen(6000, [101,106], 0:6)); % Overall performance 
        case 'A+', DB.flag_total = cat(2, DB.flag_total, case_gen(6100, DB_error, [25:29, 20:21])); % Alignment methods
        case 'F+', DB.flag_total = cat(2, DB.flag_total, case_gen(6200, DB_error, [30:31, 40:43])); % Feature extraction methods
        case 'R+', DB.flag_total = cat(2, DB.flag_total, case_gen(6300, DB_error, [50:51, 60:65, 70:77])); % Gait recognition
        case 'T+', DB.flag_total = cat(2, DB.flag_total, case_gen(6400, DB_error, [90:100])); % Temporal segmentation methods
            
        %% ETC...
        case 'time_measure1', DB.flag_total = cat(2, DB.flag_total, case_gen(7000, 100, [0:6]));
        case 'time_measure2', DB.flag_total = cat(2, DB.flag_total, case_gen(7100, 90, [0:6]));
        case 'time_measure3', DB.flag_total = cat(2, DB.flag_total, case_gen(7200, 91, [0:6]));
        case 'cross_dataset', DB.flag_total = cat(2, DB.flag_total, case_gen(7300, 200, 0:6)); 
        case 'CILmixed1', DB.flag_total = cat(2, DB.flag_total, case_gen(7400, [123, 124], 0:6)); 
        case 'CILmixed2', DB.flag_total = cat(2, DB.flag_total, case_gen(7500, [125, 126], 0:6)); 
            
        otherwise
            fprintf('Flag Generator error \n');
    end
end

% Specific addictive setting (reverse, restart, sampling ...etc..)
[~, ascend_idx] = sort(DB.flag_total(1, :), 'ascend');
DB.flag_total = DB.flag_total(:, ascend_idx);
if numel(unique(DB.flag_total(1, :))) ~= numel(DB.flag_total(1, :))
    fprintf('Warning : Case number is not unique !!\n');
end
if DB.reverse
    DB.flag_total = DB.flag_total(:, end:-1:1);
    no_idx = find(DB.flag_total(1, :) > DB.restart_num);
else
    no_idx = find(DB.flag_total(1, :) < DB.restart_num);
end
if DB.restart_num
    if no_idx
        DB.flag_total(:, no_idx) = [];
    else
        fprintf('Restart number error');
    end
end
if numel(DB.sampling)
    [~,idx,~] = intersect(DB.flag_total(1, :), DB.sampling);
    delete_idx = 1:size(DB.flag_total, 2);
    [~, find_idx, ~] = intersect(delete_idx, idx);
    delete_idx(find_idx) = [];
    DB.flag_total(:, delete_idx) = [];
end

end

