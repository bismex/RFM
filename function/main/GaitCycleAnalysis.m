%% Gait cycle analysis

function DB = GaitCycleAnalysis(DB)


% initialization
Rff_idx = 20;
Rfb_idx = 19;
Lff_idx = 17;
Lfb_idx = 16;
DB.opt.PhaseComplete = 0;
DB.opt.GaitCycleAnalysis_bin_fit = 0.01; 
DB.opt.GaitCycleAnalysis_bin_inter = 0.01; 
bin_fit = DB.opt.GaitCycleAnalysis_bin_fit; % interpolation bin
bin_inter = DB.opt.GaitCycleAnalysis_bin_inter;

% main iteration
for p = 1 : DB.num.person
    for v = 1 : DB.num.video
        
        % dimension of polynomial fitting
        DB.SC.param.GaitCycleAnalysis_dim = [ceil(DB.T.param.node{p, v}.num/5)+8, ceil(DB.T.param.node{p, v}.num/10)+8];
        dim = [ceil(DB.T.param.node{p, v}.num/DB.SC.param.GaitCycleAnalysis_dim(1))+DB.SC.param.GaitCycleAnalysis_dim(2)];

        if DB.opt.print
            if p < 10, fprintf('[Person : 0%d / Video : %d] ', p, v);
            elseif p < 100, fprintf('[Person : %d / Video : %d] ', p, v); 
            end
        end
        
        % Step length
        dx = (DB.SC.node{p, v}.x(Lfb_idx, :) + DB.SC.node{p, v}.x(Lff_idx, :))/2 - (DB.SC.node{p, v}.x(Rff_idx, :)+DB.SC.node{p, v}.x(Rfb_idx, :))/2;
        dy = (DB.SC.node{p, v}.y(Lfb_idx, :) + DB.SC.node{p, v}.y(Lff_idx, :))/2 - (DB.SC.node{p, v}.y(Rff_idx, :)+DB.SC.node{p, v}.y(Rfb_idx, :))/2;
        dz = (DB.SC.node{p, v}.z(Lfb_idx, :) + DB.SC.node{p, v}.z(Lff_idx, :))/2 - (DB.SC.node{p, v}.z(Rff_idx, :)+DB.SC.node{p, v}.z(Rfb_idx, :))/2;
        ftn1dist = sqrt(dx.^2 + dy.^2 + dz.^2);

        % Sign (which foor is in front?)
        dx = DB.SC.node{p, v}.x(Lfb_idx, :) - DB.SC.node{p, v}.x(Rff_idx, :);
        dy = DB.SC.node{p, v}.y(Lfb_idx, :) - DB.SC.node{p, v}.y(Rff_idx, :);
        dz = DB.SC.node{p, v}.z(Lfb_idx, :) - DB.SC.node{p, v}.z(Rff_idx, :);
        dist = sqrt(dx.^2 + dy.^2 + dz.^2);
        dx = DB.SC.node{p, v}.x(Lff_idx, :) - DB.SC.node{p, v}.x(Rfb_idx, :);
        dy = DB.SC.node{p, v}.y(Lff_idx, :) - DB.SC.node{p, v}.y(Rfb_idx, :);
        dz = DB.SC.node{p, v}.z(Lff_idx, :) - DB.SC.node{p, v}.z(Rfb_idx, :);
        ftn2dist = dist - sqrt(dx.^2 + dy.^2 + dz.^2);

        % Initialization
        poly_coeff = cell(1, 3);
        y1_old_ori = cell(1, 3);
        y1_fit = cell(1, 3);
        y1_sol_zero = cell(1, 3);
        y1_sol_zero_double = cell(1, 3);
        y1_sol_zero_residual = zeros(1, 3);
        y1_sol_zero_num = zeros(1, 3);
        ws = warning('off','all');

        % (Interpolation -> polynomial fitting) 2 graphs
        if DB.opt.print
            fprintf('(%df)', 1);
        end
        x=1:numel(ftn1dist);
        y_fit=0:bin_fit:numel(ftn1dist);
        x_inter=1:bin_inter:numel(ftn1dist);
        y_inter=interp1(x,ftn1dist,x_inter,'spline'); % spline interpolation (to get dense points)
        if p==1 && v==4
            y_inter_plot = y_inter;
        end

        % Obtain the original graph and n-order derivative graphs (n=3)
        for idf = 1 : 3
            if idf == 1
                poly_coeff{idf} = polyfit(x_inter, y_inter, dim(1)); 
                y1_old_ori{idf} = ftn1dist; % original graph
            else % n-th order 
                diff_coeff = length(poly_coeff{1, idf-1})-1:-1:1;
                poly_coeff{idf} = poly_coeff{1, idf-1}(1:end-1).*diff_coeff;
                y1_old_ori{idf} = diff([y1_old_ori{1, idf-1}(1), y1_old_ori{1, idf-1}]);
            end
            y1_fit{idf}=polyval(poly_coeff{idf},y_fit); % after fitting

            % Fine solution (intersect 0 point)
            y1_sol_zero{idf} = real(roots(poly_coeff{idf}));
            y1_sol_zero{idf} = y1_sol_zero{idf}(y1_sol_zero{idf}>=y_fit(1)&y1_sol_zero{idf}<=y_fit(end));
            y1_sol_zero{idf} = sort(y1_sol_zero{idf}, 'ascend')';
            y1_sol_zero_temp = y1_sol_zero{idf};
            y1_sol_zero_double{idf} = find(diff([0, y1_sol_zero{idf}])==0);
            y1_sol_zero_double{idf} = [y1_sol_zero_double{idf}-1, y1_sol_zero_double{idf}];
            y1_sol_zero_double{idf} = sort(y1_sol_zero_double{idf}, 'ascend');
            y1_sol_zero{idf}(y1_sol_zero_double{idf}) = [];
            y1_sol_zero_double{idf} = y1_sol_zero_temp(y1_sol_zero_double{idf});
            if numel(y1_sol_zero_double{idf})/2 ~= numel(unique(y1_sol_zero_double{idf}))
                fprintf('y1_sol_zero_double_error\n');
            end
            y1_sol_zero{idf} = fix(y1_sol_zero{idf}/bin_fit)*bin_fit;
            y1_sol_zero_double{idf} = fix(y1_sol_zero_double{idf}/bin_fit)*bin_fit;
            y1_sol_zero_idx = fix(y1_sol_zero{idf}/bin_fit+1);
            y1_sol_zero_y = y1_fit{idf}(y1_sol_zero_idx);
            y1_sol_zero_residual(1, idf) = mean(abs(y1_sol_zero_y));
            y1_sol_zero_num(1, idf) = numel(y1_sol_zero{idf});
            %  fprintf('y1_sol_zero_y1_fit_residual : %3.6f\n', mean(y1_sol_zero_y));

            if DB.opt.print
                if y1_sol_zero_num(1, idf) < 10, fprintf('%dd : 0%d, ', idf, y1_sol_zero_num(1, idf));
                elseif y1_sol_zero_num(1, idf) < 100, fprintf('%dd : %d, ', idf, y1_sol_zero_num(1, idf));
                end
            end
        end

        
        warning(ws)
        if DB.opt.print
            fprintf('\n');
        end
        
        % Save values
        DB.gaitcycle{p, v}.y1_ori = y1_old_ori;
        DB.gaitcycle{p, v}.y1_fit = y1_fit;
        DB.gaitcycle{p, v}.y1_sol_zero = y1_sol_zero;
        DB.gaitcycle{p, v}.y1_sol_zero_num = y1_sol_zero_num;
        DB.gaitcycle{p, v}.y2_ori = ftn2dist;
        DB.gaitcycle{p, v}.y2_fit = smooth(ftn2dist, 0.1, 'moving')'; % smoothing version

