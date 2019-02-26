function DB = DataPreprocessing(DB)

% rng('shuffle')

%% Pose estimation error
if DB.opt.error
    noise_logical = ones(DB.num.video, DB.num.person);
    DB.SC.edge = cell(DB.num.person, DB.num.video);
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            DB.SC.edge{p, v}.max = zeros(1, DB.T.param.node{p, v}.num);
            for f = 1 : DB.T.param.node{p, v}.num
                rowrep_x = repmat(DB.SC.node{p, v}.x(:, f)', [DB.num.node, 1]);
                colrep_x = repmat(DB.SC.node{p, v}.x(:, f), [1, DB.num.node]);
                rowrep_y = repmat(DB.SC.node{p, v}.y(:, f)', [DB.num.node, 1]);
                colrep_y = repmat(DB.SC.node{p, v}.y(:, f), [1, DB.num.node]);
                rowrep_z = repmat(DB.SC.node{p, v}.z(:, f)', [DB.num.node, 1]);
                colrep_z = repmat(DB.SC.node{p, v}.z(:, f), [1, DB.num.node]);

                diffmat_x = rowrep_x - colrep_x; 
                diffmat_y = rowrep_y - colrep_y;
                diffmat_z = rowrep_z - colrep_z;

                edgemat_dist = sqrt(diffmat_x.^2 + diffmat_y.^2 + diffmat_z.^2);
                edgevec_dist = edgemat_dist(:);
                DB.SC.edge{p, v}.max(f) = max(edgevec_dist);
            end
        end
    end

    all_edge_max = [];
    for p = 1 : DB.num.person
        for v = 1: DB.num.video
            all_edge_max = cat(2, all_edge_max, DB.SC.edge{p, v}.max);
        end
    end
    median_length = median(all_edge_max);

    bin = 1000000;
    all_noise = [];
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            if noise_logical(v, p)
                sigma = median_length * DB.opt.error / 100 * sqrt(pi/2);
                num = size(DB.SC.node{p, v}.x);
                noise_length = normrnd(0, sigma, num);
                xn = (randi(bin, num)-(bin/2))/(bin/2);
                yn = (randi(bin, num)-(bin/2))/(bin/2);
                zn = (randi(bin, num)-(bin/2))/(bin/2);
                length = sqrt(xn.*xn+yn.*yn+zn.*zn);
                xn = xn .* abs(noise_length) ./ length;
                yn = yn .* abs(noise_length) ./ length;
                zn = zn .* abs(noise_length) ./ length;
                DB.SC.node{p, v}.x = DB.SC.node{p, v}.x + xn;
                DB.SC.node{p, v}.y = DB.SC.node{p, v}.y + yn;
                DB.SC.node{p, v}.z = DB.SC.node{p, v}.z + zn;
                all_noise = cat(2, all_noise, sqrt(xn.*xn+yn.*yn+zn.*zn));
            end
        end
    end
end
    
%% Rotation
if DB.opt.rotation
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            [Q, ~] = qr(randn(3));
            for n = 1 : DB.num.node
                all_frame_node = cat(1, DB.SC.node{p, v}.x(n, :), DB.SC.node{p, v}.y(n, :), DB.SC.node{p, v}.z(n, :));
                all_frame_node2 = Q*all_frame_node;
                DB.SC.node{p, v}.x(n, :) = all_frame_node2(1,:);
                DB.SC.node{p, v}.y(n, :) = all_frame_node2(2,:);
                DB.SC.node{p, v}.z(n, :) = all_frame_node2(3,:);
            end
        end
    end
end

%% Translation
if DB.opt.translation
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            offset = randn([1, 3])*randi(3);
            DB.SC.node{p, v}.x = offset(1) + DB.SC.node{p, v}.x;
            DB.SC.node{p, v}.y = offset(2) + DB.SC.node{p, v}.y;
            DB.SC.node{p, v}.z = offset(3) + DB.SC.node{p, v}.z;
        end
    end
end

%% Scaling
if DB.opt.scaling
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            scale = rand(1)*2;
            if scale < 0.1
                scale = 1;
            end
            DB.SC.node{p, v}.x = scale * DB.SC.node{p, v}.x;
            DB.SC.node{p, v}.y = scale * DB.SC.node{p, v}.y;
            DB.SC.node{p, v}.z = scale * DB.SC.node{p, v}.z;
        end
    end
end

%% Occlusion
if DB.opt.loss > 2
    loss_flag = [1,1];
elseif DB.opt.loss > 1
    loss_flag = [1,0];
elseif DB.opt.loss > 0
    loss_flag = [0,1];
else
    loss_flag = [0,0];
end
DB.opt.loss = DB.opt.loss - floor(DB.opt.loss);

if DB.opt.loss % 0.2~0.8(LL), 1.2~1.8(UL), 2.2~2.8(ML)
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            idx_in = [];
            idx_out = [];
            if loss_flag(1)
                idx_in{numel(idx_in) + 1} = [1, 3, 8, 9, 10];
                idx_out{numel(idx_out) + 1} = 3;
                idx_in{numel(idx_in) + 1} = [2, 4, 5, 6, 7];
                idx_out{numel(idx_out) + 1} = 4;
            end
            if loss_flag(2)
                idx_in{numel(idx_in) + 1} = [11, 13, 18, 19, 20];
                idx_out{numel(idx_out) + 1} = 13;
                idx_in{numel(idx_in) + 1} = [12, 14, 15, 16, 17];
                idx_out{numel(idx_out) + 1} = 14;
            end
            
            in_frame = DB.T.param.node{p, v}.num;
            out_frame = max(min(ceil(in_frame*DB.opt.loss), in_frame), 1);
            idx = randi(in_frame-out_frame+1); % start_idx : start_idx + outframe - 1
            idx = idx : idx + out_frame - 1;
            
            if DB.opt.visualize
                idx = 30:min(60, in_frame); %for visualization
            end
            if sum(loss_flag) == 2
                idx2 = randperm(numel(idx));
                num1 = round(numel(idx)/2);
                idxa = idx(idx2(1:num1));
                idxb = idx(idx2(num1+1:end));
                
                if DB.opt.visualize
                    idxa = 30:min(44, in_frame);
                    idxb = min(45, in_frame) : min(60, in_frame); %for visualization
                end
                for j = 1 : 2
                    for i = 1 : numel(idx_in{j})
                        DB.SC.node{p, v}.x(idx_in{j}(i), idxa) = DB.SC.node{p, v}.x(idx_in{j}(i), idxa) + randn(size(DB.SC.node{p, v}.x(idx_in{j}(i), idxa)))/30;
                        DB.SC.node{p, v}.y(idx_in{j}(i), idxa) = DB.SC.node{p, v}.y(idx_in{j}(i), idxa) + randn(size(DB.SC.node{p, v}.y(idx_in{j}(i), idxa)))/30;
                        DB.SC.node{p, v}.z(idx_in{j}(i), idxa) = DB.SC.node{p, v}.z(idx_in{j}(i), idxa) + randn(size(DB.SC.node{p, v}.z(idx_in{j}(i), idxa)))/30;
                    end
                end

                for j = 3 : 4
                    for i = 1 : numel(idx_in{j})
                        DB.SC.node{p, v}.x(idx_in{j}(i), idxb) = DB.SC.node{p, v}.x(idx_in{j}(i), idxb) + randn(size(DB.SC.node{p, v}.x(idx_in{j}(i), idxb)))/30;
                        DB.SC.node{p, v}.y(idx_in{j}(i), idxb) = DB.SC.node{p, v}.y(idx_in{j}(i), idxb) + randn(size(DB.SC.node{p, v}.y(idx_in{j}(i), idxb)))/30;
                        DB.SC.node{p, v}.z(idx_in{j}(i), idxb) = DB.SC.node{p, v}.z(idx_in{j}(i), idxb) + randn(size(DB.SC.node{p, v}.z(idx_in{j}(i), idxb)))/30;
                    end
                end
            else
                idxa = idx;
                for j = 1 : 2
                    for i = 1 : numel(idx_in{j})
                        DB.SC.node{p, v}.x(idx_in{j}(i), idxa) = DB.SC.node{p, v}.x(idx_in{j}(i), idxa) + randn(size(DB.SC.node{p, v}.x(idx_in{j}(i), idxa)))/30;
                        DB.SC.node{p, v}.y(idx_in{j}(i), idxa) = DB.SC.node{p, v}.y(idx_in{j}(i), idxa) + randn(size(DB.SC.node{p, v}.y(idx_in{j}(i), idxa)))/30;
                        DB.SC.node{p, v}.z(idx_in{j}(i), idxa) = DB.SC.node{p, v}.z(idx_in{j}(i), idxa) + randn(size(DB.SC.node{p, v}.z(idx_in{j}(i), idxa)))/30;
                    end
                end
            end
            
            
        end
    end
end


if DB.opt.missing > 1
    sample_flag = 1;
elseif DB.opt.missing > 0
    sample_flag = 0;
end
DB.opt.missing = DB.opt.missing - floor(DB.opt.missing);
if DB.opt.missing  % 0.2~0.8(center crop), 1.2~1.8(sampling crop)
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video 
            in_frame = DB.T.param.node{p, v}.num;
            out_frame = max(min(ceil(in_frame*DB.opt.missing), in_frame - 2), 1);
            if sample_flag
                idx = round(linspace(1, in_frame, out_frame));
            else
                idx = randi(in_frame-out_frame+1); 
                idx = idx : idx + out_frame - 1;
            end
            DB.SC.node{p, v}.x(:, idx) = [];
            DB.SC.node{p, v}.y(:, idx) = [];
            DB.SC.node{p, v}.z(:, idx) = [];
            DB.T.param.node{p, v}.num = DB.T.param.node{p, v}.num - out_frame;
            DB.num.frame = DB.num.frame - out_frame;
        end
    end
end


end
