function V_FootProjection(DB)

if DB.opt.visualize

    %foot trajectory
    y1 = DB.SC.node{1, 4}.y(16, 20:80);
    x1 = DB.SC.node{1, 4}.x(16, 20:80);
    y2 = DB.SC.node{1, 4}.y(19, 20:80);
    x2 = DB.SC.node{1, 4}.x(19, 20:80);
    z1 = zeros(1, numel(DB.SC.node{1, 4}.y(20, 20:80)));
    node1 = cat(1, x1, y1, z1);
    node2 = cat(1, x2, y2, z1);
    fig1 = figure(6);
    clf
    hold on
    axis([-1.2, 0.7, -0.5, 0.5, -2.8 1])
    view([90, 90])
    grid
    title('Phase 4(Trajectory of feet)')
    % axis square
    xlabel('x')
    ylabel('y')
    set(fig1, 'OuterPosition', [15, 500, 270, 500])
    color_map = lines;
    node_line = 1;
    edge_line = 1;
    node_size = 15;

    % a = DB.gaitcycle{1, 4}.phase_vec(20:80)
    for f = 40:49
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

        x1 = node1(1, f);
        y1 = node1(2, f);
        z1 = node1(3, f);
        plot3(x1, y1, z1, '.', 'color', node_color, 'MarkerSize', node_size, 'LineWidth', node_line)
        if f>=41
            line([old_x1, x1], [old_y1, y1], [old_z1, z1], 'color', edge_limb_color, 'LineWidth', edge_line)
        end
        old_x1 = x1;
        old_y1 = y1;
        old_z1 = z1;

        x2 = node2(1, f);
        y2 = node2(2, f);
        z2 = node2(3, f);
        plot3(x2, y2, z2, '.', 'color', node_color, 'MarkerSize', node_size, 'LineWidth', node_line)
        if f>=41
            line([old_x2, x2], [old_y2, y2], [old_z2, z2], 'color', edge_limb_color, 'LineWidth', edge_line)
        end
        old_x2 = x2;
        old_y2 = y2;
        old_z2 = z2;
    end

end

end