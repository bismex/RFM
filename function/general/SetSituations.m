function [DB_G, DB_P, DB] = SetSituations(DB_R, DB)

if DB_R.iter == 1
    fprintf(['=======================[[  ', num2str(DB_R.flag_total(1, DB_R.continue)), '  ]]=======================\n']);
end

flag_situation = DB_R.flag_situation;

%% Registration data settings
DB_G.opt.rotation = 0;      % Rotate skeletons [0 or 1]
DB_G.opt.translation = 0;   % Translate skeletons [0 or 1]
DB_G.opt.scaling = 0;       % Change scale of skeletons [0 or 1]
DB_G.opt.error = 0;         % Pose estimation error for each joint [0 ~ 4] (%)
DB_G.opt.loss = 0;          % Lower-limb occlusion(LO) [0.2, 0.4, 0.6, 0.8] (0.2 == 20%)
                            % Upper-limb occlusion(LO) [1.2, 1.4, 1.6, 1.8] (1.2 == 20%)
                            % Mixed-limb occlusion(LO) [2.2, 2.4, 2.6, 2.8] (2.2 == 20%)
DB_G.opt.missing = 0;       % Missing data (center) [0.1~0.9]
                            % Missing data (sampling) [1.1~1.9]
                
%% Verification data settings            
DB_P.opt.rotation = 0; 
DB_P.opt.translation = 0; 
DB_P.opt.scaling = 0; 
DB_P.opt.error = 0; 
DB_P.opt.loss = 0; 
DB_P.opt.missing = 0; 

%% Special parameters
DB.opt.quat = 0; % Quaternion for CILgait dataset (not used)
DB.opt.openset_result = 0; % [Only for openset exp] 1 : precision, 2 : recall, 3 : precision & recall for seen
DB.opt.openset_score = 0; % [Only for openset exp] 
DB.opt.openset_ratio = 0; % [Only for openset exp] 
DB.opt.realtime = 0; % [Only for realtime exp]  1 / 5

%% Basic parameters
DB.num.probe = 0; % The number of probe video
DB.opt.dataset_subidx = 0; % Subidx (protocol) -> refer to NodeComposition.m

if DB.opt.dataset_idx == 1, DB.num.probe = 3;
elseif DB.opt.dataset_idx == 2, DB.num.probe = 8;
elseif DB.opt.dataset_idx == 3, DB.num.probe = 10; % num.probe is not used
elseif DB.opt.dataset_idx == 4, DB.num.probe = 10; % num.probe is not used
end
    
