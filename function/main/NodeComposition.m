function [DB, DB_P, DB_G] = NodeComposition(DB, DB_P, DB_G) 

if DB.opt.time
    t_start = clock;
    fprintf(['Experiments start: ' num2str(t_start(4)) ':' num2str(t_start(5)) ':' num2str(round(t_start(6))) '\n']);
end

%% Load data (1: UPCV1 / 2: UPCV2 / 3: SDUgait / 4:CILgait)
% If you don't have any dataset, please refer to README file.
try
    if DB.opt.dataset_idx == 1
        load './DB/UPCV1/data.mat' % Variable name: upcv / Format: 30x5 cell / Data: Mx3 double for each cell
        all_data = upcv;
        DB.num.person = size(all_data, 1); % number of people in DB
        DB.num.video = size(all_data, 2); % number of iteration about each person in DB
        DB.num.node = 20; % number of nodes
    end
    if DB.opt.dataset_idx == 2
        load './DB/UPCV2/data.mat' % Variable name: data / Format: 30x10 cell / Data: Mx3 double for each cell
        all_data = data;
        DB.num.person = size(all_data, 1); % number of people in DB
        DB.num.video = size(all_data, 2); % number of iteration about each person in DB
        DB.num.node = 25; % number of nodes
        node_transform_idx = [4 21 9 5 6 7 8 10 11 12 2 1 17 13 14 15 16 18 19 20 3];
    end
    if DB.opt.dataset_idx == 3
        load './DB/SDUgait/data.mat' % Variable name: SDUgait / Format: 52x20 cell / Data: Mx3 double for each cell
        all_data = SDUgait;
        DB.num.person = size(all_data, 1); % number of people in DB
        DB.num.video = size(all_data, 2); % number of iteration about each person in DB
        DB.num.node = 21; % number of nodes
        node_transform_idx = [4 21 9 5 6 7 8 10 11 12 2 1 17 13 14 15 16 18 19 20 3];
    end
    if DB.opt.dataset_idx == 4
        load './DB/CILgait/data.mat' % Variable name: all_data / Format: 12x22 cell (position, orientation, state, time, frame) / Data: [position] Mx3 double for each cell
        all_frame = all_data.frame;
        if DB.opt.quat
            all_orientation = all_data.orientation;
        end
        all_data = all_data.position;
        DB.num.person = size(all_data, 1); % number of people in DB
        DB.num.video = size(all_data, 2); % number of iteration about each person in DB
        DB.num.node = 25; % number of nodes
        node_transform_idx = [4 21 9 5 6 7 8 10 11 12 2 1 17 13 14 15 16 18 19 20 3];
    end
    if DB.opt.dataset_idx == 5

        load './DB/UPCV1/data.mat'
        all_data1 = upcv;
        person1 = size(all_data1, 1); % number of people in DB
        video1 = size(all_data1, 2); % number of iteration about each person in DB
        num_node1 = 20; % number of nodes

        load './DB/UPCV2/data.mat'
        all_data2 = data;
        person2 = size(all_data2, 1); % number of people in DB
        video2 = size(all_data2, 2); % number of iteration about each person in DB
        num_node2 = 25; % number of nodes

        all_data2_tmp = [];
        for p = 1 : person2
            idx = randperm(video2, video1);
            all_data2_tmp = cat(1, all_data2_tmp, all_data2(p, idx));
        end
        all_data2 = all_data2_tmp;
        video2 = size(all_data2, 2); % number of iteration about each person in DB
        node_transform_idx = [4 21 9 5 6 7 8 10 11 12 2 1 17 13 14 15 16 18 19 20];

        for p = 1 : person2
            for v = 1 : video2
                num_iter = size(all_data2{p, v}, 1)/num_node2;
                sum_iter = ([1 : num_iter] - 1) * num_node2;
                mat_iter = sum_iter + node_transform_idx';
                vec_ter = mat_iter(:);
                all_data2{p, v} = all_data2{p, v}(vec_ter, :);
            end
        end
        all_data = [];
        all_data = cat(1, all_data1, all_data2);
        DB.num.person = size(all_data, 1); % number of people in DB
        DB.num.video = size(all_data, 2); % number of iteration about each person in DB
        DB.num.node = 20; % number of nodes
    end
