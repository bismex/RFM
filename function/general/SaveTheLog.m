function DB_R = SaveTheLog(DB_R, DB)

if DB.break == 0
    folder_name = 'result';

    accuracy1 = num2str(round(DB_R.final_accuracy1, 2));
    accuracy2 = num2str(round(DB_R.final_accuracy2, 2));
    accuracy3 = num2str(round(DB_R.final_accuracy3, 2));
    accuracy4 = num2str(round(DB_R.final_accuracy4, 2));
    accuracy5 = num2str(round(DB_R.final_accuracy5, 2));

    if isempty(intersect(accuracy1, '.')) 
        if numel(accuracy1) == 1
            accuracy1 = ['0', accuracy1, '.00'];
        else
            accuracy1 = [accuracy1, '.00'];
        end
    else 
        [~, dot_idx, ~] = intersect(accuracy1, '.');
        if dot_idx == 2
            accuracy1 = ['0', accuracy1(1:min(4, numel(accuracy1)))];
        elseif dot_idx == 4
            accuracy1 = [accuracy1(1:4), '0'];
        elseif numel(accuracy1) == 4
            accuracy1 = [accuracy1, '0'];
        else
            accuracy1 = accuracy1(1:5);
        end
    end
    
    if isempty(intersect(accuracy2, '.')) 
        if numel(accuracy2) == 1
            accuracy2 = ['0', accuracy2, '.00'];
        else
            accuracy2 = [accuracy2, '.00'];
        end
    else 
        [~, dot_idx, ~] = intersect(accuracy2, '.');
        if dot_idx == 2
            accuracy2 = ['0', accuracy2(1:min(4, numel(accuracy2)))];
        elseif dot_idx == 4
            accuracy2 = [accuracy2(1:4), '0'];
        elseif numel(accuracy2) == 4
            accuracy2 = [accuracy2, '0'];
        else
            accuracy2 = accuracy2(1:5);
        end
    end
    
    
    if isempty(intersect(accuracy3, '.')) 
        if numel(accuracy3) == 1
            accuracy3 = ['0', accuracy3, '.00'];
        else
            accuracy3 = [accuracy3, '.00'];
        end
    else
        [~, dot_idx, ~] = intersect(accuracy3, '.');
        if dot_idx == 2
            accuracy3 = ['0', accuracy3(1:min(4, numel(accuracy3)))];
        elseif dot_idx == 4
            accuracy3 = [accuracy3(1:4), '0'];
        elseif numel(accuracy3) == 4
            accuracy3 = [accuracy3, '0'];
        else
            accuracy3 = accuracy3(1:5);
        end
    end

    if isempty(intersect(accuracy4, '.')) 
        if numel(accuracy4) == 1
            accuracy4 = ['0', accuracy4, '.00'];
        else
            accuracy4 = [accuracy4, '.00'];
        end
    else 
        [~, dot_idx, ~] = intersect(accuracy4, '.');
        if dot_idx == 2
            accuracy4 = ['0', accuracy4(1:min(4, numel(accuracy4)))];
        elseif dot_idx == 4
            accuracy4 = [accuracy4(1:4), '0'];
        elseif numel(accuracy4) == 4
            accuracy4 = [accuracy4, '0'];
        else
            accuracy4 = accuracy4(1:5);
        end
    end
    
    
    if isempty(intersect(accuracy5, '.')) 
        if numel(accuracy5) == 1
            accuracy5 = ['0', accuracy5, '.00'];
        else
            accuracy5 = [accuracy5, '.00'];
        end
    else 
        [~, dot_idx, ~] = intersect(accuracy5, '.');
        if dot_idx == 2
            accuracy5 = ['0', accuracy5(1:min(4, numel(accuracy5)))];
        elseif dot_idx == 4
            accuracy5 = [accuracy5(1:4), '0'];
        elseif numel(accuracy5) == 4
            accuracy5 = [accuracy5, '0'];
        else
            accuracy5 = accuracy5(1:5);
        end
    end
    
    
    if DB_R.opt.realtime
        accuracy_realtime = num2str(round(DB_R.final_mean_accuracy, 2));
        if isempty(intersect(accuracy_realtime, '.')) 
            if numel(accuracy_realtime) == 1
                accuracy_realtime = ['0', accuracy_realtime, '.00'];
            else
                accuracy_realtime = [accuracy_realtime, '.00'];
            end
        else 
            [~, dot_idx, ~] = intersect(accuracy_realtime, '.');
            if dot_idx == 2
                accuracy_realtime = ['0', accuracy_realtime(1:min(4, numel(accuracy_realtime)))];
            elseif dot_idx == 4
                accuracy_realtime = [accuracy_realtime(1:4), '0'];
            elseif numel(accuracy_realtime) == 4
                accuracy_realtime = [accuracy_realtime, '0'];
            else
                accuracy_realtime = accuracy_realtime(1:5);
            end
        end
    end
        
    a = num2str(DB_R.final_REG_time); % f3.2
    b = num2str(DB_R.final_REC_time); % f3.2
    c = num2str(DB_R.final_g_vps); % f3.2
    d = num2str(DB_R.final_p_vps); % f3.2
    e = num2str(DB_R.final_g_fps); % f5.0
    f = num2str(DB_R.final_p_fps); % f5.0
    if DB_R.opt.realtime
        file_name = ['[', num2str(DB_R.flag_total(1, DB_R.continue)), '][', num2str(DB.opt.dataset_idx),...
            '-', num2str(DB_R.flag_total(2, DB_R.continue)), '-', num2str(DB_R.flag_total(3, DB_R.continue)), '](', accuracy1, '%-', accuracy_realtime ...
            '%)_(time=', num2str(a), '-', num2str(b), ')_(vps=', num2str(c), '-', num2str(d), ')_(fps=', num2str(e), '-', num2str(f), ')' ];
    
        rank_all_mat = reshape(DB_R.rank_all_mat, [size(DB_R.rank_all_mat, 1), size(DB_R.rank_all_mat, 2) * size(DB_R.rank_all_mat, 3)]);
        num_iter = sum((rank_all_mat~=0), 1);
        num_case = sum((rank_all_mat~=0), 2);
        accum_accuracy = (sum((rank_all_mat==1), 2)./num_case);
        accum_accuracy(isnan(accum_accuracy)) = [];
        percent_accum_accuracy = zeros(1, 100);
        for i = 1 : size(rank_all_mat, 2)
            rank_all = rank_all_mat(1:num_iter(i), i);
            end_idx = ceil(linspace(0, numel(percent_accum_accuracy), num_iter(i)+1));
            start_idx = end_idx + 1;
            start_idx(end) = [];
            end_idx(1) = [];
            for j = 1 : num_iter(i)
                if rank_all(j) == 1
                    percent_accum_accuracy(start_idx(j):end_idx(j)) = percent_accum_accuracy(start_idx(j):end_idx(j)) + 1;
                end
            end
        end
        percent_accum_accuracy = percent_accum_accuracy / size(rank_all_mat, 2);
    
    else