%% situation flag
switch flag_situation
    case 0
    %% Registration video amount(G 4/3/1)
    case 10 % 4 videos
        if DB.opt.dataset_idx == 1, DB.num.probe = 1; % V-4
        elseif DB.opt.dataset_idx == 2, DB.num.probe = 6;
        end
    case 20 % 3 videos
        if DB.opt.dataset_idx == 1, DB.num.probe = 2; % V-3
        elseif DB.opt.dataset_idx == 2, DB.num.probe = 7;
        end
    case 30 % 1 video
        if DB.opt.dataset_idx == 1, DB.num.probe = 4; % V-1
        elseif DB.opt.dataset_idx == 2, DB.num.probe = 9;
        end
    %% Data sampling(Gs) - gallery
    case 1, DB_G.opt.missing = 1.1; 
    case 2, DB_G.opt.missing = 1.2; 
    case 3, DB_G.opt.missing = 1.3;
    case 4, DB_G.opt.missing = 1.4; 
    case 5, DB_G.opt.missing = 1.5; 
    case 6, DB_G.opt.missing = 1.6; 
    case 7, DB_G.opt.missing = 1.7; 
    case 8, DB_G.opt.missing = 1.8; 
    case 9, DB_G.opt.missing = 1.9; 
    %% Missing center data(Pc) - probe (not used)
    case 11, DB_P.opt.missing = 0.1;
    case 12, DB_P.opt.missing = 0.2; 
    case 13, DB_P.opt.missing = 0.3;
    case 14, DB_P.opt.missing = 0.4; 
    case 15, DB_P.opt.missing = 0.5; 
    case 16, DB_P.opt.missing = 0.6; 
    case 17, DB_P.opt.missing = 0.7; 
    case 18, DB_P.opt.missing = 0.8; 
    case 19, DB_P.opt.missing = 0.9; 
    %% Data sampling(Ps) - probe
    case 21, DB_P.opt.missing = 1.1; 
    case 22, DB_P.opt.missing = 1.2; 
    case 23, DB_P.opt.missing = 1.3; 
    case 24, DB_P.opt.missing = 1.4; 
    case 25, DB_P.opt.missing = 1.5; 
    case 26, DB_P.opt.missing = 1.6; 
    case 27, DB_P.opt.missing = 1.7; 
    case 28, DB_P.opt.missing = 1.8; 
    case 29, DB_P.opt.missing = 1.9; 
    %% Pose estimation error(E) - probe
    case 31, DB_P.opt.error = 1;
    case 32, DB_P.opt.error = 2; 
    case 33, DB_P.opt.error = 3; 
    case 34, DB_P.opt.error = 4; 
    %% Pose estimation error(EE) - gallery
    case 35, DB_G.opt.error = 1; 
    case 36, DB_G.opt.error = 2; 
    case 37, DB_G.opt.error = 3; 
    case 38, DB_G.opt.error = 4; 
    %% Lower-limb occlusion(LO)
    case 40, DB_P.opt.loss = 0.2; 
    case 41, DB_P.opt.loss = 0.4; 
    case 42, DB_P.opt.loss = 0.6; 
    case 43, DB_P.opt.loss = 0.8; 
    %% Upper-limb occlusion(UO)
    case 50, DB_P.opt.loss = 1.2; 
    case 51, DB_P.opt.loss = 1.4; 
    case 52, DB_P.opt.loss = 1.6; 
    case 53, DB_P.opt.loss = 1.8; 
    %% Mixed-limb occlusion(MO)
    case 60, DB_P.opt.loss = 2.2; 
    case 61, DB_P.opt.loss = 2.4; 
    case 62, DB_P.opt.loss = 2.6; 
    case 63, DB_P.opt.loss = 2.8; 
    %% Mixed-limb occlusion with E3(MOE)
    case 70 % 20% error
        DB_P.opt.error = 3; 
        DB_P.opt.loss = 2.2; 
    case 71 % 40% error
        DB_P.opt.error = 3; 
        DB_P.opt.loss = 2.4; 
    case 72 % 60% error
        DB_P.opt.error = 3; 
        DB_P.opt.loss = 2.6; 
    case 73 % 80% error
        DB_P.opt.error = 3; 
        DB_P.opt.loss = 2.8; 
    %% Realtime application
    case 90, DB.opt.realtime = 1; % 1frame
    case 91, DB.opt.realtime = 5; % 5frames
        
    %% DB1 
    case 100
        DB.opt.dataset_idx = 1;
        DB.num.probe = 3;
    case 101
        DB.opt.dataset_idx = 1;
        DB.num.probe = 3;
        DB_P.opt.error = 3; 
        DB_P.opt.loss = 2.6; 
    %% DB2
    case 105
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case 106
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
        DB_P.opt.error = 3; 
        DB_P.opt.loss = 2.6; 
    %% DB3
    case 110
        DB.opt.dataset_idx = 3;
        DB.opt.dataset_subidx = 0;
    case 111
        DB.opt.dataset_idx = 3;
        DB.opt.dataset_subidx = 1;
    case 112
        DB.opt.dataset_idx = 3;
        DB.opt.dataset_subidx = 2;
    %% DB4
    case 120
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 0;
    case 121
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 1;
    case 122
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 2;
    case 123
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 3;
    case 124
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 4;
    case 125
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 5;
    case 126
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 6;
    %% DB4 + quat
    case 130
        DB.opt.quat = 1; % 1 : using 3dir, 2: using 1 dir
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 0;
    case 131
        DB.opt.quat = 1; % 1 : using 3dir, 2: using 1 dir
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 1;
    case 132
        DB.opt.quat = 1; % 1 : using 3dir, 2: using 1 dir
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 2;
    %% DB4 + quat
    case 140
        DB.opt.quat = 2; % 1 : using 3dir, 2: using 1 dir
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 0;
    case 141
        DB.opt.quat = 2; % 1 : using 3dir, 2: using 1 dir
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 1;
    case 142
        DB.opt.quat = 2; % 1 : using 3dir, 2: using 1 dir
        DB.opt.dataset_idx = 4;
        DB.opt.dataset_subidx = 2;
    case 200
        DB.opt.dataset_idx = 5;
    %% Openset scenario
    case {300, 301, 302, 303, 304, 305, 306, 307, 308}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = 0.3;
        DB.opt.openset_ratio = (flag_situation - 300 + 1) * 0.1;
    case {310, 311, 312, 313, 314, 315, 316, 317, 318}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = 0.3;
        DB.opt.openset_ratio = (flag_situation - 310 + 1) * 0.1;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case {320, 321, 322, 323, 324, 325, 326, 327, 328}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = 0.4;
        DB.opt.openset_ratio = (flag_situation - 320 + 1) * 0.1;
    case {330, 331, 332, 333, 334, 335, 336, 337, 338}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = 0.4;
        DB.opt.openset_ratio = (flag_situation - 330 + 1) * 0.1;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case {340, 341, 342, 343, 344, 345, 346, 347, 348}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = 0.5;
        DB.opt.openset_ratio = (flag_situation - 340 + 1) * 0.1;
    case {350, 351, 352, 353, 354, 355, 356, 357, 358}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = 0.5;
        DB.opt.openset_ratio = (flag_situation - 350 + 1) * 0.1;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case {360, 361, 362, 363, 364, 365, 366, 367, 368}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = 0.6;
        DB.opt.openset_ratio = (flag_situation - 360 + 1) * 0.1;
    case {370, 371, 372, 373, 374, 375, 376, 377, 378}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = 0.6;
        DB.opt.openset_ratio = (flag_situation - 370 + 1) * 0.1;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case {380, 381, 382, 383, 384, 385, 386, 387, 388, 389}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 380 + 1) * 0.1;
        DB.opt.openset_ratio = 0.5;
    case {390, 391, 392, 393, 394, 395, 396, 397, 398, 399}
        DB.opt.openset_result = 1; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 390 + 1) * 0.1;
        DB.opt.openset_ratio = 0.5;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case num2cell(400:429)
        DB.opt.openset_result = 3; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 400 + 1) * 0.05;
        DB.opt.openset_ratio = 0.1;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case num2cell(430:459)
        DB.opt.openset_result = 3; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 430 + 1) * 0.05;
        DB.opt.openset_ratio = 0.2;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case num2cell(460:489)
        DB.opt.openset_result = 3; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 460 + 1) * 0.05;
        DB.opt.openset_ratio = 0.3;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case num2cell(490:519)
        DB.opt.openset_result = 3; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 490 + 1) * 0.05;
        DB.opt.openset_ratio = 0.4;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case num2cell(520:549)
        DB.opt.openset_result = 3; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 520 + 1) * 0.05;
        DB.opt.openset_ratio = 0.5;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case num2cell(550:579)
        DB.opt.openset_result = 3; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 550 + 1) * 0.05;
        DB.opt.openset_ratio = 0.6;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case num2cell(580:609)
        DB.opt.openset_result = 3; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 580 + 1) * 0.05;
        DB.opt.openset_ratio = 0.7;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    case num2cell(610:639)
        DB.opt.openset_result = 3; % 1 : precision, 2 : recall, 3 : precision & recall for seen
        DB.opt.openset_score = (flag_situation - 610 + 1) * 0.05;
        DB.opt.openset_ratio = 0.8;
        DB.opt.dataset_idx = 2;
        DB.num.probe = 8;
    otherwise
        DB.break = 1;
end



end