%         DB.opt.figure = 1;
        if DB.opt.figure == 1
            fig = figure(1);
            clf
            subplot(2, 1, 1)
            set(fig, 'OuterPosition', [15, 15, 1000, 800])
            num_frame = DB.T.param.node{p, v}.num;
            bottom = -1.2; top = 1;
            sidx = 20; eidx = 80;
            line_width = 1.2;
            marker_size = 6;
            eidx = min(eidx, num_frame);
            y_left = (DB.SC.node{p, v}.x(Lfb_idx, sidx:eidx) + DB.SC.node{p, v}.x(Lff_idx, sidx:eidx))/2;
            y_right = (DB.SC.node{p, v}.x(Rff_idx, sidx:eidx) + DB.SC.node{p, v}.x(Rfb_idx, sidx:eidx))/2;
            x_lr = 1 : eidx - sidx + 1;
            hold on
            grid
            plot(x_lr, y_left, 'b-*',  'LineWidth', line_width, 'MarkerSize', marker_size, 'DisplayName','Left foot')
            plot(x_lr, y_right, 'r-o',  'LineWidth', line_width, 'MarkerSize', marker_size, 'DisplayName', 'Right foot')
%             ylabel('Coordinate value in the moving direction')
            axis([1, eidx-sidx, bottom, top])
%             legend('show');
            
%             fig = figure(2);
            subplot(2, 1, 2)
%             set(fig, 'OuterPosition', [15, 15, 1000, 400])
            bottom = 0; top = 1.6;
            line_width = 1.4;
            marker_size = 20;
            num_bin = 1/DB.opt.GaitCycleAnalysis_bin_fit;
            y_raw = y1_old_ori{1}(sidx:eidx);
            y_fit = y1_fit{1}(sidx*num_bin:eidx*num_bin);
            x_fit = linspace(1, numel(y_raw), numel(y_fit));
            hold on
            grid
            plot(x_lr, y_raw, 'k.',  'LineWidth', line_width, 'MarkerSize', marker_size, 'DisplayName','Raw data')
            plot(x_fit, y_fit, 'g-',  'LineWidth', line_width, 'MarkerSize', marker_size, 'DisplayName', 'Polynomial fitting')
%             ylabel('Step length')
            axis([1, eidx-sidx, bottom, top])
%             legend('show');
            
        end
        
    end
end

if DB.opt.time
    DB.duration.GaitCycleAnalysis = datetime - DB.time.end_time;
    [h, m, s] = hms(DB.duration.GaitCycleAnalysis);
    fprintf('[GaitCycleAnalysis] processing time : %2.0fh:%2.0fm:%2.0fs \n', fix(h), fix(m), fix(s));
    DB.time.end_time = datetime;
end



end