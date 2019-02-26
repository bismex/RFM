function DB = PositionVector(DB)

limbpidx = [];
new_limbpidx = [8 5 18 15 9 6 19 16;0 0 0 0 8 5 18 15];


switch DB.opt.feature_recognition_test % Variants
    case 0
        new_limbpidx = [8 5 18 15 9 6 19 16;0 0 0 0 8 5 18 15];
    case 1
        new_limbpidx = [8 5 18 15 9 6 19 16 8 5 18 15;0 0 0 0 8 5 18 15 3 4 13 14];
    case 2
        new_limbpidx = [8 5 18 15 9 6 19 16 8 5 18 15 3 4 13 14;0 0 0 0 8 5 18 15 3 4 13 14 0 0 0 0];
    case 3
        new_limbpidx = [8 5 18 15 9 6 19 16 9 6 16 19;0 0 0 0 8 5 18 15 6 16 19 9];
    case 4
        new_limbpidx = [8 5 18 15 9 6 19 16 9 6;0 0 0 0 8 5 18 15 19 16];
    case 5
        new_limbpidx = [8 5 18 15 9 6 19 16 9 6;0 0 0 0 8 5 18 15 19 19];
    case 6
        new_limbpidx = [8 5 18 15 9 6 19 16 8 5 15 18;0 0 0 0 8 5 18 15 5 15 18 8];
    case 7
        new_limbpidx = [8 5 18 15 9 6 19 16 8 5;0 0 0 0 8 5 18 15 18 15];
    case 8 
        new_limbpidx = [8 5 18 15 9 6 19 16 8 5;0 0 0 0 8 5 18 15 15 18];
    case 9
        new_limbpidx = [8 5 15 18 9 6 19 16;5 15 18 8 8 5 18 15];
    case 10
        new_limbpidx = [8 5 15 18 9 6 19 16 9 6 16 19;5 15 18 8 8 5 18 15 6 16 19 9];
    case 11
        new_limbpidx = [8 5 15 18 9 6 19 16 8 5 15 18;5 15 18 8 8 5 18 15 3 4 14 13];
end
% new_limbpidx = [8 9 5 6 18 19 15 16 9 6 19 16 ;0 0 0 0 0 0 0 0 8 5 18 15 ];


% new_limbpidx = [9 6 19 16;8 5 18 15]; % indirect
% new_limbpidx = [8 5 18 15;0 0 0 0]; % direct
limbpidx = cat(2, limbpidx, new_limbpidx);

logical_on = limbpidx(2, :) ~= 0;

all_p = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        x1 = DB.SC.node{p, v}.x(limbpidx(1, logical_on), :);
        x2 = DB.SC.node{p, v}.x(limbpidx(2, logical_on), :);
        y1 = DB.SC.node{p, v}.y(limbpidx(1, logical_on), :);
        y2 = DB.SC.node{p, v}.y(limbpidx(2, logical_on), :);
        z1 = DB.SC.node{p, v}.z(limbpidx(1, logical_on), :);
        z2 = DB.SC.node{p, v}.z(limbpidx(2, logical_on), :);
        point = [];
        if DB.opt.proj_method(1), point = cat(1, point, x1-x2); end
        if DB.opt.proj_method(2), point = cat(1, point, y1-y2); end
        if DB.opt.proj_method(3), point = cat(1, point, z1-z2); end
        all_p = cat(2, all_p, point);
    end
end

all_p2 = [];
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        x1 = DB.SC.node{p, v}.x(limbpidx(1, ~logical_on), :);
        y1 = DB.SC.node{p, v}.y(limbpidx(1, ~logical_on), :);
        z1 = DB.SC.node{p, v}.z(limbpidx(1, ~logical_on), :);
        point = [];
        if DB.opt.proj_method(1), point = cat(1, point, x1); end
        if DB.opt.proj_method(2), point = cat(1, point, y1); end
        if DB.opt.proj_method(3), point = cat(1, point, z1); end
        all_p2 = cat(2, all_p2, point);
    end
end

DB.feature.division = [size(all_p, 1), size(all_p2, 1)]; % for DTW kernel (other recognition methods)
DB.feature.all = cat(1, all_p, all_p2)';
DB.feature.dim = size(DB.feature.all, 2);



end