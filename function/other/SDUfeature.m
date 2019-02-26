
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

load './db/sdugait/SDUgait_complete.mat'
all_data = SDUgait;
DB.num.person = size(all_data, 1); % number of people in DB
DB.num.video = size(all_data, 2); % number of iteration about each person in DB
DB.num.node = 21; % number of nodes

for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        num_frame = size(all_data{p, v}, 1) / DB.num.node;
        DB.node{p, v}.x = reshape(all_data{p, v}(:,1), [DB.num.node, num_frame]);
        DB.node{p, v}.y = reshape(all_data{p, v}(:,2), [DB.num.node, num_frame]);
        DB.node{p, v}.z = reshape(all_data{p, v}(:,3), [DB.num.node, num_frame]);
    end 
end

%% Index of video 
% 0 : [1, 2] R
% 90 : [11, 12] L
% 135 : [13, 14] L
% 180 : [3, 4, 15, 16] ? mean
% 225 : [5, 6] R
% 270 : [7, 8, 17, 18] R
% arbi : [9, 10, 19, 20] ? mean

idxmat_R = [17 18 9 10 21 9 21 3 ; 18 19 10 11 1 5 3 4];
idxmat_L = [13 14 5 6 21 9 21 3 ; 14 15 10 11 1 5 3 4];

all_feature = [];

for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        
        % 8 length
        if sum(v == [1, 2, 5, 6, 7, 8, 17, 18])
            flag_LR = 'R';
        elseif sum(v == [11, 12, 13, 14])
            flag_LR = 'L';
        else
            flag_LR = 'LR';
        end
        if strcmp(flag_LR, 'R')
            x1 = DB.node{p, v}.x(idxmat_R(1, :), :);
            x2 = DB.node{p, v}.x(idxmat_R(2, :), :);
            y1 = DB.node{p, v}.y(idxmat_R(1, :), :);
            y2 = DB.node{p, v}.y(idxmat_R(2, :), :);
            z1 = DB.node{p, v}.z(idxmat_R(1, :), :);
            z2 = DB.node{p, v}.z(idxmat_R(2, :), :);
            px = x2-x1;
            py = y2-y1;
            pz = z2-z1;
            dist = sqrt(px.^2+py.^2+pz.^2);
        elseif strcmp(flag_LR, 'L')
            x1 = DB.node{p, v}.x(idxmat_L(1, :), :);
            x2 = DB.node{p, v}.x(idxmat_L(2, :), :);
            y1 = DB.node{p, v}.y(idxmat_L(1, :), :);
            y2 = DB.node{p, v}.y(idxmat_L(2, :), :);
            z1 = DB.node{p, v}.z(idxmat_L(1, :), :);
            z2 = DB.node{p, v}.z(idxmat_L(2, :), :);
            px = x2-x1;
            py = y2-y1;
            pz = z2-z1;
            dist = sqrt(px.^2+py.^2+pz.^2);
        else
            
            x1 = DB.node{p, v}.x(idxmat_R(1, :), :);
            x2 = DB.node{p, v}.x(idxmat_R(2, :), :);
            y1 = DB.node{p, v}.y(idxmat_R(1, :), :);
            y2 = DB.node{p, v}.y(idxmat_R(2, :), :);
            z1 = DB.node{p, v}.z(idxmat_R(1, :), :);
            z2 = DB.node{p, v}.z(idxmat_R(2, :), :);
            px = x2-x1;
            py = y2-y1;
            pz = z2-z1;
            dist1 = sqrt(px.^2+py.^2+pz.^2);
            
            x1 = DB.node{p, v}.x(idxmat_L(1, :), :);
            x2 = DB.node{p, v}.x(idxmat_L(2, :), :);
            y1 = DB.node{p, v}.y(idxmat_L(1, :), :);
            y2 = DB.node{p, v}.y(idxmat_L(2, :), :);
            z1 = DB.node{p, v}.z(idxmat_L(1, :), :);
            z2 = DB.node{p, v}.z(idxmat_L(2, :), :);
            px = x2-x1;
            py = y2-y1;
            pz = z2-z1;
            dist2 = sqrt(px.^2+py.^2+pz.^2);
            dist = (dist1+dist2)/2;
            
        end
        
        
        z_head = DB.node{p, v}.z(4, :);
        reliable_frame = z_head > 1.8 & z_head < 3.0;
        z_head_reliable = z_head(reliable_frame);
        if numel(z_head_reliable) == 0
            [~, idx] = min(abs(z_head - (1.8+3.0)/2));
            feature = dist(:, idx);
        else
            feature = mean(dist(:, reliable_frame), 2);
        end
        DB.feature{p, v} = feature;
        all_feature = cat(2, all_feature, feature);
    end
end

confusion_matrix = pdist2(all_feature', all_feature', 'euclidean');
imagesc(confusion_matrix);


