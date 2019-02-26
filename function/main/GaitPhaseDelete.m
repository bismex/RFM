%% Delete gait phase (if noise exists)

function DB = GaitPhaseDelete(DB)

num_all_noise = 0;
if DB.opt.PhaseSelection 
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            idx_noise = find(DB.gaitcycle{p, v}.phase_vec==0);

            DB.SC.node{p, v}.x(:, idx_noise) = [];
            DB.SC.node{p, v}.y(:, idx_noise) = [];
            DB.SC.node{p, v}.z(:, idx_noise) = [];
            DB.SC.node{p, v}.upper_torso_x(:, idx_noise) = [];
            DB.SC.node{p, v}.upper_torso_y(:, idx_noise) = [];
            DB.SC.node{p, v}.upper_torso_z(:, idx_noise) = [];
            DB.SC.node{p, v}.lower_torso_x(:, idx_noise) = [];
            DB.SC.node{p, v}.lower_torso_y(:, idx_noise) = [];
            DB.SC.node{p, v}.lower_torso_z(:, idx_noise) = [];
            DB.SC.node{p, v}.torso_center(:, idx_noise) = [];

            DB.gaitcycle{p, v}.phase_vec(:, idx_noise) = []; 

            DB.SC.invariant{p, v}.scale(:, idx_noise) = [];
            DB.SC.invariant{p, v}.trans(:, idx_noise) = [];

            DB.T.param.node{p, v}.num = DB.T.param.node{p, v}.num - numel(idx_noise);
            DB.T.param.node{p, v}.num_noise = DB.T.param.node{p, v}.num_noise + numel(idx_noise);

            if DB.opt.PhaseDivisionNumber > 1 && DB.opt.quality_method > 0
                DB.GQA{p, v}(idx_noise) = [];
            end
            
            num_all_noise = num_all_noise + numel(idx_noise);
        end
    end

    DB.num.frame = DB.num.frame - num_all_noise;

    if DB.opt.print
        fprintf('Number of deleted frame : %d\n', num_all_noise);
        fprintf('Number of remain frame : %d\n', DB.num.frame);
    end
    % end
end


DB.feature.phase = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        DB.feature.phase = cat(1, DB.feature.phase, DB.gaitcycle{p, v}.phase_vec');
    end
end


end