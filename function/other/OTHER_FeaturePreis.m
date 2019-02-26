function DB = OTHER_FeaturePreis(DB)


DB.num.ftype = 2;
DB.feature.method = cell(1, DB.num.ftype);

%% 13features
% 9feat : torso, both lower legs, both thighs, both upper, arms, both fore arms
% length of legs, steplength, speed

% height

idxmat = [13, 18, 14, 15, 2, 3, 4, 8, 5;18, 19, 15, 16, 12, 8, 5, 9, 6];

all_dist = [];

for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        % 9 length
        x1 = DB.SC.node{p, v}.x(idxmat(1, :), :);
        x2 = DB.SC.node{p, v}.x(idxmat(2, :), :);
        y1 = DB.SC.node{p, v}.y(idxmat(1, :), :);
        y2 = DB.SC.node{p, v}.y(idxmat(2, :), :);
        z1 = DB.SC.node{p, v}.z(idxmat(1, :), :);
        z2 = DB.SC.node{p, v}.z(idxmat(2, :), :);
        px = x2-x1;
        py = y2-y1;
        pz = z2-z1;
        length9 = sqrt(px.^2+py.^2+pz.^2);
        
        %leg_length
        leg_length = ((length9(1,:) + length9(2,:)) + (length9(3,:) + length9(4,:)))/2;
        
        % height
        zr = DB.SC.node{p, v}.z(1, :);
        z1 = DB.SC.node{p, v}.z(16, :);
        z2 = DB.SC.node{p, v}.z(17, :);
        z3 = DB.SC.node{p, v}.z(19, :);
        z4 = DB.SC.node{p, v}.z(20, :);
        
        dist1 = sqrt((zr-z1).^2);
        dist2 = sqrt((zr-z2).^2);
        dist3 = sqrt((zr-z3).^2);
        dist4 = sqrt((zr-z4).^2);
        dist = [dist1;dist2;dist3;dist4];
        height = max(dist);
        
        % speed
        speed = diff(DB.SC.node{p, v}.torso_center');
        speed = sqrt(speed(:, 1).^2 + speed(:, 2).^2 + speed(:, 3).^2);
        speed = [speed(1); speed]';
        
        % steplength
        x1 = DB.SC.node{p, v}.x(19, :);
        x2 = DB.SC.node{p, v}.x(16, :);
        y1 = DB.SC.node{p, v}.y(19, :);
        y2 = DB.SC.node{p, v}.y(16, :);
        z1 = DB.SC.node{p, v}.z(19, :);
        z2 = DB.SC.node{p, v}.z(16, :);
        px = x2-x1;
        py = y2-y1;
        pz = z2-z1;
        steplength = sqrt(px.^2+py.^2+pz.^2);
        
        dist = cat(1, length9, leg_length, height, speed, steplength);
        all_dist = cat(2, all_dist, dist);
    end
end

DB.feature.all = all_dist';
DB.feature.dim = size(DB.feature.all, 2);
DB.feature.method{1} = 'euclidean';
DB.feature.method{2} = 'cosine';




end