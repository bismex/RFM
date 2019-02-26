function DB = OTHER_FeatureAhmed(DB)

DB.num.ftype = 2;
DB.feature.method = cell(1, DB.num.ftype);

idxmat1 = [18*ones(1, 5), 19*ones(1, 8), 15*ones(1, 5), 16*ones(1, 7);...
    2, 3, 4, 11, 12, 2, 3, 4, 11, 12, 13, 15, 16, 2, 3, 4, 11, 12, 2, 3, 4, 11, 12, 14, 18];

idxmat2 = [18*ones(1, 2), 19*ones(1, 6), 15*ones(1, 2), 16*ones(1, 5);...
    4, 14, 3, 4, 13, 14, 15, 16, 3, 13, 3, 4, 13, 14, 18];

%% JRD
all_dist = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        x1 = DB.SC.node{p, v}.x(idxmat1(1, :), :);
        x2 = DB.SC.node{p, v}.x(idxmat1(2, :), :);
        y1 = DB.SC.node{p, v}.y(idxmat1(1, :), :);
        y2 = DB.SC.node{p, v}.y(idxmat1(2, :), :);
        z1 = DB.SC.node{p, v}.z(idxmat1(1, :), :);
        z2 = DB.SC.node{p, v}.z(idxmat1(2, :), :);
        dist = sqrt((x1-x2).^2+(y1-y2).^2+(z1-z2).^2);
        all_dist = cat(2, all_dist, dist);
    end
end
dim1 = size(all_dist, 1);
DB.feature.all = all_dist';

%% JRA

all_theta = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        x1 = DB.SC.node{p, v}.x(idxmat2(1, :), :);
        x2 = DB.SC.node{p, v}.x(idxmat2(2, :), :);
        y1 = DB.SC.node{p, v}.y(idxmat2(1, :), :);
        y2 = DB.SC.node{p, v}.y(idxmat2(2, :), :);
        z1 = DB.SC.node{p, v}.z(idxmat2(1, :), :);
        z2 = DB.SC.node{p, v}.z(idxmat2(2, :), :);
        xr = repmat(DB.SC.node{p, v}.x(12, :), [size(idxmat2, 2), 1]);
        yr = repmat(DB.SC.node{p, v}.y(12, :), [size(idxmat2, 2), 1]);
        zr = repmat(DB.SC.node{p, v}.z(12, :), [size(idxmat2, 2), 1]);
        px1 = xr-x1;
        py1 = yr-y1;
        pz1 = zr-z1;
        dist1 = sqrt(px1.^2+py1.^2+pz1.^2);
        px1 = px1./(dist1+eps);
        py1 = py1./(dist1+eps);
        pz1 = pz1./(dist1+eps);
        px2 = x2-xr;
        py2 = y2-yr;
        pz2 = z2-zr;
        dist2 = sqrt(px2.^2+py2.^2+pz2.^2);
        px2 = px2./(dist2+eps);
        py2 = py2./(dist2+eps);
        pz2 = pz2./(dist2+eps);
        theta = acos(px1.*px2+py1.*py2+pz1.*pz2);
        all_theta = cat(2, all_theta, theta);
    end
end
dim2 = size(all_theta, 1);
DB.feature.division = [dim1, dim2];

DB.feature.all = cat(2, DB.feature.all, all_theta');
DB.feature.dim = size(DB.feature.all, 2);
DB.feature.method{1} = 'euclidean';
DB.feature.method{2} = 'cosine';


end