catch ME
    fprintf('\n\n==============================\n');
    fprintf('|  Dataset does not exist    |\n')
    fprintf('| Please refer to README.txt |\n')
    fprintf('| Function : NodeComposition |\n')
    fprintf('==============================\n\n');
    fprintf('\n\n==============================\n');
    fprintf('|     Sample dataset is      |\n')
    fprintf('|   automatically loaded     |\n')
    fprintf('==============================\n\n');
    load './DB/sample/data.mat'
    all_data = all_data.position;
    DB.num.person = size(all_data, 1); 
    DB.num.video = size(all_data, 2); 
    DB.num.node = 25;
    node_transform_idx = [4 21 9 5 6 7 8 10 11 12 2 1 17 13 14 15 16 18 19 20 3];
    DB.opt.dataset_idx = 0;
    DB.num.probe = 1;
end

for i = 1 : size(all_data, 1)
    for j = 1 : size(all_data, 2)
        all_data{i, j}(find(all_data{i, j}==0)) = randn(1, numel(find(all_data{i, j}==0)))/1000000;
    end
end

if DB.opt.short_version
    DB.num.person = 5;
end
if DB.opt.openset_score
    num_people = size(all_data, 1);
    rand_idx = randperm(num_people);
    all_data = all_data(rand_idx, :);
end

    
%% Protocols (SDUgait, CILgait)
if DB.opt.dataset_idx == 3 % 0, 90(side), 135, 180, 225, 270(side), arbi
%     case_set = {[1,2], [11, 12], [13, 14], [3, 4, 15, 16], [5, 6], [7, 8, 17, 18], [9, 10, 19, 20]};
    switch DB.opt.dataset_subidx
        case 0 % SDU-front
            gal_idx = [3 4]; 
            probe_idx = [15 16];
        case 1 % SDU-side
            probe_idx = [8, 12, 18];
            gal_idx = [7, 11,17];
        case 2 % SDU-arb
            probe_idx = [9 10 19 20];
            gal_idx = [1:20];
            gal_idx(probe_idx) = [];
    end
    
    DB.num.gallery = numel(gal_idx);
    DB.num.probe = numel(probe_idx);
    randnumber_gallery = repmat(gal_idx, [DB.num.person, 1]);
    randnumber_probe = repmat(probe_idx, [DB.num.person, 1]);
    
elseif DB.opt.dataset_idx == 4 
    switch DB.opt.dataset_subidx
        case 0 % CIL-S
            gal_idx = [1:16];
            probe_idx = [17:18];
        case 1 % CIL-SC
            gal_idx = [1:16];
            probe_idx = [19:20];
        case 2 % CIL-SV
            gal_idx = [1:16];
            probe_idx = [21:22];
        case 3 % CIL-SC+ (w/ 16dir)
            gal_idx = [1:16, 17:18];
            probe_idx = [19:20];
        case 4 % CIL-SV+ (w/o 16dir)
            gal_idx = [1:16, 17:18];
            probe_idx = [21:22];
        case 5 % CIL-SC+ (w/ 16dir)
            gal_idx = [17:18];
            probe_idx = [19:20];
        case 6 % CIL-SCV+ (w/o 16dir)
            gal_idx = [17:18];
            probe_idx = [21:22];
    end
    
    DB.num.gallery = numel(gal_idx);
    DB.num.probe = numel(probe_idx);
    randnumber_gallery = repmat(gal_idx, [DB.num.person, 1]);
    randnumber_probe = repmat(probe_idx, [DB.num.person, 1]);
else % Random shuffling (UPCVgait datasets)
    DB.num.gallery = DB.num.video - DB.num.probe;
    randnumber_gallery = [];
    randnumber_probe = [];
    for p = 1 : DB.num.person
        randnumber = randperm(DB.num.video);
        if DB.opt.visualize
            randnumber = 1:DB.num.video; % for visualization
        end
        randnumber_probe = cat(1, randnumber_probe, randnumber(DB.num.gallery+1:end));
        randnumber_gallery = cat(1, randnumber_gallery, randnumber(1:DB.num.gallery));
    end
