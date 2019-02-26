%% Skeleton alignment
% DB.opt.align_method = 1 -> Proposed
% DB.opt.align_method = 2 -> Direct alignment
% DB.opt.align_method = 3 -> TorsoPCA
% DB.opt.align_method = 4 -> only translation

function DB = GaitPoseAlignment(DB)

DB.visual.align = 0;
paramsmooth_method = 'moving';
upper_torso_node = [1, 2, 3, 4];
lower_torso_node = [11, 12, 13, 14];
visual = 0;
if DB.opt.frame_moving == 0
    estimate_t = 2; % Adaptive selection
else
    estimate_t = 0;
end

% For an adaptive selection of parameters
sub1 = 1; 
sub2 = 2; 
sub3 = 1; 

if DB.opt.align_method == 1 % Proposed
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video

            %% Torso center
            x1 = mean(DB.SC.node{p, v}.x(upper_torso_node, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(upper_torso_node, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(upper_torso_node, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(lower_torso_node, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(lower_torso_node, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(lower_torso_node, :), 1);
            
            DB.SC.node{p, v}.upper_torso_x = x1;
            DB.SC.node{p, v}.upper_torso_y = y1;
            DB.SC.node{p, v}.upper_torso_z = z1;
            DB.SC.node{p, v}.lower_torso_x = x2;
            DB.SC.node{p, v}.lower_torso_y = y2;
            DB.SC.node{p, v}.lower_torso_z = z2;

            xx = (DB.SC.node{p, v}.upper_torso_x+DB.SC.node{p, v}.lower_torso_x)/2;
            yy = (DB.SC.node{p, v}.upper_torso_y+DB.SC.node{p, v}.lower_torso_y)/2;
            zz = (DB.SC.node{p, v}.upper_torso_z+DB.SC.node{p, v}.lower_torso_z)/2;

            DB.SC.node{p, v}.torso_center = cat(1, xx, yy, zz);

            %% translation invariant
            fp = DB.SC.node{p, v}.torso_center;
            fps = fp;
            if DB.opt.paramsmooth_span
                for i = 1 : 3
                    fps(i, :) = smooth(fp(i, :), DB.opt.paramsmooth_span, paramsmooth_method);
                end
            end
            ep = abs(fps-fp);
            epa = sqrt(sum(ep.^2, 1));
            
            DB.SC.invariant{p, v}.trans = fps; 
            
             %% scale invariant
            udir_x = DB.SC.node{p, v}.upper_torso_x - DB.SC.node{p, v}.lower_torso_x;
            udir_y = DB.SC.node{p, v}.upper_torso_y - DB.SC.node{p, v}.lower_torso_y;
            udir_z = DB.SC.node{p, v}.upper_torso_z - DB.SC.node{p, v}.lower_torso_z;
            fs = sqrt(udir_x.^2+udir_y.^2+udir_z.^2);
            fss = fs;
            if DB.opt.paramsmooth_span
                fss(:) = smooth(fs, DB.opt.paramsmooth_span, paramsmooth_method);
            end
            es = abs(fss-fs);
            DB.SC.invariant{p, v}.scale = fss; 
            

            if estimate_t % Adaptive selection!
                %% M invariant
                cnt = 0;
                old_val = inf;
                for gap = 1:5
                    cnt = cnt + 1;
                    fm = DB.SC.node{p, v}.torso_center(:, 1+gap:end) - DB.SC.node{p, v}.torso_center(:, 1:end-gap);
                    fm = cat(2, repmat(fm(:, 1), [1, gap]), fm);

                    fm = fm./repmat(sqrt(sum(fm.^2, 1)), [3, 1]); % normalize
                    fms = fm;
                    if DB.opt.paramsmooth_span
                        for i = 1 : 3
                            fms(i, :) = smooth(fm(i, :), DB.opt.paramsmooth_span, paramsmooth_method);
                        end
                    end
                    fms = fms./repmat(sqrt(sum(fms.^2, 1)), [3, 1]);
                    em = acos(dot(fms,fm));
                    cand_udir_M = fms;


                    %% T invariant

                    xx = DB.SC.node{p, v}.upper_torso_x - DB.SC.node{p, v}.lower_torso_x;
                    yy = DB.SC.node{p, v}.upper_torso_y - DB.SC.node{p, v}.lower_torso_y;
                    zz = DB.SC.node{p, v}.upper_torso_z - DB.SC.node{p, v}.lower_torso_z;
                    ft = cat(1, xx, yy, zz);
                    ft = ft./repmat(sqrt(sum(ft.^2, 1)), [3, 1]); % normalize
                    fts = ft;
                    if DB.opt.paramsmooth_span
                        for i = 1 : 3
                            fts(i, :) = smooth(ft(i, :), DB.opt.paramsmooth_span, paramsmooth_method);
                        end
                    end
                    fts = fts./repmat(sqrt(sum(fts.^2, 1)), [3, 1]);
                    et = acos(dot(fts,ft));
                    cand_udir_T = fts;

                    %% L invariant
                    M = zeros(3, 1, DB.T.param.node{p, v}.num);
                    L = zeros(3, 1, DB.T.param.node{p, v}.num);
                    T = zeros(3, 1, DB.T.param.node{p, v}.num);

                    M(:) = cand_udir_M;
                    T(:) = cand_udir_T;

                    L = cross(T, M);
                    L = L ./ repmat(sqrt(L(1,:,:).^2+L(2,:,:).^2+L(3,:,:).^2), [3, 1, 1]);

                    M = cross(L, T); 
                    M = M ./ repmat(sqrt(M(1,:,:).^2+M(2,:,:).^2+M(3,:,:).^2), [3, 1, 1]);

                    %% Alignment
                    dx = DB.SC.invariant{p, v}.trans(1, :);
                    dy = DB.SC.invariant{p, v}.trans(2, :);
                    dz = DB.SC.invariant{p, v}.trans(3, :);

                    cand_x = DB.SC.node{p, v}.x - repmat(dx, [DB.num.node, 1]);
                    cand_y = DB.SC.node{p, v}.y - repmat(dy, [DB.num.node, 1]);
                    cand_z = DB.SC.node{p, v}.z - repmat(dz, [DB.num.node, 1]);

                    scale = DB.SC.invariant{p, v}.scale;

                    cand_x = cand_x./repmat(scale, [DB.num.node, 1]);
                    cand_y = cand_y./repmat(scale, [DB.num.node, 1]);
                    cand_z = cand_z./repmat(scale, [DB.num.node, 1]);

                    M = repmat(M, [1, DB.num.node, 1]);
                    L = repmat(L, [1, DB.num.node, 1]);
                    T = repmat(T, [1, DB.num.node, 1]);

                    X = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);
                    Y = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);
                    Z = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);

                    X(1, :, :) = cand_x;
                    Y(1, :, :) = cand_y;
                    Z(1, :, :) = cand_z;

                    XYZ = cat(1, X, Y, Z);

                    cand_x(:,:) = sum(XYZ.*M, 1);
                    cand_y(:,:) = sum(XYZ.*L, 1);
                    cand_z(:,:) = sum(XYZ.*T, 1);

                    
                    switch sub1
                        case 1
                            idx1 = [3,4];
                            idx2 = [13,14];
                        case 2
                            idx1 = [1,2];
                            idx2 = [11,12];
                        case 3
                            idx1 = upper_torso_node;
                            idx2 = lower_torso_node;
                    end
%                     idx1 = [3,4];
%                     idx2 = [13,14];
%                     torso_idx = [upper_torso_node, lower_torso_node];
                    
                    switch sub2
                        case 1
                            torso_x = cat(1, mean(cand_x(idx1, :), 1), mean(cand_x(idx2, :), 1));
                            torso_y = cat(1, mean(cand_y(idx1, :), 1), mean(cand_y(idx2, :), 1));
                            torso_z = cat(1, mean(cand_z(idx1, :), 1), mean(cand_z(idx2, :), 1));
                        case 2
                            torso_x = cat(1, cand_x(idx1, :), cand_x(idx2, :));
                            torso_y = cat(1, cand_y(idx1, :), cand_y(idx2, :));
                            torso_z = cat(1, cand_z(idx1, :), cand_z(idx2, :));
                    end
                            
                    
                    torso_dx = diff(torso_x,1,2);
                    torso_dy = diff(torso_y,1,2);
                    torso_dz = diff(torso_z,1,2);
                    torso_error = sqrt(torso_dx.^2 + torso_dy.^2 + torso_dz.^2);
                    if size(torso_error, 1) ~= 1
                        switch sub3
                            case 1
                                torso_error = mean(torso_error, 1);
                            case 2
                                torso_error = min(torso_error, [], 1);
                            case 3
                                torso_error = max(torso_error, [], 1);
                        end
                    end
%                     bar(torso_error)
                    if estimate_t == 1
                        torso_error = sum(torso_error, 1);
                        val = mean(torso_error);
                        if cnt == 1 || val < old_val
                            old_val = val;
                            find_idx = cnt;
                            DB.SC.node{p, v}.x = cand_x;
                            DB.SC.node{p, v}.y = cand_y;
                            DB.SC.node{p, v}.z = cand_z;

%                             DB.SC.invariant{p, v}.udir_M = cand_udir_M;
%                             DB.SC.invariant{p, v}.udir_T = cand_udir_T;
% 
%                             DB.SC.invariant{p, v}.residual = cat(1, epa, es, em, et);
                        end
                    elseif estimate_t == 2
                        if cnt == 1
                            torso_error_all = [];
                            cand_x_all = [];
                            cand_y_all = [];
                            cand_z_all = [];
                        end
                        torso_error_all = cat(1, torso_error_all, torso_error);
                        cand_x_all = cat(3, cand_x_all, cand_x);
                        cand_y_all = cat(3, cand_y_all, cand_y);
                        cand_z_all = cat(3, cand_z_all, cand_z);
                        
                    end
                    
                    
                end
                if estimate_t == 1
                    fprintf([num2str(find_idx)])
                elseif estimate_t == 2
                    [~, idx] = min(torso_error_all);
                    idx = cat(2, 1, idx);
                    DB.SC.node{p, v}.x = [];
                    DB.SC.node{p, v}.y = [];
                    DB.SC.node{p, v}.z = [];
                    for f = 1 : size(cand_x_all, 2)
                        DB.SC.node{p, v}.x = cat(2, DB.SC.node{p, v}.x, cand_x_all(:, f, idx(f)));
                        DB.SC.node{p, v}.y = cat(2, DB.SC.node{p, v}.y, cand_y_all(:, f, idx(f)));
                        DB.SC.node{p, v}.z = cat(2, DB.SC.node{p, v}.z, cand_z_all(:, f, idx(f)));
                    end
%                     size(DB.SC.node{p, v}.x)
                end
                




            else
                
                %% M invariant

                gap = DB.opt.frame_moving;
                fm = DB.SC.node{p, v}.torso_center(:, 1+gap:end) - DB.SC.node{p, v}.torso_center(:, 1:end-gap);
                fm = cat(2, repmat(fm(:, 1), [1, gap]), fm);

                fm = fm./repmat(sqrt(sum(fm.^2, 1)), [3, 1]); % normalize
                fms = fm;
                if DB.opt.paramsmooth_span
                    for i = 1 : 3
                        fms(i, :) = smooth(fm(i, :), DB.opt.paramsmooth_span, paramsmooth_method);
                    end
                end
                fms = fms./repmat(sqrt(sum(fms.^2, 1)), [3, 1]);
                em = acos(dot(fms,fm));
                DB.SC.invariant{p, v}.udir_M = fms;


                %% T invariant

                xx = DB.SC.node{p, v}.upper_torso_x - DB.SC.node{p, v}.lower_torso_x;
                yy = DB.SC.node{p, v}.upper_torso_y - DB.SC.node{p, v}.lower_torso_y;
                zz = DB.SC.node{p, v}.upper_torso_z - DB.SC.node{p, v}.lower_torso_z;
                ft = cat(1, xx, yy, zz);
                ft = ft./repmat(sqrt(sum(ft.^2, 1)), [3, 1]); % normalize
                fts = ft;
                if DB.opt.paramsmooth_span
                    for i = 1 : 3
                        fts(i, :) = smooth(ft(i, :), DB.opt.paramsmooth_span, paramsmooth_method);
                    end
                end
                fts = fts./repmat(sqrt(sum(fts.^2, 1)), [3, 1]);
                et = acos(dot(fts,ft));
                DB.SC.invariant{p, v}.udir_T = fts;

                %% L invariant
                M = zeros(3, 1, DB.T.param.node{p, v}.num);
                L = zeros(3, 1, DB.T.param.node{p, v}.num);
                T = zeros(3, 1, DB.T.param.node{p, v}.num);


                if DB.opt.quat
                    node_idx = 11;
                    all_quat = cat(1, DB.SC.quat{p, v}.x(node_idx,:), DB.SC.quat{p, v}.y(node_idx,:), DB.SC.quat{p, v}.z(node_idx,:), DB.SC.quat{p, v}.w(node_idx,:));
                    if DB.opt.quat == 1
                        L(:) = [all_quat(4,:).^2 + all_quat(1,:).^2 - all_quat(2,:).^2 - all_quat(3,:).^2;...
                            2*(all_quat(1,:).*all_quat(2,:)+all_quat(4,:).*all_quat(3,:));...
                            2*(all_quat(1,:).*all_quat(3,:)-all_quat(4,:).*all_quat(2,:))];
                        T(:) = -[2*(all_quat(1,:).*all_quat(2,:)-all_quat(4,:).*all_quat(3,:));...
                            all_quat(4,:).^2 - all_quat(1,:).^2 + all_quat(2,:).^2 - all_quat(3,:).^2;...
                            2*(all_quat(2,:).*all_quat(3,:)+all_quat(4,:).*all_quat(1,:))]; % y is bone direction
                        M(:) = -[2*(all_quat(1,:).*all_quat(3,:)+all_quat(4,:).*all_quat(2,:));...
                            2*(all_quat(2,:).*all_quat(3,:)-all_quat(4,:).*all_quat(1,:));...
                            all_quat(4,:).^2 - all_quat(1,:).^2 - all_quat(2,:).^2 + all_quat(3,:).^2];


                    elseif DB.opt.quat == 2

                        M(:) = -[2*(all_quat(1,:).*all_quat(3,:)+all_quat(4,:).*all_quat(2,:));...
                            2*(all_quat(2,:).*all_quat(3,:)-all_quat(4,:).*all_quat(1,:));...
                            all_quat(4,:).^2 - all_quat(1,:).^2 - all_quat(2,:).^2 + all_quat(3,:).^2];
                        T(:) = DB.SC.invariant{p, v}.udir_T;

                        L = cross(T, M); 
                        L = L ./ repmat(sqrt(L(1,:,:).^2+L(2,:,:).^2+L(3,:,:).^2), [3, 1, 1]);

                        M = cross(L, T); 
                        M = M ./ repmat(sqrt(M(1,:,:).^2+M(2,:,:).^2+M(3,:,:).^2), [3, 1, 1]);

                    end
                else

                    M(:) = DB.SC.invariant{p, v}.udir_M;
                    T(:) = DB.SC.invariant{p, v}.udir_T;

                    L = cross(T, M); 
                    L = L ./ repmat(sqrt(L(1,:,:).^2+L(2,:,:).^2+L(3,:,:).^2), [3, 1, 1]);

                    M = cross(L, T); 
                    M = M ./ repmat(sqrt(M(1,:,:).^2+M(2,:,:).^2+M(3,:,:).^2), [3, 1, 1]);

                end

                dx = DB.SC.invariant{p, v}.trans(1, :);
                dy = DB.SC.invariant{p, v}.trans(2, :);
                dz = DB.SC.invariant{p, v}.trans(3, :);

                DB.SC.node{p, v}.x = DB.SC.node{p, v}.x - repmat(dx, [DB.num.node, 1]);
                DB.SC.node{p, v}.y = DB.SC.node{p, v}.y - repmat(dy, [DB.num.node, 1]);
                DB.SC.node{p, v}.z = DB.SC.node{p, v}.z - repmat(dz, [DB.num.node, 1]);

                scale = DB.SC.invariant{p, v}.scale;

                DB.SC.node{p, v}.x = DB.SC.node{p, v}.x./repmat(scale, [DB.num.node, 1]);
                DB.SC.node{p, v}.y = DB.SC.node{p, v}.y./repmat(scale, [DB.num.node, 1]);
                DB.SC.node{p, v}.z = DB.SC.node{p, v}.z./repmat(scale, [DB.num.node, 1]);

                M = repmat(M, [1, DB.num.node, 1]);
                L = repmat(L, [1, DB.num.node, 1]);
                T = repmat(T, [1, DB.num.node, 1]);

                X = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);
                Y = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);
                Z = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);

                X(1, :, :) = DB.SC.node{p, v}.x;
                Y(1, :, :) = DB.SC.node{p, v}.y;
                Z(1, :, :) = DB.SC.node{p, v}.z;

                XYZ = cat(1, X, Y, Z);

                DB.SC.node{p, v}.x(:,:) = sum(XYZ.*M, 1);
                DB.SC.node{p, v}.y(:,:) = sum(XYZ.*L, 1);
                DB.SC.node{p, v}.z(:,:) = sum(XYZ.*T, 1);

                DB.SC.invariant{p, v}.residual = cat(1, epa, es, em, et);
            end


            if visual
                figure
                subplot(2, 2, 1);
                hold on
                plot(fp')
                plot(fps')
                title('translation error')
                subplot(2, 2, 2);
                hold on
                plot(fs)
                plot(fss)
                title('scale error')
                subplot(2, 2, 3);
                hold on
                plot(ft')
                plot(fts')
                title('top dir error')
                subplot(2, 2, 4);
                hold on
                plot(fm')
                plot(fms')
                title('moving dir error')
            end
            
            
        end
    end
   
elseif DB.opt.align_method == 2 % Pelvis (direction alignment)
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video

            %% Torso center
            x1 = mean(DB.SC.node{p, v}.x(upper_torso_node, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(upper_torso_node, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(upper_torso_node, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(lower_torso_node, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(lower_torso_node, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(lower_torso_node, :), 1);
            
            DB.SC.node{p, v}.upper_torso_x = x1;
            DB.SC.node{p, v}.upper_torso_y = y1;
            DB.SC.node{p, v}.upper_torso_z = z1;
            DB.SC.node{p, v}.lower_torso_x = x2;
            DB.SC.node{p, v}.lower_torso_y = y2;
            DB.SC.node{p, v}.lower_torso_z = z2;

            xx = (DB.SC.node{p, v}.upper_torso_x+DB.SC.node{p, v}.lower_torso_x)/2;
            yy = (DB.SC.node{p, v}.upper_torso_y+DB.SC.node{p, v}.lower_torso_y)/2;
            zz = (DB.SC.node{p, v}.upper_torso_z+DB.SC.node{p, v}.lower_torso_z)/2;

            DB.SC.node{p, v}.torso_center = cat(1, xx, yy, zz);
            
            %% Center of hips
            
            x1 = mean(DB.SC.node{p, v}.x(13, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(13, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(13, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(14, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(14, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(14, :), 1);

            x_hips = (x1+x2) / 2;
            y_hips = (y1+y2) / 2;
            z_hips = (z1+z2) / 2;
            
            %% Center of shoulders
            
            x1 = mean(DB.SC.node{p, v}.x(3, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(3, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(3, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(4, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(4, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(4, :), 1);

            x_shoulders = (x1+x2) / 2;
            y_shoulders = (y1+y2) / 2;
            z_shoulders = (z1+z2) / 2;
            
            %% Left of thigh
            
            x1 = mean(DB.SC.node{p, v}.x(14, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(14, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(14, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(15, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(15, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(15, :), 1);
            
            x_Lthigh = (x1+x2) / 2;
            y_Lthigh = (y1+y2) / 2;
            z_Lthigh = (z1+z2) / 2;
            
            axis1 = cat(1, x_shoulders - x_hips, y_shoulders - y_hips, z_shoulders - z_hips);
            axis1 = axis1./(repmat(sqrt(sum(axis1.^2, 1)), [3, 1])+eps);
            
            axis3 = cat(1, x_Lthigh - x_hips, y_Lthigh - y_hips, z_Lthigh - z_hips); 
            axis3 = axis3./(repmat(sqrt(sum(axis3.^2, 1)), [3, 1])+eps);
            
            M = zeros(3, 1, DB.T.param.node{p, v}.num);
%             L = zeros(3, 1, DB.T.param.node{p, v}.num);
            T = zeros(3, 1, DB.T.param.node{p, v}.num);
            
            M(:) = axis1;
            T(:) = axis3;
            
            L = cross(T, M); 
            L = L ./ (repmat(sqrt(L(1,:,:).^2+L(2,:,:).^2+L(3,:,:).^2), [3, 1, 1])+eps);
            
            M = cross(L, T);
            M = M ./ (repmat(sqrt(M(1,:,:).^2+M(2,:,:).^2+M(3,:,:).^2), [3, 1, 1])+eps);
            
            axis1 = M;
            axis2 = L;
            axis3 = T;
            
            %% Alignment
            dx = DB.SC.node{p, v}.x(11, :);
            dy = DB.SC.node{p, v}.y(11, :);
            dz = DB.SC.node{p, v}.z(11, :);

            DB.SC.node{p, v}.x = DB.SC.node{p, v}.x - repmat(dx, [DB.num.node, 1]);
            DB.SC.node{p, v}.y = DB.SC.node{p, v}.y - repmat(dy, [DB.num.node, 1]);
            DB.SC.node{p, v}.z = DB.SC.node{p, v}.z - repmat(dz, [DB.num.node, 1]);

          
            x1 = mean(DB.SC.node{p, v}.x(upper_torso_node, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(upper_torso_node, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(upper_torso_node, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(lower_torso_node, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(lower_torso_node, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(lower_torso_node, :), 1);
            
            udir_x = x1 - x2;
            udir_y = y1 - y2;
            udir_z = z1 - z2;
            scale = sqrt(udir_x.^2+udir_y.^2+udir_z.^2);

            DB.SC.node{p, v}.x = DB.SC.node{p, v}.x./repmat(scale, [DB.num.node, 1]);
            DB.SC.node{p, v}.y = DB.SC.node{p, v}.y./repmat(scale, [DB.num.node, 1]);
            DB.SC.node{p, v}.z = DB.SC.node{p, v}.z./repmat(scale, [DB.num.node, 1]);
            
            
            M = repmat(axis1, [1, DB.num.node, 1]);
            L = repmat(axis2, [1, DB.num.node, 1]);
            T = repmat(axis3, [1, DB.num.node, 1]);

            X = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);
            Y = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);
            Z = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);

            X(1, :, :) = DB.SC.node{p, v}.x;
            Y(1, :, :) = DB.SC.node{p, v}.y;
            Z(1, :, :) = DB.SC.node{p, v}.z;

            XYZ = cat(1, X, Y, Z);

            DB.SC.node{p, v}.x(:,:) = sum(XYZ.*M, 1);
            DB.SC.node{p, v}.y(:,:) = sum(XYZ.*L, 1);
            DB.SC.node{p, v}.z(:,:) = sum(XYZ.*T, 1);
        end
    end
    
elseif DB.opt.align_method == 3 % TorsoPCA 
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
    
            %% Torso center
            x1 = mean(DB.SC.node{p, v}.x(upper_torso_node, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(upper_torso_node, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(upper_torso_node, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(lower_torso_node, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(lower_torso_node, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(lower_torso_node, :), 1);
            
            DB.SC.node{p, v}.upper_torso_x = x1;
            DB.SC.node{p, v}.upper_torso_y = y1;
            DB.SC.node{p, v}.upper_torso_z = z1;
            DB.SC.node{p, v}.lower_torso_x = x2;
            DB.SC.node{p, v}.lower_torso_y = y2;
            DB.SC.node{p, v}.lower_torso_z = z2;

            xx = (DB.SC.node{p, v}.upper_torso_x+DB.SC.node{p, v}.lower_torso_x)/2;
            yy = (DB.SC.node{p, v}.upper_torso_y+DB.SC.node{p, v}.lower_torso_y)/2;
            zz = (DB.SC.node{p, v}.upper_torso_z+DB.SC.node{p, v}.lower_torso_z)/2;

            DB.SC.node{p, v}.torso_center = cat(1, xx, yy, zz);
            
            % node 2, 3, 4, 11, 12, 13, 14
            mat = zeros(7, 3, DB.T.param.node{p, v}.num);
            mat(1, 1, :) = DB.SC.node{p, v}.x(2, :);
            mat(1, 2, :) = DB.SC.node{p, v}.y(2, :);
            mat(1, 3, :) = DB.SC.node{p, v}.z(2, :);
            mat(2, 1, :) = DB.SC.node{p, v}.x(3, :);
            mat(2, 2, :) = DB.SC.node{p, v}.y(3, :);
            mat(2, 3, :) = DB.SC.node{p, v}.z(3, :);
            mat(3, 1, :) = DB.SC.node{p, v}.x(4, :);
            mat(3, 2, :) = DB.SC.node{p, v}.y(4, :);
            mat(3, 3, :) = DB.SC.node{p, v}.z(4, :);
            mat(4, 1, :) = DB.SC.node{p, v}.x(11, :);
            mat(4, 2, :) = DB.SC.node{p, v}.y(11, :);
            mat(4, 3, :) = DB.SC.node{p, v}.z(11, :);
            mat(5, 1, :) = DB.SC.node{p, v}.x(12, :);
            mat(5, 2, :) = DB.SC.node{p, v}.y(12, :);
            mat(5, 3, :) = DB.SC.node{p, v}.z(12, :);
            mat(6, 1, :) = DB.SC.node{p, v}.x(13, :);
            mat(6, 2, :) = DB.SC.node{p, v}.y(13, :);
            mat(6, 3, :) = DB.SC.node{p, v}.z(13, :);
            mat(7, 1, :) = DB.SC.node{p, v}.x(14, :);
            mat(7, 2, :) = DB.SC.node{p, v}.y(14, :);
            mat(7, 3, :) = DB.SC.node{p, v}.z(14, :);
            
            axis1 = [];
            axis2 = [];
            axis3 = [];
            for i = 1 : DB.T.param.node{p, v}.num
                pcamat = pca(mat(:,:,1));
                axis1 = cat(2, axis1, pcamat(:, 1));
                axis2 = cat(2, axis2, pcamat(:, 2));
                axis3 = cat(2, axis3, pcamat(:, 3));
            end
            
            M = zeros(3, 1, DB.T.param.node{p, v}.num);
            L = zeros(3, 1, DB.T.param.node{p, v}.num);
            T = zeros(3, 1, DB.T.param.node{p, v}.num);
            
            M(:) = -axis3;
            L(:) = -axis2;
            T(:) = axis1;
            
            %% Alignment
            dx = DB.SC.node{p, v}.x(11, :);
            dy = DB.SC.node{p, v}.y(11, :);
            dz = DB.SC.node{p, v}.z(11, :);

            DB.SC.node{p, v}.x = DB.SC.node{p, v}.x - repmat(dx, [DB.num.node, 1]);
            DB.SC.node{p, v}.y = DB.SC.node{p, v}.y - repmat(dy, [DB.num.node, 1]);
            DB.SC.node{p, v}.z = DB.SC.node{p, v}.z - repmat(dz, [DB.num.node, 1]);
            
            x1 = mean(DB.SC.node{p, v}.x(upper_torso_node, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(upper_torso_node, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(upper_torso_node, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(lower_torso_node, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(lower_torso_node, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(lower_torso_node, :), 1);
            
            udir_x = x1 - x2;
            udir_y = y1 - y2;
            udir_z = z1 - z2;
            scale = sqrt(udir_x.^2+udir_y.^2+udir_z.^2);

            DB.SC.node{p, v}.x = DB.SC.node{p, v}.x./repmat(scale, [DB.num.node, 1]);
            DB.SC.node{p, v}.y = DB.SC.node{p, v}.y./repmat(scale, [DB.num.node, 1]);
            DB.SC.node{p, v}.z = DB.SC.node{p, v}.z./repmat(scale, [DB.num.node, 1]);
            
            
            M = repmat(M, [1, DB.num.node, 1]);
            L = repmat(L, [1, DB.num.node, 1]);
            T = repmat(T, [1, DB.num.node, 1]);

            X = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);
            Y = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);
            Z = zeros(1, DB.num.node, DB.T.param.node{p, v}.num);

            X(1, :, :) = DB.SC.node{p, v}.x;
            Y(1, :, :) = DB.SC.node{p, v}.y;
            Z(1, :, :) = DB.SC.node{p, v}.z;

            XYZ = cat(1, X, Y, Z);

            DB.SC.node{p, v}.x(:,:) = sum(XYZ.*M, 1);
            DB.SC.node{p, v}.y(:,:) = sum(XYZ.*L, 1);
            DB.SC.node{p, v}.z(:,:) = sum(XYZ.*T, 1);
    
        end
    end
elseif DB.opt.align_method == 4 % Only translation
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video

            DB.SC.node{p, v}.x = DB.SC.node{p, v}.x - repmat(DB.SC.node{p, v}.x(11, :), [DB.num.node, 1]);
            DB.SC.node{p, v}.y = DB.SC.node{p, v}.y - repmat(DB.SC.node{p, v}.y(11, :), [DB.num.node, 1]);
            DB.SC.node{p, v}.z = DB.SC.node{p, v}.z - repmat(DB.SC.node{p, v}.z(11, :), [DB.num.node, 1]);
            
        end
    end
else
    
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            %% Torso center
            x1 = mean(DB.SC.node{p, v}.x(upper_torso_node, :), 1);
            y1 = mean(DB.SC.node{p, v}.y(upper_torso_node, :), 1);
            z1 = mean(DB.SC.node{p, v}.z(upper_torso_node, :), 1);
            x2 = mean(DB.SC.node{p, v}.x(lower_torso_node, :), 1);
            y2 = mean(DB.SC.node{p, v}.y(lower_torso_node, :), 1);
            z2 = mean(DB.SC.node{p, v}.z(lower_torso_node, :), 1);
            
            DB.SC.node{p, v}.upper_torso_x = x1;
            DB.SC.node{p, v}.upper_torso_y = y1;
            DB.SC.node{p, v}.upper_torso_z = z1;
            DB.SC.node{p, v}.lower_torso_x = x2;
            DB.SC.node{p, v}.lower_torso_y = y2;
            DB.SC.node{p, v}.lower_torso_z = z2;

            xx = (DB.SC.node{p, v}.upper_torso_x+DB.SC.node{p, v}.lower_torso_x)/2;
            yy = (DB.SC.node{p, v}.upper_torso_y+DB.SC.node{p, v}.lower_torso_y)/2;
            zz = (DB.SC.node{p, v}.upper_torso_z+DB.SC.node{p, v}.lower_torso_z)/2;

            DB.SC.node{p, v}.torso_center = cat(1, xx, yy, zz);
        end
    end
    
end


end