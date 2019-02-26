function DB = GaitPhaseLabeling(DB)

visual = 0;
%% phase labeling
% input : DB.gaitcycle{p, v}.phase
% output : DB.gaitcycle{p, v}.phase_vec
if DB.opt.PhaseSelection == 0
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            if DB.gaitcycle{p, v}.phase(2, 1) > 1
                if DB.gaitcycle{p, v}.phase(1, 1) == 1
                    if DB.opt.PhaseDivisionNumber == 4
                        phase_idx = 4;
                    elseif sum(DB.opt.PhaseDivisionNumber == 2:3)
                        phase_idx = 2;
                    else
                        phase_idx = 1;
                    end
                else
                    phase_idx = DB.gaitcycle{p, v}.phase(1, 1) - 1;
                end
                start_vec = [phase_idx;1;DB.gaitcycle{p, v}.phase(2, 1)-1;DB.gaitcycle{p, v}.phase(2, 1)-1];
                DB.gaitcycle{p, v}.phase = cat(2, start_vec, DB.gaitcycle{p, v}.phase);
            end
            if DB.gaitcycle{p, v}.phase(3, end) < DB.T.param.node{p, v}.num
                if DB.gaitcycle{p, v}.phase(1, end) == DB.opt.PhaseDivisionNumber
                    phase_idx = 1;
                else
                    phase_idx = DB.gaitcycle{p, v}.phase(1, end) + 1;
                end
                end_vec = [phase_idx;DB.gaitcycle{p, v}.phase(3, end)+1;DB.T.param.node{p, v}.num;DB.T.param.node{p, v}.num-DB.gaitcycle{p, v}.phase(3, end)];
                DB.gaitcycle{p, v}.phase = cat(2, DB.gaitcycle{p, v}.phase, end_vec);
            end
        end
    end    
end


for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        DB.gaitcycle{p, v}.phase_vec = zeros(1, DB.T.param.node{p, v}.num);
        cnt = 0;
        for j = 1 : size(DB.gaitcycle{p, v}.phase, 2)
            if DB.gaitcycle{p, v}.phase(1, j)
                start_idx = DB.gaitcycle{p, v}.phase(2, j);
                end_idx = DB.gaitcycle{p, v}.phase(3, j);
                if DB.gaitcycle{p, v}.phase(4, j) <= DB.opt.GaitPhase_min_gap
                    DB.gaitcycle{p, v}.phase(1, j) = 0;
                    DB.gaitcycle{p, v}.phase_vec(start_idx:end_idx) = 0;
                    DB.gaitcycle{p, v}.phase_num = DB.gaitcycle{p, v}.phase_num - 1;
                else
                    if DB.opt.PhaseDivisionNumber == 1
                        cnt = cnt + 1;
                        DB.gaitcycle{p, v}.phase_vec(start_idx:end_idx) = cnt;
                    else
                        DB.gaitcycle{p, v}.phase_vec(start_idx:end_idx) = DB.gaitcycle{p, v}.phase(1, j);
                    end
                end
            end
        end
    end
    if visual
        figure(1);
        clf
        hold on
        plot(DB.gaitcycle{p, v}.phase_vec, 'r-');
        hold off
    end
end


DB = GaitCycleVisualization(DB);


if DB.opt.time
    DB.duration.GaitPhaseLabeling = datetime - DB.time.end_time;
    [h, m, s] = hms(DB.duration.GaitPhaseLabeling);
    fprintf('[GaitPhaseLabeling] processing time : %2.0fh:%2.0fm:%2.0fs \n', fix(h), fix(m), fix(s));
    DB.time.end_time = datetime;
end


end