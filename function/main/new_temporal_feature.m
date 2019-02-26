function all_p = new_temporal_feature(DB)

% temporal feature
limbpidx = [12 13 18 12 14 15 14 15 16 ; 13 18 19 14 15 16 13 18 19];

all_p = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        x1 = DB.SC.node{p, v}.x(limbpidx(1, :), :);
        x2 = DB.SC.node{p, v}.x(limbpidx(2, :), :);
        y1 = DB.SC.node{p, v}.y(limbpidx(1, :), :);
        y2 = DB.SC.node{p, v}.y(limbpidx(2, :), :);
        z1 = DB.SC.node{p, v}.z(limbpidx(1, :), :);
        z2 = DB.SC.node{p, v}.z(limbpidx(2, :), :);
        point = [];
        point = cat(1, point, x1-x2);
        point = cat(1, point, y1-y2);
        point = cat(1, point, z1-z2);

        for i = 1 : size(limbpidx, 2)
            idx = i:size(limbpidx, 2):size(limbpidx, 2)*3;
            local_mat = point(idx, :);
            local_mat = local_mat./repmat(sqrt(sum(local_mat.^2, 1)), [3, 1]);
            point(idx, :) = local_mat;
        end

        all_p = cat(2, all_p, point);
    end
end

end