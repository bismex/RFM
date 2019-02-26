function DB = MultipleLinearMatching(DB)

num_frame = 0;
for i = 1 : numel(DB.dist)
    num_frame = num_frame + size(DB.dist{i}, 1);
end

dim = 2;
Vp = zeros(num_frame, dim+1);
Rp = zeros(num_frame, dim);
cnt = 1;

for i = 1 : numel(DB.dist)
    if numel(DB.dist{i})
        DB.metric_P{i}(DB.metric_P{i}>DB.opt.quality_P_score) = 1;
        DB.metric_G{i}(DB.metric_G{i}>DB.opt.quality_G_score) = 1;
        X = DB.dist{i};
        if size(X, 1) > size(X, 2)
            sum_dist = sum(X, 2);
            [~, max_idx] = sort(sum_dist, 'descend');
            delete_idx = max_idx(1:size(X, 1) - size(X, 2));
            X(delete_idx, :) = [];
            DB.metric_P{i}(delete_idx) = [];
            Vp(end-numel(delete_idx)+1:end, :) = [];
            Rp(end-numel(delete_idx)+1:end, :) = [];
        end
        num_frame_ph = size(X, 1);
        local_idx = cnt:cnt+num_frame_ph-1;
        Vp(local_idx, dim+1) = DB.metric_P{i};
        
        
        X_ori = X;
        % Quality variants
        if DB.opt.quality == 1 % D / G 
            Q_ratio_G = (repmat(DB.metric_G{i}', [size(X, 1), 1])+eps);
            Q_ratio = 1./ Q_ratio_G;
            X = X.*Q_ratio;
            constraint = ones(size(X));
        elseif DB.opt.quality == 2 % D / G * P
            Q_ratio_P = (repmat(DB.metric_P{i}, [1, size(X, 2)])+eps);
            Q_ratio_G = (repmat(DB.metric_G{i}', [size(X, 1), 1])+eps);
            Q_ratio = Q_ratio_P./ Q_ratio_G;
            X = X.*Q_ratio;
            constraint = ones(size(X));
        elseif DB.opt.quality == 3
            constraint = repmat(DB.metric_G{i}' >= th, [num_frame_ph, 1]);
        else
            constraint = ones(size(X));
        end

        for j = 1 : dim % multiple linear matching
            if j == 1
                if DB.opt.LinearMatching == 1
                    Xd = discretisationMatching_hungarian(-X, constraint); % discrete
                else
                    X_temp = X;
                    X_max = max(X(:));
                    X_temp(constraint==0) = X_max;
                    [~, idx] = min(X_temp');
                    Xd = zeros(size(X));
                    for r = 1 : num_frame_ph
                        Xd(r, idx(r)) = 1;
                    end
                end
            end
            if j == 2 && sum(DB.opt.score == [1,2])
                if DB.opt.LinearMatching == 1
                    Xd = discretisationMatching_hungarian(-X, constraint); % discrete
                else
                    X_temp = X;
                    X_max = max(X(:));
                    X_temp(constraint==0) = X_max;
                    [~, idx] = min(X_temp');
                    Xd = zeros(size(X));
                    for r = 1 : num_frame_ph
                        Xd(r, idx(r)) = 1;
                    end
                end
            end

            delete_idx = [];
            for r = 1 : num_frame_ph
                if isempty(find(Xd(r, :) == 1))
                    delete_idx = cat(2, delete_idx, r);
                else
                    Vp(local_idx(r), j) = X_ori(r, find(Xd(r, :) == 1)); % value of solution for each frame
                    Rp(local_idx(r), j) = DB.label_G{i}(Xd(r, :) == 1); % p index of solution for each frame
                end
            end
            % Add constraints for each frame
            if j == 1
                constraint_idx = Rp(local_idx, j) == DB.label_G{i}';
                constraint(constraint_idx) = 0;
            elseif j == 2
                if ~isempty(delete_idx)
                    Vp(local_idx(delete_idx), :) = [];
                    Rp(local_idx(delete_idx), :) = [];
                    num_frame_ph = num_frame_ph - numel(delete_idx);
                end
            end
        end
        cnt = cnt + num_frame_ph;
    end
end


DB.Rp = Rp;
DB.Vp = Vp;

end