end

% Openset scenario
if DB.opt.openset_ratio
    DB_G.num.person = floor(DB.num.person * (1-DB.opt.openset_ratio));
else
    DB_G.num.person = DB.num.person;
end

DB_G.num.node = DB.num.node;
DB_G.num.video = DB.num.gallery;
DB_P.num.person = DB.num.person;
DB_P.num.node = DB.num.node;
DB_P.num.video = DB.num.probe;

%% Make out the nodes of skeletons.(Probe)
DB_P.SC.node = cell(DB_P.num.person, DB_P.num.video);
DB_P.SC.edge = cell(DB_P.num.person, DB_P.num.video);
DB_P.T.param.node = cell(DB_P.num.person, DB_P.num.video);
DB_P.T.param.edge = cell(DB_P.num.person, DB_P.num.video);
if DB_P.opt.quat
    DB_P.SC.quat = cell(DB_P.num.person, DB_P.num.video);
end
DB_P.num.frame = 0;
for p = 1 : DB_P.num.person
    for v = 1 : DB_P.num.video
        DB_P.T.param.node{p, v}.num_noise = 0;
        DB_P.T.param.node{p, v}.num = size(all_data{p, randnumber_probe(p, v)}, 1) / DB_P.num.node;
        DB_P.num.frame = DB_P.num.frame + DB_P.T.param.node{p, v}.num;
        
        DB_P.SC.node{p, v}.x = reshape(all_data{p, randnumber_probe(p, v)}(:,1), [DB_P.num.node, DB_P.T.param.node{p, v}.num]);
        DB_P.SC.node{p, v}.y = reshape(all_data{p, randnumber_probe(p, v)}(:,2), [DB_P.num.node, DB_P.T.param.node{p, v}.num]);
        DB_P.SC.node{p, v}.z = reshape(all_data{p, randnumber_probe(p, v)}(:,3), [DB_P.num.node, DB_P.T.param.node{p, v}.num]);
        
        if DB_P.opt.quat % If quaternion flag
            DB_P.SC.quat{p, v}.x = reshape(all_orientation{p, randnumber_probe(p, v)}(:,1), [DB_P.num.node, DB_P.T.param.node{p, v}.num]);
            DB_P.SC.quat{p, v}.y = reshape(all_orientation{p, randnumber_probe(p, v)}(:,2), [DB_P.num.node, DB_P.T.param.node{p, v}.num]);
            DB_P.SC.quat{p, v}.z = reshape(all_orientation{p, randnumber_probe(p, v)}(:,3), [DB_P.num.node, DB_P.T.param.node{p, v}.num]);
            DB_P.SC.quat{p, v}.w = reshape(all_orientation{p, randnumber_probe(p, v)}(:,4), [DB_P.num.node, DB_P.T.param.node{p, v}.num]);
        end
    end 
end

%% Make out the nodes of skeletons.(Gallery)
DB_G.SC.node = cell(DB_G.num.person, DB_G.num.video);
DB_G.SC.edge = cell(DB_G.num.person, DB_G.num.video);
DB_G.T.param.node = cell(DB_G.num.person, DB_G.num.video);
DB_G.T.param.edge = cell(DB_G.num.person, DB_G.num.video);
if DB_G.opt.quat
    DB_G.SC.quat = cell(DB_G.num.person, DB_G.num.video);
