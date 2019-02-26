function V_ScoreSkeleton(DB)

% 매칭이 될경우 보통 어느정도의 similarity를 가지는지
if DB.opt.visualize
    
    start_p_torso = [2, 2, 2, 2, 12, 12, 12];
    end_p_torso = [1, 3, 4, 11, 11, 13, 14];
    start_p_limb = [3, 8, 9, 4, 5, 6, 13, 18, 19, 14, 15, 16];
    end_p_limb = [8, 9, 10, 5, 6, 7, 18, 19, 20, 15, 16, 17];
%     node_color = rand(3, 20);
%     edge_torso_color = rand(3, numel(start_p_torso));
%     edge_limb_color = rand(3, numel(start_p_limb));
    edge_line = 1;
    node_line = 1;
    node_size = 10;
    node_color = [0.7, 0.6, 0.6];
    edge_torso_color = [0.9, 0.9, 0.9];
    edge_limb_color = [0.8, 0.8, 0.8];
    alpha = 0.5;
   
    p = 23;
    v = 1;
    %p1v2에서 다리부분
    %p23 v2
    
    figure(7)
    clf;
    hold on
    plot3(0, 0, 0, 'r*', 'LineWidth', 4, 'MarkerSize', 20)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    grid

    axis equal
    view(45, 10)

    quiver3(0.6, 0.6, 0.6, 0.5, 0, 0, 'LineWidth', 3, 'color', 'r');
    quiver3(0.6, 0.6, 0.6, 0, 0.5, 0, 'LineWidth', 3, 'color', 'g');
    quiver3(0.6, 0.6, 0.6, 0, 0, 0.5, 'LineWidth', 3, 'color', 'b');
    text(1.1, 0.6, 0.6, 'Moving dir', 'LineWidth', 2)
    text(0.6, 1.1, 0.6, 'Left dir', 'LineWidth', 2)
    text(0.6, 0.6, 1.1, 'Top dir', 'LineWidth', 2)

    text(0, 0, 0, 'Origin', 'LineWidth', 2)


    if DB.opt.SC_PhaseSelection
        phase_idx1 = find(DB.gaitcycle{p, v}.phase_vec==1);
        phase_idx2 = find(DB.gaitcycle{p, v}.phase_vec==2);
        phase_idx3 = find(DB.gaitcycle{p, v}.phase_vec==3);
        phase_idx4 = find(DB.gaitcycle{p, v}.phase_vec==4);
    end

    node = cat(3, DB.SC.node{p, v}.x, DB.SC.node{p, v}.y, DB.SC.node{p, v}.z);
    node2 = node;
    for f = 1 : DB.T.param.node{p, v}.num
        score = DB.result.conf_frame(DB.T.param.node{p, v}.idx(f));
        score = 1 - score;
        node2(:,f,1) = node2(:,f,1)+alpha*f; 
        for t = 1 : numel(start_p_torso)
            sidx = start_p_torso(t);
            eidx = end_p_torso(t);
            sx = node(sidx, f, 1);
            sy = node(sidx, f, 2);
            sz = node(sidx, f, 3);
            ex = node(eidx, f, 1);
            ey = node(eidx, f, 2);
            ez = node(eidx, f, 3);

            line([sx, ex], [sy, ey], [sz, ez], 'color', edge_torso_color*score, 'LineWidth', edge_line);
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

            line([sx, ex], [sy, ey], [sz, ez], 'color', edge_limb_color*score, 'LineWidth', edge_line);
        end


        for n = 1 : DB.num.node
            x = node(n, f, 1);
            y = node(n, f, 2);
            z = node(n, f, 3);
            plot3(x, y, z, '.', 'color', node_color*score, 'MarkerSize', node_size, 'LineWidth', node_line)
        end

    end

    hold off
    
     figure(8)
    clf;
    hold on
    plot3(0, 0, 0, 'r*', 'LineWidth', 4, 'MarkerSize', 20)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    grid

%     axis equal
    view(45, 10)

    quiver3(0.6, 0.6, 0.6, 0.5, 0, 0, 'LineWidth', 3, 'color', 'r');
    quiver3(0.6, 0.6, 0.6, 0, 0.5, 0, 'LineWidth', 3, 'color', 'g');
    quiver3(0.6, 0.6, 0.6, 0, 0, 0.5, 'LineWidth', 3, 'color', 'b');
    text(1.1, 0.6, 0.6, 'Moving dir', 'LineWidth', 2)
    text(0.6, 1.1, 0.6, 'Left dir', 'LineWidth', 2)
    text(0.6, 0.6, 1.1, 'Top dir', 'LineWidth', 2)

    text(0, 0, 0, 'Origin', 'LineWidth', 2)


    for f = 1 : DB.T.param.node{p, v}.num
        score = DB.result.conf_frame(DB.T.param.node{p, v}.idx(f));
        score = 1 - score;
        node2(:,f,1) = node2(:,f,1)+alpha*f; 
        for t = 1 : numel(start_p_torso)
            sidx = start_p_torso(t);
            eidx = end_p_torso(t);
            sx = node2(sidx, f, 1);
            sy = node2(sidx, f, 2);
            sz = node2(sidx, f, 3);
            ex = node2(eidx, f, 1);
            ey = node2(eidx, f, 2);
            ez = node2(eidx, f, 3);

            line([sx, ex], [sy, ey], [sz, ez], 'color', edge_torso_color*score, 'LineWidth', edge_line);
        end
        for l = 1 : numel(start_p_limb)
            sidx = start_p_limb(l);
            eidx = end_p_limb(l);
            sx = node2(sidx, f, 1);
            sy = node2(sidx, f, 2);
            sz = node2(sidx, f, 3);
            ex = node2(eidx, f, 1);
            ey = node2(eidx, f, 2);
            ez = node2(eidx, f, 3);

            line([sx, ex], [sy, ey], [sz, ez], 'color', edge_limb_color*score, 'LineWidth', edge_line);
        end


        for n = 1 : DB.num.node
            x = node2(n, f, 1);
            y = node2(n, f, 2);
            z = node2(n, f, 3);
            plot3(x, y, z, '.', 'color', node_color*score, 'MarkerSize', node_size, 'LineWidth', node_line)
        end

    end

    hold off
    
end








end