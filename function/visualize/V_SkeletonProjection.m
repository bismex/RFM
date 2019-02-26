function V_SkeletonProjection(DB)



if DB.opt.visualize
    
    start_p_torso = [2, 2, 2, 2, 12, 12, 12];
    end_p_torso = [1, 3, 4, 11, 11, 13, 14];
    start_p_limb = [3, 8, 9, 4, 5, 6, 13, 18, 19, 14, 15, 16];
    end_p_limb = [8, 9, 10, 5, 6, 7, 18, 19, 20, 15, 16, 17];
    edge_line = 1;
    node_line = 1;
    node_size = 8;
    node_color = [0, 0.1, 0.2];
    edge_torso_color = [0.5, 0.7, 0.6];
    edge_limb_color = [0.7, 0.8, 0.8];
   
    p = 1;
    v = 4;
    
    fig1 = figure(5);
    clf;
    hold on
%     plot3(0, 0, 0, 'r*', 'LineWidth', 4, 'MarkerSize', 20)
    quiver3(0.6, 0.6, 0.6, 0.5, 0, 0, 'LineWidth', 3, 'color', 'r');
    quiver3(0.6, 0.6, 0.6, 0, 0.5, 0, 'LineWidth', 3, 'color', 'g');
    quiver3(0.6, 0.6, 0.6, 0, 0, 0.5, 'LineWidth', 3, 'color', 'b');
%     text(1.1, 0.6, 0.6, 'Moving dir', 'LineWidth', 2)
%     text(0.7, 0.7, 0.6, 'Left dir', 'LineWidth', 2)
    text(0.6, 1.1, 0.6, 'Left dir', 'LineWidth', 2)
    text(0.6, 0.6, 1.1, 'Top dir', 'LineWidth', 2)
%     text(0, 0, 0, 'Origin', 'LineWidth', 2)

    xlabel('x')
%     ylabel('z')
%     zlabel('y')
    ylabel('y')
    zlabel('z')
    grid

%     view(300, 20)
%     view(40, 30)
    view(90, 0)
    axis equal
    axis([-1.2, 1.2, -1, 1, -2.9 1.3])
%     axis([-1.2, 0.7, -0.55, 0.55, -2.8 1])
%     axis([-3.2, 2.7, -2.55, 2.55, -5 3])
    set(fig1, 'OuterPosition', [15, 15, 400, 500])
%     set(fig1, 'OuterPosition', [15, 15, 300, 500])
%     set(fig1, 'OuterPosition', [15, 15, 1000, 1000])
    title('L-T plane projection')



    node = cat(3, DB.SC.node{p, v}.x(:, 20:80), DB.SC.node{p, v}.y(:, 20:80), DB.SC.node{p, v}.z(:, 20:80));
    color_map = lines;
%     color1 = color_map(2, :);
%     
%     edge_torso_color = color1+0.1;
%     edge_torso_color = min(edge_torso_color, 1);
%     edge_limb_color = color1+0.1;
%     edge_limb_color = min(edge_limb_color, 1);
%     node_color = color1-0.2;
%     node_color = max(node_color, 0);
    
    for f = 6:48
        if f>=6 && f<18
            color1 = color_map(1, :);
        end
        if f>=18 && f<28
            color1 = color_map(2, :);
        end
        if f>=28 && f<40
            color1 = color_map(3, :);
        end
        if f>=40 && f<50
            color1 = color_map(4, :);
        end
        
        edge_torso_color = color1+0.1;
        edge_torso_color = min(edge_torso_color, 1);
        edge_limb_color = color1+0.1;
        edge_limb_color = min(edge_limb_color, 1);
        node_color = color1-0.2;
        node_color = max(node_color, 0);

        
        
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