end
DB_G.num.frame = 0;
for p = 1 : DB_G.num.person
    for v = 1 : DB_G.num.video
        DB_G.T.param.node{p, v}.num_noise = 0;
        DB_G.T.param.node{p, v}.num = size(all_data{p, randnumber_gallery(p, v)}, 1) / DB_G.num.node;
        DB_G.num.frame = DB_G.num.frame + DB_G.T.param.node{p, v}.num;
        
        DB_G.SC.node{p, v}.x = reshape(all_data{p, randnumber_gallery(p, v)}(:,1), [DB_G.num.node, DB_G.T.param.node{p, v}.num]);
        DB_G.SC.node{p, v}.y = reshape(all_data{p, randnumber_gallery(p, v)}(:,2), [DB_G.num.node, DB_G.T.param.node{p, v}.num]);
        DB_G.SC.node{p, v}.z = reshape(all_data{p, randnumber_gallery(p, v)}(:,3), [DB_G.num.node, DB_G.T.param.node{p, v}.num]);
        
        if DB_G.opt.quat % If quaternion flag
            DB_G.SC.quat{p, v}.x = reshape(all_orientation{p, randnumber_gallery(p, v)}(:,1), [DB_G.num.node, DB_G.T.param.node{p, v}.num]);
            DB_G.SC.quat{p, v}.y = reshape(all_orientation{p, randnumber_gallery(p, v)}(:,2), [DB_G.num.node, DB_G.T.param.node{p, v}.num]);
            DB_G.SC.quat{p, v}.z = reshape(all_orientation{p, randnumber_gallery(p, v)}(:,3), [DB_G.num.node, DB_G.T.param.node{p, v}.num]);
            DB_G.SC.quat{p, v}.w = reshape(all_orientation{p, randnumber_gallery(p, v)}(:,4), [DB_G.num.node, DB_G.T.param.node{p, v}.num]);
        end
    end 
end

%% Switch the nodes when kinect v2.
if DB.num.node ~= 20
    for p = 1 : DB_P.num.person
        for v = 1 : DB_P.num.video
            DB_P.SC.node{p, v}.x = DB_P.SC.node{p, v}.x(node_transform_idx, :);
            DB_P.SC.node{p, v}.y = DB_P.SC.node{p, v}.y(node_transform_idx, :);
            DB_P.SC.node{p, v}.z = DB_P.SC.node{p, v}.z(node_transform_idx, :);
        end
    end
    DB_P.num.node = 21;
    for p = 1 : DB_G.num.person
        for v = 1 : DB_G.num.video
            DB_G.SC.node{p, v}.x = DB_G.SC.node{p, v}.x(node_transform_idx, :);
            DB_G.SC.node{p, v}.y = DB_G.SC.node{p, v}.y(node_transform_idx, :);
            DB_G.SC.node{p, v}.z = DB_G.SC.node{p, v}.z(node_transform_idx, :);
            DB_G.SC.node{p, v}.x(find(DB_G.SC.node{p, v}.x==0)) = randn(1, numel(find(DB_G.SC.node{p, v}.x==0)))/10000000000;
            DB_G.SC.node{p, v}.y(find(DB_G.SC.node{p, v}.y==0)) = randn(1, numel(find(DB_G.SC.node{p, v}.y==0)))/10000000000;
            DB_G.SC.node{p, v}.z(find(DB_G.SC.node{p, v}.z==0)) = randn(1, numel(find(DB_G.SC.node{p, v}.z==0)))/10000000000;
        end
    end
    DB_G.num.node = 21;
end


if DB.opt.time
    DB.duration.NodeComposition = datetime - DB.time.end_time;
    [h, m, s] = hms(DB.duration.NodeComposition);
    fprintf('[NodeComposition] processing time : %2.0fh:%2.0fm:%2.0fs \n', fix(h), fix(m), fix(s));
    DB.time.end_time = datetime;
end

end

%% Skeletal indices (KinectV1)
% 1 head
% 2 shoulder center
% 3 shoulder right
% 4 shoulder left
% 5 elbow left
% 6 wrist left
% 7 hand left
% 8 elbow right
% 9 wrist right
% 10 hand right
% 11 spine
% 12 hip center
% 13 hip right
% 14 hip left
% 15 knee left
% 16 ankle left
% 17 foot left
% 18 knee right
% 19 ankle right
% 20 foot right

%% Skeletal indices (KinectV2)
% 1 spine base
% 2 spine mid
% 3 neck
% 4 head
% 5 shoulder left
% 6 elbow left
% 7 wrist left
% 8 hand left
% 9 shoulder right
% 10 elbow right
% 11 wrist right
% 12 hand right
% 13 hip left
% 14 knee left
% 15 ankle left
% 16 foot left
% 17 hip right
% 18 knee right
% 19 ankle right
% 20 foot right
% 21 spine shoulder
% 22 handtip left
% 23 thumb left
% 24 handtip right
% 25 thumb right