function DB = OTHER_FeatureBall(DB)


DB.num.ftype = 2;
DB.feature.method = cell(1, DB.num.ftype);

%% 18features
idxmat1 = [13, 14;18, 15]; % upper leg
idxmat2 = [18, 14;19, 16]; % lower leg
idxmat3 = [19, 16;20, 17]; % foot
all_theta = [];

for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        % upper leg, vertical
        x1 = DB.SC.node{p, v}.x(idxmat1(1, :), :);
        x2 = DB.SC.node{p, v}.x(idxmat1(2, :), :);
        y1 = DB.SC.node{p, v}.y(idxmat1(1, :), :);
        y2 = DB.SC.node{p, v}.y(idxmat1(2, :), :);
        z1 = DB.SC.node{p, v}.z(idxmat1(1, :), :);
        z2 = DB.SC.node{p, v}.z(idxmat1(2, :), :);
        px1 = x2-x1;
        py1 = y2-y1;
        pz1 = z2-z1;
        dist1 = sqrt(px1.^2+py1.^2+pz1.^2)+eps;
        px2 = 0;
        py2 = 0;
        pz2 = 1;
        dist2 = sqrt(px2.^2+py2.^2+pz2.^2)+eps;
        theta1 = acos((px1.*px2+py1.*py2+pz1.*pz2)./(dist1.*dist2));
        
        % upper leg, lower leg
        x1 = DB.SC.node{p, v}.x(idxmat2(1, :), :);
        x2 = DB.SC.node{p, v}.x(idxmat2(2, :), :);
        y1 = DB.SC.node{p, v}.y(idxmat2(1, :), :);
        y2 = DB.SC.node{p, v}.y(idxmat2(2, :), :);
        z1 = DB.SC.node{p, v}.z(idxmat2(1, :), :);
        z2 = DB.SC.node{p, v}.z(idxmat2(2, :), :);
        px2 = x2-x1;
        py2 = y2-y1;
        pz2 = z2-z1;
        dist2 = sqrt(px2.^2+py2.^2+pz2.^2)+eps;
        theta2 = acos((px1.*px2+py1.*py2+pz1.*pz2)./(dist1.*dist2));
        
        
        % lower leg, horizontal
        x1 = DB.SC.node{p, v}.x(idxmat3(1, :), :);
        x2 = DB.SC.node{p, v}.x(idxmat3(2, :), :);
        y1 = DB.SC.node{p, v}.y(idxmat3(1, :), :);
        y2 = DB.SC.node{p, v}.y(idxmat3(2, :), :);
        z1 = DB.SC.node{p, v}.z(idxmat3(1, :), :);
        z2 = DB.SC.node{p, v}.z(idxmat3(2, :), :);
        px1 = x2-x1;
        py1 = y2-y1;
        pz1 = z2-z1;
        dist1 = sqrt(px1.^2+py1.^2+pz1.^2)+eps;
        px2 = 1;
        py2 = 1;
        pz2 = 0;
        dist2 = sqrt(px2.^2+py2.^2+pz2.^2)+eps;
        theta3 = acos((px1.*px2+py1.*py2+pz1.*pz2)./(dist1.*dist2));
        
        theta = cat(1, theta1, theta2, theta3);
        all_theta = cat(2, all_theta, theta);
    end
end


DB.feature.all = all_theta';
DB.feature.dim = size(DB.feature.all, 2);
DB.feature.method{1} = 'euclidean';
DB.feature.method{2} = 'cosine';

end