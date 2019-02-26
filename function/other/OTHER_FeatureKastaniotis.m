function DB = OTHER_FeatureKastaniotis(DB)


DB.num.ftype = 2;
DB.feature.method = cell(1, DB.num.ftype);

idxmat = [3, 8, 4, 5, 13, 18, 14, 15 ; 8, 9, 5, 6, 18, 19, 15, 16];

%% 8limbs x 2 euler angle
all_theta = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        x1 = DB.SC.node{p, v}.x(idxmat(1, :), :);
        x2 = DB.SC.node{p, v}.x(idxmat(2, :), :);
        y1 = DB.SC.node{p, v}.y(idxmat(1, :), :);
        y2 = DB.SC.node{p, v}.y(idxmat(2, :), :);
        z1 = DB.SC.node{p, v}.z(idxmat(1, :), :);
        z2 = DB.SC.node{p, v}.z(idxmat(2, :), :);
        px = x2-x1;
        py = y2-y1;
        pz = z2-z1;
        
        theta = acos(py./(sqrt(px.^2+py.^2+pz.^2)+eps));
        
        px = x2-x1;
        pz = z2-z1;
        
        theta2 = acos(px./(sqrt(px.^2+pz.^2)+eps));
        
        all_theta = cat(2, all_theta, cat(1, theta, theta2));
    end
end

DB.feature.all = all_theta';
DB.feature.dim = size(DB.feature.all, 2);
DB.feature.method{1} = 'euclidean';
DB.feature.method{2} = 'cosine';


end