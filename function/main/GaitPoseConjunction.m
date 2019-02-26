function DB = GaitPoseConjunction(DB)

DB.num.ftype = sum(DB.opt.dissim_method);
DB.feature.method = cell(1, DB.num.ftype);

%% node feature

% switch DB.opt.limb_node_type
%     case 1
%         limbidx = [3]; % RU limbs
%         limbidx = cat(1, limbidx, [4]); % LU limbs
%         limbidx = cat(1, limbidx, [13]); % RL limbs
%         limbidx = cat(1, limbidx, [14]); % LL limbs
%     case 2
%         limbidx = [8]; % RU limbs
%         limbidx = cat(1, limbidx, [5]); % LU limbs
%         limbidx = cat(1, limbidx, [18]); % RL limbs
%         limbidx = cat(1, limbidx, [15]); % LL limbs
%     case 3
%         limbidx = [9]; % RU limbs
%         limbidx = cat(1, limbidx, [6]); % LU limbs
%         limbidx = cat(1, limbidx, [19]); % RL limbs
%         limbidx = cat(1, limbidx, [16]); % LL limbs
%     case 4
%         limbidx = [3, 8]; % RU limbs
%         limbidx = cat(1, limbidx, [4, 5]); % LU limbs
%         limbidx = cat(1, limbidx, [13, 18]); % RL limbs
%         limbidx = cat(1, limbidx, [14, 15]); % LL limbs
%     case 5
%         limbidx = [3, 9]; % RU limbs
%         limbidx = cat(1, limbidx, [4, 6]); % LU limbs
%         limbidx = cat(1, limbidx, [13, 19]); % RL limbs
%         limbidx = cat(1, limbidx, [14, 16]); % LL limbs
%     case 6
%         limbidx = [8, 9]; % RU limbs
%         limbidx = cat(1, limbidx, [5, 6]); % LU limbs
%         limbidx = cat(1, limbidx, [18, 19]); % RL limbs
%         limbidx = cat(1, limbidx, [15, 16]); % LL limbs
%     case 7
%         limbidx = [3, 8, 9]; % RU limbs
%         limbidx = cat(1, limbidx, [4, 5, 6]); % LU limbs
%         limbidx = cat(1, limbidx, [13, 18, 19]); % RL limbs
%         limbidx = cat(1, limbidx, [14, 15, 16]); % LL limbs
%     case 8
%         limbidx = [3, 8, 9, 10]; % RU limbs
%         limbidx = cat(1, limbidx, [4, 5, 6, 7]); % LU limbs
%         limbidx = cat(1, limbidx, [13, 18, 19, 20]); % RL limbs
%         limbidx = cat(1, limbidx, [14, 15, 16, 17]); % LL limbs
%     otherwise
%         fpritnf('DB.opt.limb_node_type error\n');
% end

upper_limb_node = [5, 6, 7, 8, 9, 10];
lower_limb_node = [15, 16, 17, 18, 19, 20];
% upper_limb_node = [11, 12];
% lower_limb_node = [13, 14];

% node_idx = limbidx(:)';
node_idx = [upper_limb_node, lower_limb_node];

all_x = [];
all_y = [];
all_z = [];

for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        if DB.opt.proj_method(1)
            all_x = cat(2, all_x, DB.SC.node{p, v}.x(node_idx, :));
        end
        if DB.opt.proj_method(2)
            all_y = cat(2, all_y, DB.SC.node{p, v}.y(node_idx, :));
        end
        if DB.opt.proj_method(3)
            all_z = cat(2, all_z, DB.SC.node{p, v}.z(node_idx, :));
        end
    end
end

    
DB.feature.all = cat(1, all_x, all_y, all_z)';
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

if DB.opt.print
    fprintf('Number of feature dimension : %d \n', DB.num.feature); 
end

if DB.opt.time
    DB.duration.SC_GaitPoseConjunction = datetime - DB.time.end_time;
    [h, m, s] = hms(DB.duration.SC_GaitPoseConjunction);
    fprintf('[SC_GaitPoseConjunction] processing time : %2.0fh:%2.0fm:%2.0fs \n', fix(h), fix(m), fix(s));
    DB.time.end_time = datetime;
end

end