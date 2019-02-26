function temporal_evidence(score, similarity, margin, logical_on, label_estim, DB_P, start_idx, end_idx)

end_idx = min(end_idx, numel(score));

score = score(start_idx:end_idx);
similarity = similarity(start_idx:end_idx);
margin = margin(start_idx:end_idx);
logical_on = logical_on(start_idx:end_idx);
label_estim = label_estim(start_idx:end_idx);
phase = DB_P.feature.phase;
phase = phase(start_idx:end_idx);
[~, max_score_idx] = max(score);
max_phase_idx = phase(max_score_idx);
max_score_idx = max_score_idx + start_idx - 1;

% color1 = [0.25, 0.80, 0.70];
color1 = [0.9, 0.90, 0.90];
color2 = [0.05, 0.05, 0.05];

fig1 = figure;
 set(fig1, 'OuterPosition', [15, 15, 1500, 530])

subplot(1, 5, 1)
hold on;
label = DB_P.feature.label;
logical1 = find(label_estim==label);
logical2 = 1:numel(score);
logical2(logical1) = [];
score1 = similarity;
score2 = similarity;
score1(logical2) = 0;
score2(logical1) = 0;
barh(score1, 'FaceColor', color1, 'EdgeColor', color2*2, 'LineWidth',0.1)
barh(score2, 'FaceColor', color2, 'EdgeColor', color1/2, 'LineWidth',0.1)
xlabel('value')
ylabel('frame')
title('Similarity')
legend('True', 'False')
grid

subplot(1, 5, 2)
hold on;
label = DB_P.feature.label;
logical1 = find(label_estim==label);
logical2 = 1:numel(score);
logical2(logical1) = [];
score1 = margin.*logical_on;
score2 = margin.*logical_on;
score1(logical2) = 0;
score2(logical1) = 0;
barh(score1, 'FaceColor', color1, 'EdgeColor', color2*2, 'LineWidth',0.1)
barh(score2, 'FaceColor', color2, 'EdgeColor', color1/2, 'LineWidth',0.1)
xlabel('value')
ylabel('frame')
title('Margin')
legend('True', 'False')
grid

subplot(1, 5, 3)
hold on;
label = DB_P.feature.label;
logical1 = find(label_estim==label);
logical2 = 1:numel(score);
logical2(logical1) = [];
score1 = score;
score2 = score;
score1(logical2) = 0;
score2(logical1) = 0;
barh(score1, 'FaceColor', color1, 'EdgeColor', color2*2, 'LineWidth',0.1)
barh(score2, 'FaceColor', color2, 'EdgeColor', color1/2, 'LineWidth',0.1)
xlabel('value')
ylabel('frame')
title('Marginal similarity')
legend('True', 'False')
grid


subplot(1, 5, 4)
hold on;
color_all = colormap(lines);
logical1 = find(phase~=1);
logical2 = find(phase~=2);
logical3 = find(phase~=3);
logical4 = find(phase~=4);
score1 = phase;
score2 = phase;
score3 = phase;
score4 = phase;
score1(logical1) = 0;
score2(logical2) = 0;
score3(logical3) = 0;
score4(logical4) = 0;
barh(score1, 'FaceColor', color_all(1, :), 'EdgeColor', [1, 1, 1])
barh(score2, 'FaceColor', color_all(2, :), 'EdgeColor', [1, 1, 1])
barh(score3, 'FaceColor', color_all(3, :), 'EdgeColor', [1, 1, 1])
barh(score4, 'FaceColor', color_all(4, :), 'EdgeColor', [1, 1, 1])
xlabel('label')
ylabel('frame')
title('Estimated temporal segment')
legend('1', '2', '3', '4')
grid


subplot(1, 5, 5)
p = DB_P.feature.label;
v = DB_P.feature.video;
if DB_P.num.node == 20

    start_p_torso = [2, 2, 2, 2, 12, 12, 12];
    end_p_torso = [1, 3, 4, 11, 11, 13, 14];
    start_p_limb = [3, 8, 9, 4, 5, 6, 13, 18, 19, 14, 15, 16];
    end_p_limb = [8, 9, 10, 5, 6, 7, 18, 19, 20, 15, 16, 17];

elseif DB_P.num.node == 25

    start_p_torso = [3, 3, 3, 3, 21, 1, 1, 1];
    end_p_torso = [21, 9, 5, 2, 4, 2, 13, 17];
    start_p_limb = [9, 10, 11, 12, 12, 5, 6, 7, 8, 8, 17, 18, 19, 13, 14, 15];
    end_p_limb = [10, 11, 12, 24, 25, 6, 7, 8, 22, 23, 18, 19, 20, 14, 15, 16];

else 
    fprintf('DB error (number of nodes) \n')
end

align_flag = 1;
edge_line = 1;
node_line = 1;
node_size = 10;
node_color = [0, 0.1, 0.2];
edge_torso_color = color_all(max_phase_idx, :);
edge_limb_color = color_all(max_phase_idx, :);


% fig1 = figure;
% clf;
hold on
if align_flag
    plot3(0, 0, 0, 'r*', 'LineWidth', 4, 'MarkerSize', 20)
    quiver3(0.6, 0.6, 0.6, 0.5, 0, 0, 'LineWidth', 3, 'color', 'r');
    quiver3(0.6, 0.6, 0.6, 0, 0.5, 0, 'LineWidth', 3, 'color', 'g');
    quiver3(0.6, 0.6, 0.6, 0, 0, 0.5, 'LineWidth', 3, 'color', 'b');
    text(1.1, 0.6, 0.6, 'Moving dir', 'LineWidth', 2)
    text(0.6, 1.1, 0.6, 'Left dir', 'LineWidth', 2)
    text(0.6, 0.6, 1.1, 'Top dir', 'LineWidth', 2)
    text(0, 0, 0, 'Origin', 'LineWidth', 2)
end

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
% set(fig1, 'OuterPosition', [15, 15, 500, 800])
% set(fig1, 'OuterPosition', [15, 15, 700, 800])
%     title('Aligned skeleton')
title('Skeleton with the highest score')



%     node = cat(3, DB.SC.node{p, v}.x, DB.SC.node{p, v}.y, DB.SC.node{p, v}.z);
if align_flag
    node = cat(3, DB_P.SC.node{p, v}.x, DB_P.SC.node{p, v}.y, DB_P.SC.node{p, v}.z);
else
    node = cat(3, DB_P.SC.node{p, v}.z, DB_P.SC.node{p, v}.x, DB_P.SC.node{p, v}.y);
end
%     node = cat(3, DB.SC.node{p, v}.x, DB.SC.node{p, v}.z, DB.SC.node{p, v}.y);
%     for f = 1 : DB.T.param.node{p, v}.num
for f = max_score_idx
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


    for n = 1 : DB_P.num.node
        x = node(n, f, 1);
        y = node(n, f, 2);
        z = node(n, f, 3);
        plot3(x, y, z, '.', 'color', node_color, 'MarkerSize', node_size, 'LineWidth', node_line)
    end

end

hold off





end