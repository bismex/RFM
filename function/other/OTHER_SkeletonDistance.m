function DB = OTHER_SkeletonDistance(DB)

limbpidx = [];
new_limbpidx = [9 6 19 16;8 5 18 15];
limbpidx = cat(2, limbpidx, new_limbpidx);

all_p = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        x1 = DB.SC.node{p, v}.x(limbpidx(1, :), :);
        x2 = DB.SC.node{p, v}.x(limbpidx(2, :), :);
        y1 = DB.SC.node{p, v}.y(limbpidx(1, :), :);
        y2 = DB.SC.node{p, v}.y(limbpidx(2, :), :);
        z1 = DB.SC.node{p, v}.z(limbpidx(1, :), :);
        z2 = DB.SC.node{p, v}.z(limbpidx(2, :), :);
        dist = sqrt((x1-x2).*(x1-x2) + (y1-y2).*(y1-y2) + (z1-z2).*(z1-z2));
        all_p = cat(2, all_p, dist);
    end
end

DB.feature.all = all_p';
DB.feature.dim = size(DB.feature.all, 2);


end