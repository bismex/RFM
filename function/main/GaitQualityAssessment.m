%% Gait quality assessment
function DB = GaitQualityAssessment(DB, flag)
if DB.opt.quality_method ~= 0
    
    if flag == 1 % probe
        quality_method = DB.opt.quality_P_method;
    else % gallery
        quality_method = DB.opt.quality_G_method;
    end
    
    DB.feature.metric = [];
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video

            %% Symmetric GQA
            num_e = 4;
            idx_all = zeros(2, num_e);
            idx_all(:, 1) = [8, 9];
            idx_all(:, 2) = [5, 6];
            idx_all(:, 3) = [18, 19];
            idx_all(:, 4) = [15, 16];
            
            dist_all = cell(1, num_e);
            for i = 1 : num_e
                 x = DB.SC.node{p, v}.x(idx_all(1, i), :) - DB.SC.node{p, v}.x(idx_all(2, i), :);
                 y = DB.SC.node{p, v}.y(idx_all(1, i), :) - DB.SC.node{p, v}.y(idx_all(2, i), :);
                 z = DB.SC.node{p, v}.z(idx_all(1, i), :) - DB.SC.node{p, v}.z(idx_all(2, i), :);
                 dist_all{i}= sqrt(x.*x+y.*y+z.*z);
            end
            
            dist_new1 = dist_all{1}./dist_all{2};
            dist_new1(dist_new1>=1) = 1./dist_new1(dist_new1>=1);
            
            dist_new2 = dist_all{3}./dist_all{4};
            dist_new2(dist_new2>=1) = 1./dist_new2(dist_new2>=1);
            
            switch quality_method % variants
                case 1, metric = sqrt(dist_new1.*dist_new2);
                case 2, metric = min(dist_new1, dist_new2);
                case 3, metric = max(dist_new1, dist_new2);
                case 4, metric = 1 - abs(dist_new1 - dist_new2);
            end
            
            DB.GQA{p, v} = metric;
            DB.feature.metric = cat(1, DB.feature.metric, metric');
        end
    end
else
    DB.feature.metric = ones(DB.num.frame, 1);
end



end