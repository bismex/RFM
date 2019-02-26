%% Training gait phase 
function DB = GaitPhaseTraining(DB)

if DB.opt.PhaseDivisionNumber > 1 && sum(DB.opt.GaitRecogMethod == [1,4,7,8]) 
    
    % Transform feature
    if DB.opt.new_temporal_feature == 1 % new feature
        feature = new_temporal_feature(DB); 
        feature = feature';
    elseif DB.opt.new_temporal_feature == 2 % normalization
        feature = DB.feature.all;
        for i = 1 : size(feature, 2)/3
            idx = i : size(feature, 2)/3 : size(feature, 2);
            feature(:, idx) = feature(:, idx)./repmat(sqrt(sum(feature(:, idx).^2, 2)), [1, 3]);
        end
    else
        feature = DB.feature.all; % original
    end
    
    if DB.opt.gaitphase_method ~= 3
        label = [];
        for p = 1 : DB.num.person
            for v = 1 : DB.num.video
                label = cat(1, label, DB.gaitcycle{p, v}.phase_vec');
            end
        end
    end
    
    switch DB.opt.gaitphase_method
        case 1 % Random forest
            num_tree = 30;
            DB.feature.model = TreeBagger(num_tree,feature,label,'OOBPrediction','On','Method','classification');
        case 2 % SVM
            DB.feature.model = cell(1, max(label));
            pp = [3, 4, 1, 2];
            for p = 1 : max(label)
                new_label = zeros(size(DB.feature.label));
                new_label(label==p) = 1;
                new_label(label~=p) = -1;
                model = fitcsvm(feature,new_label,'KernelFunction','rbf',...
                    'BoxConstraint',Inf,'ClassNames',[-1, 1]);
                DB.feature.model{p} = model;
            end
        case 3 % GMM (not used)
            flag = 2;
            num_label = DB.opt.PhaseDivisionNumber;
            num_iter = 1000;
            RegularizationValue = 0.01;
            rng(3);
            type1 = {'diagonal','diagonal','full','full'}; % sigma
            type2 = {true,false,true,false}; % SharedCovariance
            type2_text = {'true','false','true','false'};
            options = statset('MaxIter', num_iter); % Increase number of EM iterations
            gmfit = fitgmdist(feature,num_label,'CovarianceType',type1{flag}, 'SharedCovariance',type2{flag}, ...
                'RegularizationValue',RegularizationValue,'Options',options);
            DB.feature.phase = cluster(gmfit,feature); % train
            DB.feature.model = gmfit;
    end
end

end




