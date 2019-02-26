%% Phase selection (not used)

function DB = GaitPhaseSelection(DB)

if DB.opt.delete_setting_noise_min % delete noise
    min_noise = DB.opt.delete_setting_noise_min;
    max_noise = DB.opt.delete_setting_noise_max;
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            noise = DB.gaitcycle{p, v}.y1_ori{2};
            mean_noise = zeros(1, size(DB.gaitcycle{p, v}.phase, 2));
            for i = 1 : size(DB.gaitcycle{p, v}.phase, 2)
                sidx = DB.gaitcycle{p, v}.phase(2, i);
                eidx = DB.gaitcycle{p, v}.phase(3, i);
                mean_noise(i) = mean(abs(noise(sidx:eidx))); 
            end
            delete_idx = mean_noise <= min_noise | mean_noise >= max_noise;
            DB.gaitcycle{p, v}.phase(1, delete_idx) = 0;
        end
    end
    
end

if DB.opt.PhaseSelection % select candidate
    if DB.opt.new_temporal_selection
        for p = 1 : DB.num.person
            for v = 1 : DB.num.video
                phase_period = DB.gaitcycle{p, v}.phase(4, :);
                mean_quality = zeros(1, size(DB.gaitcycle{p, v}.phase, 2));
                for i = 1 : size(DB.gaitcycle{p, v}.phase, 2)
                    sidx = DB.gaitcycle{p, v}.phase(2, i);
                    eidx = DB.gaitcycle{p, v}.phase(3, i);
                    mean_quality(i) = mean(DB.GQA{p, v}(sidx:eidx));
                end
                
                for ph = 1 : DB.num.phase
                    ph_idx = find(DB.gaitcycle{p, v}.phase(1, :)==ph);
                    quality_local = mean_quality(ph_idx);
                    period_local = phase_period(ph_idx);
                    ph_num = numel(ph_idx);
                    while ph_num > DB.opt.PhaseSelection
                        [val, idx] = min(quality_local);
                        if sum(val == quality_local) > 1 % if mean quality is same
                            idx_all = find(val == quality_local);
                            [~, idx_new] = min(period_local(val == quality_local)); % delete phase with lower period
                            idx = idx_all(idx_new);
                        end
                        DB.gaitcycle{p, v}.phase(1, ph_idx(idx)) = 0;
                        quality_local(idx) = inf;
                        ph_num = ph_num - 1;
                    end
                end
                
            end
        end
        
    else
        
        DB.opt.PhaseSelectionAlpha = 0.51; 
        alpha = DB.opt.PhaseSelectionAlpha;
        gap = (DB.opt.paramsmooth_span-1)/2;
        for p = 1 : DB.num.person
            for v = 1 : DB.num.video
                phase_period = DB.gaitcycle{p, v}.phase(4, :);
                med_period = median(phase_period);

                for i = 1 : gap
                    DB.SC.invariant{p, v}.residual(:, i) = DB.SC.invariant{p, v}.residual(:, gap+1);
                    DB.SC.invariant{p, v}.residual(:, end-i+1) = DB.SC.invariant{p, v}.residual(:, end-gap);
                end

                phase_residual = zeros(size(DB.SC.invariant{p, v}.residual, 1), size(DB.gaitcycle{p, v}.phase, 2));
                phase_residual_rank = zeros(size(DB.SC.invariant{p, v}.residual, 1), size(DB.gaitcycle{p, v}.phase, 2));
                for i = 1 : size(DB.gaitcycle{p, v}.phase, 2)
                    sidx = DB.gaitcycle{p, v}.phase(2, i);
                    eidx = DB.gaitcycle{p, v}.phase(3, i);
                    phase_residual(:, i) = mean(DB.SC.invariant{p, v}.residual(:,sidx:eidx).^2, 2); % phaseº°·Î MSE
                end

                for i = 1 : size(phase_residual, 1)
                    [~, ~, forwardRank] = unique(phase_residual(i, :));
                    phase_residual_rank(i, :) = forwardRank;
                end

                phase_residual_rank_final = mean(phase_residual_rank); % rank-level fusion
                [~, ~, phase_residual_rank_final] = unique(phase_residual_rank_final);
                phase_residual_rank_final = phase_residual_rank_final';

                phase_period_rank_final = abs(med_period - DB.gaitcycle{p, v}.phase(4, :));
                [~, ~, phase_period_rank_final] = unique(phase_period_rank_final);
                phase_period_rank_final = phase_period_rank_final';

                rank_final = alpha * phase_period_rank_final + (1-alpha)*phase_residual_rank_final;
                if numel(phase_period_rank_final) == 2
                    rank_final = 1./DB.gaitcycle{p, v}.phase(4, :);
                end

                for ph = 1 : DB.num.phase
                    ph_idx = find(DB.gaitcycle{p, v}.phase(1, :)==ph);
                    rank_local = rank_final(ph_idx);
                    ph_num = numel(ph_idx);
                    while ph_num > DB.opt.PhaseSelection
                        [~, idx] = max(rank_local);
                        DB.gaitcycle{p, v}.phase(1, ph_idx(idx)) = 0;
                        rank_local(idx) = -inf;
                        ph_num = ph_num - 1;
                    end
                end
            end
        end
        
    end
    
    
    if DB.opt.time
        DB.duration.GaitPhaseSelection = datetime - DB.time.end_time;
        [h, m, s] = hms(DB.duration.GaitPhaseSelection);
        fprintf('[GaitPhaseSelection] processing time : %2.0fh:%2.0fm:%2.0fs \n', fix(h), fix(m), fix(s));
        DB.time.end_time = datetime;
    end
end

end