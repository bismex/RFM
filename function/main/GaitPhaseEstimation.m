%% Phase estimation

function DB = GaitPhaseEstimation(DB, DB_classifier)

if DB.opt.PhaseDivisionNumber > 1
    if DB.opt.temporal_test
        DB = GaitCycleAnalysis(DB);
        DB = GaitPhaseDivision(DB);
        DB = GaitPhaseLabeling(DB);
        phase_poly = [];
        for p = 1 : DB.num.person
            for v = 1 : DB.num.video
                phase_poly = cat(1, phase_poly, DB.gaitcycle{p, v}.phase_vec');
            end
        end
    end
    
    if DB.opt.new_temporal_feature == 1 % apply new feature
        feature = new_temporal_feature(DB);
        feature = feature';
    elseif DB.opt.new_temporal_feature == 2 % normalize
        feature = DB.feature.all;
        for i = 1 : size(feature, 2)/3
            idx = i : size(feature, 2)/3 : size(feature, 2);
            feature(:, idx) = feature(:, idx)./repmat(sqrt(sum(feature(:, idx).^2, 2)), [1, 3]);
        end
    else
        feature = DB.feature.all; % original
    end
    switch DB.opt.gaitphase_method
        case 1 % Random forest (default)
            label_estimate_cell = DB_classifier.feature.model.predict(feature);
            label_estimate = zeros(1, numel(label_estimate_cell));
            for j = 1 : numel(label_estimate)
                label_estimate(j) = str2num(label_estimate_cell{j});
            end
            DB.feature.phase = label_estimate';
        case 2 % SVM
            threshold = 0;
            label = cell(1, numel(DB_classifier.feature.model));
            score = cell(1, numel(DB_classifier.feature.model));
            phase_score = zeros(numel(DB_classifier.feature.model), size(feature, 1));
            phase_score_all = zeros(numel(DB_classifier.feature.model), size(feature, 1));

            for i = 1 : numel(DB_classifier.feature.model)
                [label{i}, score{i}]= predict(DB_classifier.feature.model{i},feature);
                phase_score(i,(score{i}(:, 2) > threshold)) = score{i}((score{i}(:, 2) > threshold), 2);
                phase_score_all(i, :) = score{i}(:, 2);
            end
            phase_logical = max(phase_score_all) == phase_score_all;
            phase_label = rem(find(phase_logical), 4);
            phase_label(phase_label==0) = 4;

            DB.feature.phase = phase_label;
        case 3 % GMM
            DB.feature.phase = cluster(DB_classifier.feature.model,feature); % train
        case 4 % Poly fitting (not use classifier)
            if DB.opt.temporal_test
                DB.feature.phase = phase_poly;
            else
                DB = GaitCycleAnalysis(DB);
                DB = GaitPhaseDivision(DB);
                DB = GaitPhaseLabeling(DB);
                DB.feature.phase = [];
                for p = 1 : DB.num.person
                    for v = 1 : DB.num.video
                        DB.feature.phase = cat(1, DB.feature.phase, DB.gaitcycle{p, v}.phase_vec');
                    end
                end
            end
    end

    % For testing classifier
    if DB.opt.temporal_test
        GT_phase = phase_poly;
        est_phase = DB.feature.phase;
        
        fprintf(['Phase classification accuracy : ', num2str(100*mean(GT_phase==est_phase)), '%%\n']);
        confusion_mat = zeros(max(GT_phase), max(GT_phase));
        for i = 1 : max(GT_phase)
            for j = 1 : max(GT_phase)
                confusion_mat(i, j) = mean(GT_phase == i & est_phase == j);
            end
        end
        disp(confusion_mat)
    end

end