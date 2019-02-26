function V_Direction(DB, flag)

if flag
    for p = 2 : 30
        for v = 1 : 2
            close all;
            idx_s = 1;
            idx_e = 50;
            a = (DB.SC.node{p, v}.x(19, max(1, idx_s):min(idx_e, size(DB.SC.node{p, v}.x, 2))) + DB.SC.node{p, v}.x(20, max(1, idx_s):min(idx_e, size(DB.SC.node{p, v}.x, 2))))/2;
            b = (DB.SC.node{p, v}.x(16, max(1, idx_s):min(idx_e, size(DB.SC.node{p, v}.x, 2))) + DB.SC.node{p, v}.x(17, max(1, idx_s):min(idx_e, size(DB.SC.node{p, v}.x, 2))))/2;
            figure(1)
            hold on
            plot([0:idx_e-idx_s], a, 'r-', 'Linewidth', 2)
            plot([0:idx_e-idx_s], b, 'b--', 'Linewidth', 2)
%             plot(a, 'k.', 'Linewidth', 2)
%             plot(b, 'k.', 'Linewidth', 2)
            xlabel('Frame')
            ylabel('Coordinate value in the moving direction')
            legend('Right foot', 'Left foot')
            set(gcf, 'Position', [1500, 100, 800, 300])
            grid on
            figure(2)
            set(gcf, 'Position', [1500, 700, 800, 300])
            grid on
            plot(abs(a-b))
        end
    end
end

end