function DB = GaitPoseLimbGraph(DB)

DB.num.ftype = sum(DB.opt.dissim_method);
DB.feature.method = cell(1, DB.num.ftype);


% x(y-z space proj), y(x-z space proj), z(x-y space proj)축 없앰
% 무엇이 중요한 정보일까(1cycle기준)
% (어깨,골반) 60, 58, 87, 85
% (팔꿈치, 무릎) 66, 62, 94, 96
% (손, 발) 52, 52, 92, 91
% U L cross all 93 97 96 96
% 2번사람, 왼발이 중간에서 앞이고 오른발이 뒤일때 걸음걸이특성
% 

switch DB.opt.limb_node_type
    case 1
        limbidx = [3]; % RU limbs
        limbidx = cat(1, limbidx, [4]); % LU limbs
        limbidx = cat(1, limbidx, [13]); % RL limbs
        limbidx = cat(1, limbidx, [14]); % LL limbs
    case 2
        limbidx = [8]; % RU limbs
        limbidx = cat(1, limbidx, [5]); % LU limbs
        limbidx = cat(1, limbidx, [18]); % RL limbs
        limbidx = cat(1, limbidx, [15]); % LL limbs
    case 3
        limbidx = [9]; % RU limbs
        limbidx = cat(1, limbidx, [6]); % LU limbs
        limbidx = cat(1, limbidx, [19]); % RL limbs
        limbidx = cat(1, limbidx, [16]); % LL limbs
    case 4
        limbidx = [3, 8]; % RU limbs
        limbidx = cat(1, limbidx, [4, 5]); % LU limbs
        limbidx = cat(1, limbidx, [13, 18]); % RL limbs
        limbidx = cat(1, limbidx, [14, 15]); % LL limbs
    case 5
        limbidx = [3, 9]; % RU limbs
        limbidx = cat(1, limbidx, [4, 6]); % LU limbs
        limbidx = cat(1, limbidx, [13, 19]); % RL limbs
        limbidx = cat(1, limbidx, [14, 16]); % LL limbs
    case 6
        limbidx = [8, 9]; % RU limbs
        limbidx = cat(1, limbidx, [5, 6]); % LU limbs
        limbidx = cat(1, limbidx, [18, 19]); % RL limbs
        limbidx = cat(1, limbidx, [15, 16]); % LL limbs
    case 7
        limbidx = [3, 8, 9]; % RU limbs
        limbidx = cat(1, limbidx, [4, 5, 6]); % LU limbs
        limbidx = cat(1, limbidx, [13, 18, 19]); % RL limbs
        limbidx = cat(1, limbidx, [14, 15, 16]); % LL limbs
    case 8
        limbidx = [3, 8, 9, 10]; % RU limbs
        limbidx = cat(1, limbidx, [4, 5, 6, 7]); % LU limbs
        limbidx = cat(1, limbidx, [13, 18, 19, 20]); % RL limbs
        limbidx = cat(1, limbidx, [14, 15, 16, 17]); % LL limbs
    otherwise
        fpritnf('DB.opt.limb_node_type error\n');
end
DB.num.limb = size(limbidx, 2);

limbpidx = [];
% U limbs (1, 2)
% L limbs (3, 4)
% cross Limbs (1, 3), (1, 4), (2, 3), (2, 4)

flag{1} = [1;2];
flag{2} = [3;4];
flag{3} = [1, 1, 2, 2; 3, 4, 3, 4];

for i = 1 : numel(DB.opt.limb_graph_type)
    if DB.opt.limb_graph_type(i) % U limbs (1, 2)
        for j = 1 : size(flag{i}, 2)
            idx1 = limbidx(flag{i}(1, j), :);
            idx2 = limbidx(flag{i}(2, j), :);
            pidx = repmat(idx1, [1, DB.num.limb]);
            temp = repmat(idx2, [DB.num.limb, 1]);
            temp = temp(:)';
            pidx = cat(1, pidx, temp);
            limbpidx = cat(2, limbpidx, pidx);
        end
    end
end



%% skeleton distance
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
        if DB.opt.proj_method(1)
            point = cat(1, point, x2-x1);
        end
        if DB.opt.proj_method(2)
            point = cat(1, point, y2-y1);
        end
        if DB.opt.proj_method(3)
            point = cat(1, point, z2-z1);
        end
        all_p = cat(2, all_p, point);
    end
end

DB.feature.all = all_p';
DB.feature.dim = size(DB.feature.all, 2);

if DB.num.ftype == 2
    DB.feature.method{1} = 'euclidean';
    DB.feature.method{2} = 'cosine';
elseif DB.num.ftype == 1
    if DB.opt.dissim_method(1)
        DB.feature.method{1} = 'euclidean';
    else
        DB.feature.method{1} = 'cosine';
    end
else
    fprintf('dissim_method error\n');
end

if DB.opt.time
    DB.duration.SC_GaitPoseLimbGraph = datetime - DB.time.end_time;
    [h, m, s] = hms(DB.duration.SC_GaitPoseLimbGraph);
    fprintf('[SC_GaitPoseLimbGraph] processing time : %2.0fh:%2.0fm:%2.0fs \n', fix(h), fix(m), fix(s));
    DB.time.end_time = datetime;
end

end