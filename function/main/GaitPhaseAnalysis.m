%% Gait phase analysis

function DB = GaitPhaseAnalysis(DB, DB_classifier)

if DB.opt.PhaseDivisionNumber > 1
    if numel(DB_classifier) % Test
        if DB.opt.PhaseDivisionNumber > 1 && DB.opt.not_estimate_phase == 0 % video-based methods are not allowed
            DB = GaitPhaseEstimation(DB, DB_classifier); % estimate gait phases
        else
            DB.feature.phase = ones(DB.num.frame, 1);
        end
    else 
        if DB.opt.gaitphase_method ~= 3 
            DB = GaitCycleAnalysis(DB); % Cycle analysis
            DB = GaitPhaseDivision(DB); % Phase division
            DB = GaitPhaseSelection(DB); % Phase selection (not used)
            DB = GaitPhaseLabeling(DB); % Phase labeling
            DB = GaitPhaseDelete(DB); % Delete gait phase (if noise exists)
        end
    end
else
    DB.feature.phase = ones(DB.num.frame, 1);
end

end