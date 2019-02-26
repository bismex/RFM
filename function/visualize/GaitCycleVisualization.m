function DB = GaitCycleVisualization(DB)

flag = 0;

if flag
    
    for p = 1 : DB.num.person
        for v = 1 : DB.num.video
            clf;
            figure(1)
            x_length = numel(DB.gaitcycle{p, v}.y1_ori{1});
            bin_inter = 0.01;
            x_inter=1:bin_inter:x_length;
            x = 1 : x_length;
            y = DB.gaitcycle{p, v}.y1_ori{1};
            y_inter=interp1(x,y,x_inter,'spline');
            
            subplot(4, 1, 1);
            hold on
            plot(x, y, '*', 'DisplayName', 'Original data')
            plot(x_inter, y_inter,'b-', 'DisplayName', 'Spline interpolation')
            top = 2;
            bottom = 0;
            axis([1, x_length, bottom, top])
            sol = DB.gaitcycle{p, v}.y1_sol_zero{2};
            for i = 1 : numel(sol)
                line([sol(i), sol(i)], [bottom, top]);
            end
            
            
            
            subplot(4, 1, 2);
            
            y = DB.gaitcycle{p, v}.y1_ori{2};
            y_inter=interp1(x,y,x_inter,'spline');
            plot(x, y, '*', 'DisplayName', 'Original data')
            plot(x_inter, y_inter,'b-', 'DisplayName', 'Spline interpolation')
            top = 0.6;
            bottom = -0.6;
            axis([1, x_length, bottom, top])
            for i = 1 : numel(sol)
                line([sol(i), sol(i)], [bottom, top]);
            end
            
            subplot(4, 1, 3);
            
            y = DB.gaitcycle{p, v}.y1_ori{3};
            y_inter=interp1(x,y,x_inter,'spline');
            plot(x, y, '*', 'DisplayName', 'Original data')
            plot(x_inter, y_inter,'b-', 'DisplayName', 'Spline interpolation')
            top = 0.6;
            bottom = -0.6;
            axis([1, x_length, bottom, top])
            for i = 1 : numel(sol)
                line([sol(i), sol(i)], [bottom, top]);
            end
            
            
            subplot(4, 1, 4);
            bar(DB.gaitcycle{p, v}.phase_vec);
            top = 4;
            bottom = 0;
            axis([1, x_length, bottom, top])
            
            
        end
    end
    
    
    
end





end

