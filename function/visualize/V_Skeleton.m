function V_Skeleton(DB, p, v, f1, f2, f3, f4, align_flag, flag_vec)

if DB.opt.visualize
    
    if DB.num.node == 20 || DB.num.node == 21
        
        start_p_torso = [2, 2, 2, 2, 12, 12, 12];
        end_p_torso = [1, 3, 4, 11, 11, 13, 14];
        start_p_limb = [3, 8, 9, 4, 5, 6, 13, 18, 19, 14, 15, 16];
        end_p_limb = [8, 9, 10, 5, 6, 7, 18, 19, 20, 15, 16, 17];
    
    elseif DB.num.node == 25
    
        start_p_torso = [3, 3, 3, 3, 21, 1, 1, 1];
        end_p_torso = [21, 9, 5, 2, 4, 2, 13, 17];
        start_p_limb = [9, 10, 11, 12, 12, 5, 6, 7, 8, 8, 17, 18, 19, 13, 14, 15];
        end_p_limb = [10, 11, 12, 24, 25, 6, 7, 8, 22, 23, 18, 19, 20, 14, 15, 16];
    
    else 
        fprintf('DB error (number of nodes) \n')
    end
%     node_idx = 1 : 20;
    node_idx = [1,2,3,4,11,12,13,14];
    
    upper_idx_static = [2,2,2,2,3,8,9,4,5,6;1,3,4,11,8,9,10,5,6,7];
    lower_idx_static = [12,12,12,13,18,19,14,15,16;11,13,14,18,19,20,15,16,17];
    
    
    
    edge_torso_line = 1;
    edge_limb_line = 1;
    edge_line = edge_limb_line;
    node_line = 1;
    node_size = 10;
    node_color = [0, 0.1, 0.2];
%     edge_torso_color = [0.7, 0.8, 0.8];
    edge_torso_color = [0.9, 0.25, 0.3];
%     edge_limb_color = [0.5, 0.7, 0.6];
%     edge_limb_color = [0.7, 0.8, 0.8];
    edge_limb_color = [0.4, 0.7, 0.85];
    
    fig1 = figure;
    clf;
    hold on
%     if align_flag
%         plot3(0, 0, 0, 'r*', 'LineWidth', 4, 'MarkerSize', 20)
%         quiver3(0.6, 0.6, 0.6, 0.5, 0, 0, 'LineWidth', 3, 'color', 'r');
%         quiver3(0.6, 0.6, 0.6, 0, 0.5, 0, 'LineWidth', 3, 'color', 'g');
%         quiver3(0.6, 0.6, 0.6, 0, 0, 0.5, 'LineWidth', 3, 'color', 'b');
%         text(1.1, 0.6, 0.6, 'Moving dir', 'LineWidth', 2)
%         text(0.6, 1.1, 0.6, 'Left dir', 'LineWidth', 2)
%         text(0.6, 0.6, 1.1, 'Top dir', 'LineWidth', 2)
%         text(0, 0, 0, 'Origin', 'LineWidth', 2)
%     end

    if align_flag
        xlabel('M')
        ylabel('L')
        zlabel('T')
    else
        xlabel('Z')
        ylabel('X')
        zlabel('Y')
    end
    grid

%     view(300, 20)
    if align_flag
        view(45, 10)
    else
        view(-135, 10)
    end
    axis equal
    set(fig1, 'OuterPosition', [15, 15, 500, 800])
    set(fig1, 'OuterPosition', [15, 15, 700, 800])
%     title('Aligned skeleton')
    title(['Spatial noise : ', num2str(DB.opt.error)])



%     node = cat(3, DB.SC.node{p, v}.x, DB.SC.node{p, v}.y, DB.SC.node{p, v}.z);
    if align_flag
        node = cat(3, DB.SC.node{p, v}.x, DB.SC.node{p, v}.y, DB.SC.node{p, v}.z);
    else
        node = cat(3, DB.SC.node{p, v}.z, DB.SC.node{p, v}.x, DB.SC.node{p, v}.y);
    end
