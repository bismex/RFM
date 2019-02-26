function DB = GaitPoseSkeleton(DB)



DB.num.ftype = 2;
DB.feature.method = cell(1, DB.num.ftype);


idxmat1 = [2, 2, 2, 2, 12, 12, 12, 3, 8, 9, 4, 5, 6, 13, 18, 19, 14, 15, 16];
idxmat1 = cat(1, idxmat1, [1, 3, 4, 11, 11, 13, 14, 8, 9, 10, 5, 6, 7, 18, 19, 20, 15, 16, 17]);


%% skeleton distance
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
DB.feature.all = all_dist';
DB.feature.dim = size(DB.feature.all, 2);
DB.feature.method{1} = 'euclidean';
DB.feature.method{2} = 'cosine';

end