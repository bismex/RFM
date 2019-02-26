function DB = OTHER_FeatureSun(DB)

% idxmat = [13 18 3 8 2 3 2 21 ; 18 19 8 9 11 4 21 1];
idxmat = [13 18 3 8 2 3 2 21 ; 18 19 8 9 11 4 21 1];

all_dist = [];

for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        
        
        % 8 length
        x1 = DB.SC.node{p, v}.x(idxmat(1, :), :);
        x2 = DB.SC.node{p, v}.x(idxmat(2, :), :);
        y1 = DB.SC.node{p, v}.y(idxmat(1, :), :);
        y2 = DB.SC.node{p, v}.y(idxmat(2, :), :);
        z1 = DB.SC.node{p, v}.z(idxmat(1, :), :);
        z2 = DB.SC.node{p, v}.z(idxmat(2, :), :);
        px = x2-x1;
        py = y2-y1;
        pz = z2-z1;
        dist = sqrt(px.^2+py.^2+pz.^2);
        dist = cat(1, dist, DB.SC.node{p, v}.z(1, :));
        
        
        all_dist = cat(2, all_dist, dist);
        
    end
end

DB.feature.all = all_dist';
DB.feature.dim = size(DB.feature.all, 2);



end