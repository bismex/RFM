%% phase division

function DB = GaitPhaseDivision(DB)



num_phase_all1 = 0;
num_phase_lower4_1 = 0;
num_phase_lower1_1 = 0;

for p = 1 : DB.num.person
    if DB.opt.print
        fprintf('[Person : %d]', p);
    end
    for v = 1 : DB.num.video
        if DB.opt.print
            fprintf('(V%d)', v);
        end

        max_idx = DB.T.param.node{p, v}.num;

        phase = DB.gaitcycle{p, v}.y1_sol_zero{2}; 
        phase_bin_idx = fix(phase/DB.opt.GaitCycleAnalysis_bin_fit+1);
        phase_ori_idx = round(phase);
        phase_ori_idx(phase_ori_idx<=1) = 1;
        phase_ori_idx(phase_ori_idx>=max_idx) = max_idx;

        phase_idx = DB.gaitcycle{p, v}.y1_fit{3}(phase_bin_idx);
        phase_idx(phase_idx>=0) = 24; 
        phase_idx(phase_idx<0) = 13;

        phase_sub = DB.gaitcycle{p, v}.y2_fit(phase_ori_idx);
        phase_sub = cat(1, phase_sub, DB.gaitcycle{p, v}.y2_ori(phase_ori_idx));
        phase_sub(phase_sub>=0) = 1;
        phase_sub(phase_sub<0) = 3;
        phase_idx13 = find(phase_idx == 13);
        if sum(diff(phase_idx13)~=2)
            fprintf('phase_sub_idx13_error\n');
        end
        candid1 = ones(size(phase_idx13));
        candid1(2:2:end) = 3;
        candid2 = ones(size(phase_idx13));
        candid2(1:2:end) = 3; 

        fit_phase13 = phase_sub(1, phase_idx13);
        ori_phase13 = phase_sub(2, phase_idx13);

        candid1_prop = mean(fit_phase13==candid1)*mean(ori_phase13==candid1);
        candid2_prop = mean(fit_phase13==candid2)*mean(ori_phase13==candid2);

        if candid1_prop >= candid2_prop
            phase13 = candid1;
        else
            phase13 = candid2;
        end

        phase_idx(phase_idx13) = phase13;

        if phase_idx(1) == 24
            if phase_idx(2) == 3
                phase_idx(1) = 2;
            elseif phase_idx(2) == 1
                phase_idx(1) = 4;
            end
        end
        diff_phase24 = diff([phase_idx(1), phase_idx]);
        phase_idx(diff_phase24==23) = 2;
        phase_idx(diff_phase24==21) = 4;

        if sum((diff(phase_idx)~=1)&(diff(phase_idx)~=-3))
            fprintf('phase_idx_error\n');
        end

        if DB.opt.print
            fprintf('#ph : %d',  numel(phase_idx));
        end

        if DB.opt.PhaseComplete
            if DB.gaitcycle{p, v}.phase(2, 1) ~= 1
                DB.gaitcycle{p, v}.phase = cat(2, zeros(size(DB.gaitcycle{p, v}.phase, 1), 1), DB.gaitcycle{p, v}.phase);
                if DB.gaitcycle{p, v}.phase(1, 2) == 1
                    DB.gaitcycle{p, v}.phase(1, 1) = 4;
                else
                    DB.gaitcycle{p, v}.phase(1, 1) = DB.gaitcycle{p, v}.phase(1, 2) - 1;
                end
                DB.gaitcycle{p, v}.phase(2, 1) = 1;
                DB.gaitcycle{p, v}.phase(3, 1) = DB.gaitcycle{p, v}.phase(2, 2)-1;
                DB.gaitcycle{p, v}.phase(4, 1) = DB.gaitcycle{p, v}.phase(3, 1) - DB.gaitcycle{p, v}.phase(2, 1) + 1;
            end
            if DB.gaitcycle{p, v}.phase(3, end) ~= DB.T.param.node{p, v}.num
                DB.gaitcycle{p, v}.phase = cat(2, DB.gaitcycle{p, v}.phase, zeros(size(DB.gaitcycle{p, v}.phase, 1), 1));
                if DB.gaitcycle{p, v}.phase(1, end-1) == 4
                    DB.gaitcycle{p, v}.phase(1, end) = 1;
                else
                    DB.gaitcycle{p, v}.phase(1, end) = DB.gaitcycle{p, v}.phase(1, end-1) + 1;
                end
                DB.gaitcycle{p, v}.phase(2, end) = DB.gaitcycle{p, v}.phase(3, end-1) + 1;
                DB.gaitcycle{p, v}.phase(3, end) = DB.T.param.node{p, v}.num;
                DB.gaitcycle{p, v}.phase(4, end) = DB.gaitcycle{p, v}.phase(3, end) - DB.gaitcycle{p, v}.phase(2, end) + 1;
            end

            phase_idx = DB.gaitcycle{p, v}.phase(1, :);
        end

        if DB.opt.PhaseDivisionNumber == 1
            delete_idx = find(phase_idx ~= 1);
            phase_idx(delete_idx) = [];
            phase_ori_idx(delete_idx) = [];
            DB.num.phase = 1;
        elseif DB.opt.PhaseDivisionNumber == 2
            delete_idx = cat(2, find(phase_idx == 2), find(phase_idx == 4));
            phase_idx(delete_idx) = [];
            phase_ori_idx(delete_idx) = [];
            phase_idx(phase_idx==3) = 2;
            DB.num.phase = 2;
        elseif DB.opt.PhaseDivisionNumber == 4
            DB.num.phase = 4;
        else
            num_phase = DB.opt.PhaseDivisionNumber;
            if DB.opt.PhaseDivisionNumber == 4.1
                num_phase = 4;
                DB.opt.PhaseDivisionNumber = 4;
            end
            delete_idx = cat(2, find(phase_idx == 2), find(phase_idx == 3), find(phase_idx == 4));
            remain_idx = find(phase_idx == 1);
            delete_idx(delete_idx < remain_idx(1) | delete_idx > remain_idx(end)) = [];
            phase_idx(delete_idx) = [];
            phase_ori_idx(delete_idx) = [];
            delete_idx = find(phase_idx > num_phase);
            phase_idx(delete_idx) = [];
            phase_ori_idx(delete_idx) = [];
            s_idx = find(phase_idx==1);
            if numel(s_idx) > 1
                e_idx = s_idx(2:end);
                s_idx(end) = [];
            end
            for i = numel(s_idx) : -1 : 1
                phase_idx = cat(2, phase_idx(1:s_idx(i)), 2:num_phase, phase_idx(e_idx(i):end));
                a = phase_ori_idx(s_idx(i));
                b = phase_ori_idx(e_idx(i));
                fill_in = a:(b-a)/num_phase:b;
                phase_ori_idx = cat(2, phase_ori_idx(1:s_idx(i)), fill_in(2:end-1),phase_ori_idx(e_idx(i):end));
            end
            phase_ori_idx = round(phase_ori_idx);
            DB.num.phase = num_phase;
        end

        num_phase_all1 = num_phase_all1 + numel(phase_idx);
        DB.gaitcycle{p, v}.phase = [phase_idx; phase_ori_idx; phase_ori_idx(2:end)-1, phase_ori_idx(end)];
        DB.gaitcycle{p, v}.phase = [DB.gaitcycle{p, v}.phase; DB.gaitcycle{p, v}.phase(3, :) - DB.gaitcycle{p, v}.phase(2, :) + 1];



        DB.gaitcycle{p, v}.phase_num = numel(phase_idx)-1;
        if numel(phase_idx)<=4
            num_phase_lower4_1 = num_phase_lower4_1 + 1;
        end
        if numel(phase_idx)<=1
            num_phase_lower1_1 = num_phase_lower1_1 + 1;
        end

    end
    if DB.opt.print
        fprintf('\n');
    end
end

if DB.opt.print
    fprintf('[Method 1] (phase number) average : %3.2f, lower than 4 : %d, lower than 1 : %d \n', DB.result.num_phase_all(1)/DB.num.person/DB.num.video, num_phase_lower4_1, num_phase_lower1_1);
end

if DB.opt.time
    DB.duration.GaitPhaseDivision = datetime - DB.time.end_time;
    [h, m, s] = hms(DB.duration.GaitPhaseDivision);
    fprintf('[GaitPhaseDivision] processing time : %2.0fh:%2.0fm:%2.0fs \n', fix(h), fix(m), fix(s));
    DB.time.end_time = datetime;
end


end