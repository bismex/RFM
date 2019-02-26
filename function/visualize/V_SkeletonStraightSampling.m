function V_SkeletonStraightSampling(DB)

if DB.opt.visualize
    
    start_p_torso = [2, 2, 2, 2, 12, 12, 12];
    end_p_torso = [1, 3, 4, 11, 11, 13, 14];
    start_p_limb = [3, 8, 9, 4, 5, 6, 13, 18, 19, 14, 15, 16];
    end_p_limb = [8, 9, 10, 5, 6, 7, 18, 19, 20, 15, 16, 17];
    edge_line = 1;
    node_line = 1;
    node_size = 4;
    node_color = [0.4, 0.6, 0.5];
    edge_torso_color = [0.5, 0.7, 0.6];
    edge_limb_color = [0.7, 0.8, 0.8];
   
    p = 1;
    v = 4;
    
    fig1 = figure(4);
    clf;
    hold on
%     plot3(0, 0, 0, 'r*', 'LineWidth', 4, 'MarkerSize', 20)
%     quiver3(0.6, 0.6, 0.6, 0.5, 0, 0, 'LineWidth', 3, 'color', 'r');
%     quiver3(0.6, 0.6, 0.6, 0, 0.5, 0, 'LineWidth', 3, 'color', 'g');
%     quiver3(0.6, 0.6, 0.6, 0, 0, 0.5, 'LineWidth', 3, 'color', 'b');
%     text(1.1, 0.6, 0.6, 'Moving dir', 'LineWidth', 2)
%     text(0.6, 1.1, 0.6, 'Left dir', 'LineWidth', 2)
%     text(0.6, 0.6, 1.1, 'Top dir', 'LineWidth', 2)
%     text(0, 0, 0, 'Origin', 'LineWidth', 2)

    xlabel('x')
%     ylabel('z')
%     zlabel('y')
    ylabel('y')
    zlabel('z')
%     grid
    axis([-5, 50, -1, 1, -8, 2.5])

%     view(300, 20)
    view(0, 0)
    axis equal
%     axis([-5, 110, -1, 1, -8, 2.5])
    axis([-5, 35, -1, 1, -8, 2.5])
%     set(fig1, 'OuterPosition', [15, 15, 1000, 300])
    set(fig1, 'OuterPosition', [15, 15, 600, 300])
    title('')


    alpha = 0.8;
    alpha2 = 0.0;
    node = cat(3, DB.SC.node{p, v}.x(:, 20:80), DB.SC.node{p, v}.y(:, 20:80), DB.SC.node{p, v}.z(:, 20:80));
    for f = 1 : 61
        if f>=8 && f<20
            idx(f) = 1;
        end
        if f>=20 && f<31
            idx(f) = 2;
        end
        if f>=31 && f<42
            idx(f) = 3;
        end
        if f>=42 && f<54
            idx(f) = 4;
        end
    end
    
    
    node_old = node;
    idx_old = idx;
    node1 = node(:, [10:3:53], :);
    idx1 = idx(:, [10:3:53], :);
    node2 = node(:, [8:3:53], :);
    idx2 = idx(:, [8:3:53], :);
    node3 = node(:, [9:4:53], :);
    idx3 = idx(:, [9:4:53], :);
    node4 = node(:, [12:4:30], :);
    idx4 = idx(:, [12:4:30], :);
%     node = [node1, node2, node3, node3, node4];
%     idx = [idx1, idx2, idx3, idx3, idx4];
    node = [node1, node2];
    idx = [idx1, idx2];
%     node = node4;
%     idx = idx4
%     node = cat(3, DB.SC.node{p, v}.x, DB.SC.node{p, v}.z, DB.SC.node{p, v}.y);
%     for f = 1 : DB.T.param.node{p, v}.num
    color_map = lines;
%     for f = 1:60
    for f = 1:numel(idx)
        node(:, f, 1) = node(:, f, 1) + f * alpha;
        node(:, f, 3) = node(:, f, 3) + f * alpha2;
        if f >=1 && f<=numel(idx)
%         if f >=9 && f<54
%             if f>=8 && f<20
%                 color1 = color_map(1, :);
%             end
%             if f>=20 && f<31
%                 color1 = color_map(2, :);
%             end
%             if f>=31 && f<42
%                 color1 = color_map(3, :);
%             end
%             if f>=42 && f<54
%                 color1 = color_map(4, :);
%             end
            if idx(f)==1
                color1 = color_map(1, :);
            end
            if idx(f)==2
                color1 = color_map(2, :);
            end
            if idx(f)==3
                color1 = color_map(3, :);
            end
            if idx(f)==4
                color1 = color_map(4, :);
            end
            edge_torso_color = color1;
            edge_limb_color = color1;
            node_color = color1-0.2;
            node_color = max(node_color, 0);
        else
            node_color = [0.5, 0.6, 0.6];
            edge_torso_color = [0.8, 0.9, 0.8];
            edge_limb_color = [0.8, 0.9, 0.9];
        end
        for t = 1 : numel(start_p_torso)
            sidx = start_p_torso(t);
            eidx = end_p_torso(t);
            sx = node(sidx, f, 1);
            sy = node(sidx, f, 2);
            sz = node(sidx, f, 3);
            ex = node(eidx, f, 1);
            ey = node(eidx, f, 2);
            ez = node(eidx, f, 3);

            line([sx, ex], [sy, ey], [sz, ez], 'color', edge_torso_color, 'LineWidth', edge_line);
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

            line([sx, ex], [sy, ey], [sz, ez], 'color', edge_limb_color, 'LineWidth', edge_line);
        end


        for n = 1 : DB.num.node
            x = node(n, f, 1);
            y = node(n, f, 2);
            z = node(n, f, 3);
            plot3(x, y, z, '.', 'color', node_color, 'MarkerSize', node_size, 'LineWidth', node_line)
        end

    end

    hold off
    
    
end












end