clc;
fclose all;
close all;
clear;
addpath(genpath('.'));
folder_name = 'result';
save_folder_name = 'result_rp_curve2';


exp00 = {'D', 'Ap', 'Aq'}; % exp0 : Ablation studies of our method
exp01 = {'Fp', 'Rp', 'T1', 'T2'};
exp10 = {'Ao', 'Fo', 'Rq'}; % exp1 : Ablation studies of other methods
exp11 = {'Ro'};
exp20 = {'E', 'EE', 'LO'}; % exp2 : Robustness evaluation (noise-robust)
exp21 = {'UO', 'MO', 'MOE'};
exp30 = {'G', 'Gs1', 'Gs2'}; % exp3 : Robustness evaluation (data-robust)
exp31 = {'Ps1', 'Ps2'};
exp40 = {'REAL1', 'REAL2'}; % exp4 : Extension to real-world applications
exp41 = {'OPENSET1', 'OPENSET2'}; 
exp50 = {'time_measure1', 'time_measure2', 'time_measure3'};
exp60 = {'D+', 'A+', 'F+',  'R+', 'T+'};

DB_R.flag_gen = cat(2, exp00, exp01, exp10, exp11, exp20, exp21, exp30, exp31, exp40, exp41, exp50, exp60);
DB_R.flag_gen = {'RPcurve1', 'RPcurve2', 'RPcurve3', 'RPcurve4', 'RPcurve5', 'RPcurve6', 'RPcurve7', 'RPcurve8'};
file_name = dir(['./',folder_name,'/*.txt']);
DB_R.restart_num = 0; 
DB_R.continue = 1;
DB_R.reverse = 0;
DB_R.sampling = [];


DB_R = SetFlagGen(DB_R); % Experimental set generator
flag_total = DB_R.flag_total;

case_name = zeros(1, numel(file_name));
case_accuracy1 = zeros(1, numel(file_name));
case_accuracy2 = zeros(1, numel(file_name));
case_accuracy3 = zeros(1, numel(file_name));
case_accuracy4 = zeros(1, numel(file_name));
case_accuracy5 = zeros(1, numel(file_name));
case_std = zeros(1, numel(file_name));
case_time1 = zeros(1, numel(file_name));
case_time2 = zeros(1, numel(file_name));
case_vps1 = zeros(1, numel(file_name));
case_vps2 = zeros(1, numel(file_name));
case_fps1 = zeros(1, numel(file_name));
case_fps2 = zeros(1, numel(file_name));
flag_total = cat(1, flag_total, zeros(8, size(flag_total, 2)));
% flag_total(1, :) = 1:numel(flag_total(1, :));

for i = 1 : numel(file_name)
    name = file_name(i).name;
    case_name(i) = str2num(name(2:strfind(name, '][') - 1));
    if ~isempty(strfind(name, '[@4]'))
        idx = strfind(name, '%_[');
        case_accuracy1(i) = str2num(name(strfind(name, ']([@1]') + 6 : idx(1)-1));
        case_accuracy2(i) = str2num(name(strfind(name, '[@2]') + 4 : idx(2)-1));
        case_accuracy3(i) = str2num(name(strfind(name, '[@3]') + 4 : idx(3)-1));
        case_accuracy4(i) = str2num(name(strfind(name, '[@4]') + 4 : idx(4)-1));
        case_accuracy5(i) = str2num(name(strfind(name, '[@5]') + 4 : strfind(name, '%)_')-1));
        name2 = name(strfind(name, '(std=') + 5 : strfind(name, ')_(time=')-1);
        case_std(i) = str2num(name2);
    else
        if ~isempty(strfind(name, ']([@1]')) % latest version format
            idx = strfind(name, '%_[');
            case_accuracy1(i) = str2num(name(strfind(name, ']([@1]') + 6 : idx(1)-1));
            case_accuracy2(i) = str2num(name(strfind(name, '[@2]') + 4 : idx(2)-1));
            case_accuracy3(i) = str2num(name(strfind(name, '[@3]') + 4 : strfind(name, '%)_')-1));
            name2 = name(strfind(name, '(std=') + 5 : strfind(name, ')_(time=')-1);
            case_std(i) = str2num(name2);
        else
            case_accuracy1(i) = str2num(name(strfind(name, '](') + 2 : strfind(name, '%-')-1));
            case_accuracy2(i) = str2num(name(strfind(name, '%-') + 2 : strfind(name, '%)_')-1));
        end
    end
    name2 = name(strfind(name, '(time=') + 6 : strfind(name, ')_(vps')-1);
    case_time1(i) = str2num(name2(1:strfind(name2, '-')-1));
    case_time2(i) = str2num(name2(strfind(name2, '-')+1:end));
    name2 = name(strfind(name, '(vps=') + 5 : strfind(name, ')_(fps')-1);
    case_vps1(i) = str2num(name2(1:strfind(name2, '-')-1));
    case_vps2(i) = str2num(name2(strfind(name2, '-')+1:end));
    name2 = name(strfind(name, '(fps=') + 5 : strfind(name, ').txt')-1);
    case_fps1(i) = str2num(name2(1:strfind(name2, '-')-1));
    case_fps2(i) = str2num(name2(strfind(name2, '-')+1:end));
