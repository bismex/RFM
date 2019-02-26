function DB = new_feature(DB) % New feature test

limbpidx = [];
new_limbpidx = [8 5 18 15 9 6 19 16;0 0 0 0 8 5 18 15];
% new_limbpidx = [9 6 19 16;8 5 18 15]; % indirect
% new_limbpidx = [8 5 18 15;0 0 0 0]; % direct
limbpidx = cat(2, limbpidx, new_limbpidx);

logical_on = limbpidx(2, :) ~= 0;


if DB.opt.method_feat_sub  == 8 % Static
        
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

    
    new_all_p = [];
    tmp_all_p = all_p;
    tmp_all_p = tmp_all_p.^2;
    for i = 1 : size(all_p, 1)/3
        tmp = tmp_all_p(i:size(all_p, 1)/3:size(all_p, 1), :);
        new_point = sqrt(sum(tmp, 1));
        new_all_p = cat(1, new_all_p, new_point);
    end
    all_p = new_all_p;
    all_p2 = [];
    
%     new_all_p = [];
%     tmp_all_p = all_p2;
%     tmp_all_p = tmp_all_p.^2;
%     for i = 1 : size(all_p2, 1)/3
%         tmp = tmp_all_p(i:size(all_p2, 1)/3:size(all_p2, 1), :);
%         new_point = sqrt(sum(tmp, 1));
%         new_all_p = cat(1, new_all_p, new_point);
%     end
%     all_p2 = new_all_p;
    
elseif DB.opt.method_feat_sub  == 9 % Dynamic
    
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
    
    new_all_p = [];
    tmp_all_p = all_p;
    tmp_all_p = tmp_all_p.^2;
    for i = 1 : size(all_p, 1)/3
        tmp = tmp_all_p(i:size(all_p, 1)/3:size(all_p, 1), :);
        new_point = sqrt(sum(tmp, 1));
        new_all_p = cat(1, new_all_p, new_point);
    end
    new_all_p = repmat(new_all_p, [3, 1]);
    all_p = all_p./new_all_p;
    
    new_all_p = [];
    tmp_all_p = all_p2;
    tmp_all_p = tmp_all_p.^2;
    for i = 1 : size(all_p2, 1)/3
        tmp = tmp_all_p(i:size(all_p2, 1)/3:size(all_p2, 1), :);
        new_point = sqrt(sum(tmp, 1));
        new_all_p = cat(1, new_all_p, new_point);
    end
    new_all_p = repmat(new_all_p, [3, 1]);
    all_p2 = all_p2./new_all_p;
   
elseif DB.opt.method_feat_sub == 10

    all_p = [];
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            x1 = DB.SC.node{p, v}.x(limbpidx(1, logical_on), :);
            y1 = DB.SC.node{p, v}.y(limbpidx(1, logical_on), :);
            z1 = DB.SC.node{p, v}.z(limbpidx(1, logical_on), :);
            point = cat(1, x1, y1, z1);
            point = diff(point, [], 2);
            point = cat(2, point(:, 1), point);
            all_p = cat(2, all_p, point);
        end
    end
    
    all_p2 = [];
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            x2 = DB.SC.node{p, v}.x(limbpidx(2, logical_on), :);
            y2 = DB.SC.node{p, v}.y(limbpidx(2, logical_on), :);
            z2 = DB.SC.node{p, v}.z(limbpidx(2, logical_on), :);
            point = cat(1, x2, y2, z2);
            point = diff(point, [], 2);
            point = cat(2, point(:, 1), point);
            all_p2 = cat(2, all_p2, point);
        end
    end
    
elseif DB.opt.method_feat_sub == 11

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
            point = diff(point, [], 2);
            point = cat(2, point(:, 1), point);
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
            point = diff(point, [], 2);
            point = cat(2, point(:, 1), point);
            all_p2 = cat(2, all_p2, point);
        end
    end
    
    
elseif DB.opt.method_feat_sub == 12
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
            point2 = diff(point, [], 2);
            point2 = cat(2, point2(:, 1), point2);
            point = cat(1, point, point2);
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
            point2 = diff(point, [], 2);
            point2 = cat(2, point2(:, 1), point2);
            point = cat(1, point, point2);
            all_p2 = cat(2, all_p2, point);
        end
    end
    
    
    
    
end

DB.feature.all = cat(1, all_p, all_p2)';
DB.feature.dim = size(DB.feature.all, 2);


end