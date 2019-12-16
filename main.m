% ==============================
% Please refer to README file!
% ==============================
% [1] Basic experiment : DB_R.flag_gen = {'basic'};
% [2] Set of experiements : DB_R.flag_gen = exp0; (or exp1, 2, 3, 4, etc..)
% [3] Experiements with manual parameters : DB_R.manual = 1;
%     & change parameters in the SetParameters function.
% ==============================
% You must download the datasets

clc;
fclose all;
close all;
clear;
addpath(genpath('.'));

% Sets of experiments
exp0 = {'D', 'Ap', 'Aq', 'Fp', 'Rp', 'T1', 'T2'}; % exp0 : Ablation studies of our method
exp1 = {'Ao', 'Fo', 'Ro', 'Rq', 'Rq_sample'}; % exp1 : Ablation studies of other methods
exp2 = {'E', 'EE', 'LO', 'UO', 'MO', 'MOE'}; % exp2 : Robustness evaluation (noise-robust)
exp3 = {'G', 'Gs1', 'Gs2', 'Ps1', 'Ps2'}; % exp3 : Robustness evaluation (data-robust)
exp4 = {'REAL1', 'REAL2', 'OPENSET1', 'OPENSET2'}; % exp4 : Extension to real-world applications

DB_R.flag_gen = cat(2, exp0, exp1, exp2, exp3, exp4); 
% DB_R.flag_gen = {'basic'};
DB_R.flag_gen = {'RFM'};
DB_R.restart_num = 0; 
DB_R.continue = 1;
DB_R.reverse = 0;
DB_R.sampling = [];
DB_R = SetFlagGen(DB_R); % Experimental set generator

%% Overall experiments (various sets)
while DB_R.continue <= size(DB_R.flag_total, 2)
    fprintf('--------------------------------------------------\n');
    fprintf(['[', num2str(DB_R.continue), '/ ', num2str(numel(DB_R.flag_total(1, :))), '] computing.......... \n']);
    fprintf('--------------------------------------------------\n');
    DB_R.flag_situation = DB_R.flag_total(2, DB_R.continue);
    DB_R.flag_method = DB_R.flag_total(3, DB_R.continue);
    DB_R.iterMAX = 50; % Iteration number (50 was used for regular paper)
    DB_R.iter = 1; % Counting number (Do not change)
    DB_R.manual = 0; % manual parameter (change parameters in function SetParameters)
    if sum(DB_R.flag_method == [1, 2, 11, 12, 60, 61, 90, 91, 92]), DB_R.iterMAX = 50; end % For fast testing (SPR is too slow... but, not used in regular paper)
    if DB_R.flag_situation >= 110 && DB_R.flag_situation <= 140, DB_R.iterMAX = 10; end % DB3 & DB4 (fixed set in exp protocol)
    
    % Main iteration for gait recognition 
    while DB_R.iter <= DB_R.iterMAX
        [DB, DB_P, DB_G] = SetParameters(DB_R);                 % 1) Experimental setting
        if DB.break, break, end
        [~, DB_P, DB_G] = DataConstruction(DB, DB_P, DB_G);     % 2) Data construction
        DB_G = GalleryRegistration(DB_G);                       % 3) Registration (gallery sets)
        DB_R = ProbeIdentification(DB_R, DB_P, DB_G);           % 4) Verification (probe sets)
        DB_R = ResultAnalysis(DB_R, DB_P, DB_G);                % 5) Results analysis
        clear DB_P, clear DB_G
    end
    DB_R = SaveTheLog(DB_R, DB); % Save the log
    
    % Refreshing
    clear DB;
    if DB_R.manual == 1, tmp = size(DB_R.flag_total, 2) + 1;
    else, tmp = DB_R.continue + 1;
    end
    tmp2 = DB_R.flag_total;
    clear DB_R, DB_R.continue = tmp;
    DB_R.flag_total = tmp2;
end