end
% case_name = 1:numel(flag_total(1, :));

DB_local = DB_R;
case_total = zeros(1, size(flag_total, 2));
for j = 1 : numel(DB_R.flag_gen)
    DB_local.flag_gen = DB_R.flag_gen(j);
    DB_local = SetFlagGen(DB_local);
    flag_total_local = DB_local.flag_total;
    idx_total = flag_total_local(1, :);
    for k = 1 : numel(idx_total)
        case_total(flag_total(1, :) == idx_total(k)) = j;
    end
end

idx_all = [];
idx_all2 = [];
x_idx_all = [];
for i = 1 : size(flag_total, 2)
%     idx = find(flag_total(1, :) == case_name(i));
    idx = find(flag_total(1, i) == case_name);
    if numel(idx)
        if numel(idx)>1
            idx_all2 = cat(1, idx_all2, flag_total(1, i));
            fprintf([DB_R.flag_gen{case_total(i)},' => ', num2str(flag_total(1, i)), ' is duplicated\n']);
        end
        idx_all = cat(1, idx_all, flag_total(1, i));
        idx = idx(1);
        flag_total(4, i) = case_accuracy1(idx);
        flag_total(5, i) = case_accuracy2(idx);
        flag_total(6, i) = case_accuracy3(idx);
        flag_total(7, i) = case_accuracy4(idx);
        flag_total(8, i) = case_accuracy5(idx);
        flag_total(9, i) = case_std(idx);
        flag_total(10, i) = case_time1(idx);
        flag_total(11, i) = case_time2(idx);
        flag_total(12, i) = case_vps1(idx);
        flag_total(13, i) = case_vps2(idx);
        flag_total(14, i) = case_fps1(idx);
        flag_total(15, i) = case_fps2(idx);
    else
        x_idx_all = cat(1, x_idx_all, flag_total(1, i));
        fprintf([DB_R.flag_gen{case_total(i)},' => ',num2str(flag_total(1, i)), ' is not exist\n']);
    end
end

fprintf('--------------------------------------------------------------------\n')
fprintf('--------------------------------------------------------------------\n')
% exist_idx = case_total(idx_all);
% not_exist_idx = case_total(x_idx_all);

for i = 1 : numel(DB_R.flag_gen)
    num = sum(case_total == i);
    idx = flag_total(1, case_total == i);
    v1 = intersect(idx_all, idx);
    v2 = intersect(x_idx_all, idx);
    fprintf(['[', num2str(i), '] '])
    if numel(v2)
        fprintf([DB_R.flag_gen{i}, ' is not completed ', '( ', num2str(numel(v1)), ' / ', num2str(num), ' ) : '])
        for j = 1 : numel(v2)
            fprintf([num2str(v2(j)), ' '])
        end
        fprintf('\n');
    else
        fprintf([DB_R.flag_gen{i}, ' is completed ', '( ', num2str(numel(v1)), ' / ', num2str(num), ' )\n'])
    end
end


end_idx = find(diff([flag_total(1, :), 0])~=1);
start_idx = [0, end_idx(1:end-1)] + 1;
case_mat = cell(1, numel(end_idx));
for i = 1 : numel(end_idx)
    case_mat{i} = flag_total(:, start_idx(i):end_idx(i));
end

case_name = {'Name', 'Situation', 'Method', 'Accuracy1', 'Accuracy2', 'Accuracy3',  'Accuracy4', 'Accuracy5','std', 'Time(g)', 'Time(p)', 'vps(g)', 'vps(p)', 'fps(g)', 'fps(p)'};
for j = 4 : 12
    cnt = 2;
    for i = 1 : numel(case_mat)
        sample = case_mat{i};
        case1 = sample(2, :);
        case2 = sample(3, :);
        num_case2 = sum(case1==case1(1));
        num_case1 = sum(case2==case2(1));
        start_idx = 1:num_case2:num_case1*num_case2;
        end_idx = num_case2:num_case2:num_case1*num_case2;
        sample_mat = [];
        for s = 1 : numel(start_idx)
            sample_mat = cat(1, sample_mat, sample(j, start_idx(s):end_idx(s))); 
        end
        sample_mat = cat(1, unique(case2), sample_mat);
        sample_mat = cat(2, [i, unique(case1)]', sample_mat);
        num_row = size(sample_mat, 1);
        xlswrite([save_folder_name,'.xls'], DB_R.flag_gen{i}, case_name{j}, ['A', num2str(cnt-1)])
        xlswrite([save_folder_name,'.xls'], sample_mat, case_name{j}, ['A', num2str(cnt)])
        
        cnt = cnt + num_row + 4;
    end
end