%     node = cat(3, DB.SC.node{p, v}.x, DB.SC.node{p, v}.z, DB.SC.node{p, v}.y);
%     for f = 1 : DB.T.param.node{p, v}.num
    for f = min(f1) : min(max(f1), DB.T.param.node{p, v}.num)
        if sum(f == f2)
            flag_skeleton = flag_vec(1); % 1 : normal, 2 : LO, 3 : UO, 4 : E
        elseif sum(f == f3)
            flag_skeleton = flag_vec(2);
        elseif sum(f == f4)
            flag_skeleton = flag_vec(3);
        else
            flag_skeleton = 1;
        end
        
        if flag_skeleton == 1
            for t = 1 : numel(start_p_torso)
                sidx = start_p_torso(t);
                eidx = end_p_torso(t);
                sx = node(sidx, f, 1);
                sy = node(sidx, f, 2);
                sz = node(sidx, f, 3);
                ex = node(eidx, f, 1);
                ey = node(eidx, f, 2);
                ez = node(eidx, f, 3);
                line([sx, ex], [sy, ey], [sz, ez], 'color', edge_torso_color, 'LineWidth', edge_torso_line);
            end
            for l = 1 : numel(start_p_limb)
                sidx = start_p_limb(l);
                eidx = end_p_limb(l);
                sx = node(sidx, f, 1);
                sy = node(sidx, f, 2);
                sz = node(sidx, f, 3);
                ex = node(eidx, f, 1);
                ey = node(eidx, f, 2);
                ez = node(eidx, f, 3);
                line([sx, ex], [sy, ey], [sz, ez], 'color', edge_limb_color, 'LineWidth', edge_limb_line, 'LineStyle','-.');
            end
        end
        for n = 1 : numel(node_idx)
            nidx = node_idx(n);
            x = node(nidx, f, 1);
            y = node(nidx, f, 2);
            z = node(nidx, f, 3);
            plot3(x, y, z, '.', 'color', node_color, 'MarkerSize', node_size, 'LineWidth', node_line);
        end
            

        switch flag_skeleton
            case 1
                start_p_upper = [];
                end_p_upper = [];
                start_p_lower = [];
                end_p_lower = [];
                edge_upper_color = [];
                edge_lower_color = [];
            case 2
                start_p_upper = upper_idx_static(1, :);
                end_p_upper = upper_idx_static(2, :);
                start_p_lower = lower_idx_static(1, :);
                end_p_lower = lower_idx_static(2, :);
                edge_upper_color = edge_torso_color; % red
                edge_lower_color = [0.9, 0.4, 0.4]; % red
            case 3
                start_p_upper = upper_idx_static(1, :);
                end_p_upper = upper_idx_static(2, :);
                start_p_lower = lower_idx_static(1, :);
                end_p_lower = lower_idx_static(2, :);
                edge_upper_color = [0.4, 0.4, 0.8]; % red
                edge_lower_color = edge_torso_color; % red
            case 4
                start_p_upper = upper_idx_static(1, :);
                end_p_upper = upper_idx_static(2, :);
                start_p_lower = lower_idx_static(1, :);
                end_p_lower = lower_idx_static(2, :);
                edge_upper_color = [0.2, 0.7, 0.7];
                edge_lower_color = [0.2, 0.7, 0.7];
            case 5
                start_p_upper = upper_idx_static(1, :);
                end_p_upper = upper_idx_static(2, :);
                start_p_lower = lower_idx_static(1, :);
                end_p_lower = lower_idx_static(2, :);
                edge_upper_color = [0.4, 0.4, 0.8]; % red
                edge_lower_color = [0.2, 0.7, 0.7];
            case 6
                start_p_upper = upper_idx_static(1, :);
                end_p_upper = upper_idx_static(2, :);
                start_p_lower = lower_idx_static(1, :);
                end_p_lower = lower_idx_static(2, :);
                edge_upper_color = [0.2, 0.7, 0.7];
                edge_lower_color = [0.9, 0.4, 0.4]; % red
                
                
                
%                 edge_torso_color2 = [0.2, 0.7, 0.7]; % cyan
%                 edge_limb_color2 = [0.8, 0.7, 0.2]; % yellow
%                 edge_torso_color2 = [0.4, 0.4, 0.8]; % purple
%                 edge_limb_color2 = [0.9, 0.4, 0.4]; % red

        end
        
        
        for t = 1 : numel(start_p_upper)
            sidx = start_p_upper(t);
            eidx = end_p_upper(t);
            sx = node(sidx, f, 1);
            sy = node(sidx, f, 2);
            sz = node(sidx, f, 3);
            ex = node(eidx, f, 1);
            ey = node(eidx, f, 2);
            ez = node(eidx, f, 3);
            line([sx, ex], [sy, ey], [sz, ez], 'color', edge_upper_color, 'LineWidth', edge_line);
        end
        for l = 1 : numel(start_p_lower)
            sidx = start_p_lower(l);
            eidx = end_p_lower(l);
            sx = node(sidx, f, 1);
            sy = node(sidx, f, 2);
            sz = node(sidx, f, 3);
            ex = node(eidx, f, 1);
            ey = node(eidx, f, 2);
            ez = node(eidx, f, 3);
            line([sx, ex], [sy, ey], [sz, ez], 'color', edge_lower_color, 'LineWidth', edge_line);
        end
        
%         for n = 1 : numel(node_idx2)
%             nidx = node_idx2(n);
%             x = node(nidx, f, 1);
%             y = node(nidx, f, 2);
%             z = node(nidx, f, 3);
%             plot3(x, y, z, '.', 'color', node_color, 'MarkerSize', node_size, 'LineWidth', node_line);
%         end
        
        
    end

    hold off
    
    
end









end