%         file_name = ['[', num2str(DB_R.flag_total(1, DB_R.continue)), '][', num2str(DB.opt.dataset_idx), ...
%             '-', num2str(DB_R.flag_total(2, DB_R.continue)), '-', num2str(DB_R.flag_total(3, DB_R.continue)), '](', accuracy1, ...
%             '%)_', '(std=', num2str(std(DB_R.present_accuracy), 3), ')_(time=', num2str(a), '-', num2str(b), ')_(vps=', num2str(c), '-', num2str(d), ')_(fps=', num2str(e), '-', num2str(f), ')' ];
%         file_name = ['[', num2str(DB_R.flag_total(1, DB_R.continue)), '][', num2str(DB.opt.dataset_idx), ...
%             '-', num2str(DB_R.flag_total(2, DB_R.continue)), '-', num2str(DB_R.flag_total(3, DB_R.continue)), ']([@1]', accuracy1, '%_[@2]', accuracy2, '%_[@3]', accuracy3, '%)_',...
%             '(std=', num2str(std(DB_R.present_accuracy1), 3), ')_(time=', num2str(a), '-', num2str(b), ')_(vps=', num2str(c), '-', num2str(d), ')_(fps=', num2str(e), '-', num2str(f), ')' ];
        file_name = ['[', num2str(DB_R.flag_total(1, DB_R.continue)), '][', num2str(DB.opt.dataset_idx), ...
            '-', num2str(DB_R.flag_total(2, DB_R.continue)), '-', num2str(DB_R.flag_total(3, DB_R.continue)), ']([@1]', accuracy1, '%_[@2]', accuracy2, '%_[@3]', accuracy3, '%_[@4]', accuracy4, '%_[@5]', accuracy5, '%)_',...
            '(std=', num2str(std(DB_R.present_accuracy1), 3), ')_(time=', num2str(a), '-', num2str(b), ')_(vps=', num2str(c), '-', num2str(d), ')_(fps=', num2str(e), '-', num2str(f), ')' ];
    end
    file_name = cat(2, file_name,  '.txt');
    
    if DB_R.opt.log
        fprintf('Save the log : %s\n', file_name(1:end-4));
        if ~isdir(folder_name)
            mkdir(folder_name)
        end
        file_id = fopen(['./', folder_name, '/', file_name], 'wt+');

        if DB_R.opt.realtime
            fprintf(file_id, '----------[[accum_accuracy]]----------\n');
            for i = 1 : numel(accum_accuracy)
                fprintf(file_id, '%s \n', num2str(accum_accuracy(i)));
            end

            fprintf(file_id, '----------[[percent_accum_accuracy]]----------\n');
            for i = 1 : numel(percent_accum_accuracy)
                fprintf(file_id, '%s \n', num2str(percent_accum_accuracy(i)));
            end
        end
        
        
        fprintf(file_id, '----------[[OPTION - PROBE]]----------\n');
        opt_names = fieldnames(DB_R.opt.probe);
        opt_values = struct2cell(DB_R.opt.probe);
        for i = 1 : numel(opt_names)
            fprintf(file_id, '%s : %s \n', opt_names{i}, num2str(opt_values{i}));
        end

        fprintf(file_id, '----------[[OPTION - GALLERY]]----------\n');
        opt_names = fieldnames(DB_R.opt.gallery);
        opt_values = struct2cell(DB_R.opt.gallery);
        for i = 1 : numel(opt_names)
            fprintf(file_id, '%s : %s \n', opt_names{i}, num2str(opt_values{i}));
        end

        fprintf(file_id, '----------[[NUMBER - PROBE]]----------\n');
        opt_names = fieldnames(DB_R.num.probe);
        opt_values = struct2cell(DB_R.num.probe);
        for i = 1 : numel(opt_names)
            fprintf(file_id, '%s : %s \n', opt_names{i}, num2str(opt_values{i}));
        end

        fprintf(file_id, '----------[[NUMBER - GALLERY]]----------\n');
        opt_names = fieldnames(DB_R.num.gallery);
        opt_values = struct2cell(DB_R.num.gallery);
        for i = 1 : numel(opt_names)
            fprintf(file_id, '%s : %s \n', opt_names{i}, num2str(opt_values{i}));
        end
        fclose(file_id);
    end

else
    fprintf('Break the iteration \n');
end




end