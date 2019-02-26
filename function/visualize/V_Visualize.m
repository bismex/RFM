function V_Visualize(DB)

if DB.opt.visualize
    figure(7);
    imagesc(DB.S.sim.node); colormap(gray); colorbar;
    title('Spatial Node Similarity(with)'); xlabel(['Gallery (', num2str(DB.num.frame), ' frames)']); ylabel(['Probe (', num2str(DB.num.frame), ' frames)']); 

    figure(8);
    imagesc(DB.S.sim.edge); colormap(gray); colorbar;
    title('Spatial Edge Similarity(with)'); xlabel(['Gallery (', num2str(DB.num.frame), ' frames)']); ylabel(['Probe (', num2str(DB.num.frame), ' frames)']); 

    figure(9);
    % DB.T.sim.node(find(DB.T.sim.node==1)) = 0;
    imagesc(DB.T.sim.node); colormap(gray); colorbar;
    title('Spatial Graph Similarity(with)'); xlabel(['Gallery (', num2str(DB.num.frame), ' frames)']); ylabel(['Probe (', num2str(DB.num.frame), ' frames)']); 

    figure(10);
    temp = DB.T.sim.node;
    temp(find(eye(size(temp,1))==1)) = 0;
    imagesc(temp); colormap(gray); colorbar;
    title('Spatial Graph Similarity(without)'); xlabel(['Gallery (', num2str(DB.num.frame), ' frames)']); ylabel(['Probe (', num2str(DB.num.frame), ' frames)']); 

    figure(11);
    imagesc(DB.result.discrete_solution); colormap(gray); colorbar;
    title('Spatial Graph Similarity(solution)'); xlabel(['Gallery (', num2str(DB.num.frame), ' frames)']); ylabel(['Probe (', num2str(DB.num.frame), ' frames)']); 

    x_color_idx = find(DB.result.discrete_solution==1);
    x_color = repmat(DB.T.sim.node,[1,1,3]);
    x_color(x_color_idx) = 1;
    x_color(x_color_idx+DB.num.frame*DB.num.frame) = 0;
    x_color(x_color_idx+2*DB.num.frame*DB.num.frame) = 0;
    figure(12);
    imshow(x_color)
    title('Spatial Graph Similarity(+solution)'); xlabel(['Gallery (', num2str(DB.num.frame), ' frames)']); ylabel(['Probe (', num2str(DB.num.frame), ' frames)']); 

    figure(13);
    imagesc(mean(DB.result.matchscore, 3)); colormap(gray); colorbar; axis([0.5,30.5,0.5,30.5]);
    title('Temporal Graph Similarity'); xlabel(['Gallery (', num2str(DB.num.person),' people)']); ylabel(['Probe (', num2str(DB.num.person),' people)']);

    figure(14);
    imagesc(DB.result.confusion_matrix); colormap(gray); colorbar; axis([0.5,30.5,0.5,30.5]);
    title(['Confusion Matrix(', num2str(DB.num.iter),' iters)']); xlabel(['Gallery (', num2str(DB.num.person),' people)']); ylabel(['Probe (', num2str(DB.num.person),' people)']);




    % 
    % figure; imshow(DB.T.sim.node(DB.Sdata{16, 1}.idx_f(1):DB.Sdata{16, 1}.idx_f(end), DB.Sdata{15, 2}.idx_f(1):DB.Sdata{15, 5}.idx_f(end)));
    % figure; imshow(DB.T.sim.node(DB.Sdata{16, 1}.idx_f(1):DB.Sdata{16, 1}.idx_f(end), DB.Sdata{16, 2}.idx_f(1):DB.Sdata{16, 5}.idx_f(end)));
    % figure; imshow(x_color(DB.Sdata{16, 1}.idx_f(1):DB.Sdata{16, 1}.idx_f(end), DB.Sdata{15, 2}.idx_f(1):DB.Sdata{15, 5}.idx_f(end), :));
    % figure; imshow(x_color(DB.Sdata{16, 1}.idx_f(1):DB.Sdata{16, 1}.idx_f(end), DB.Sdata{16, 2}.idx_f(1):DB.Sdata{16, 5}.idx_f(end), :));
    % 
    % figure; imshow(DB.T.sim.node(DB.Sdata{16, 1}.idx_f(1):DB.Sdata{16, 2}.idx_f(end), DB.Sdata{15, 3}.idx_f(1):DB.Sdata{15, 5}.idx_f(end)));
    % figure; imshow(DB.T.sim.node(DB.Sdata{16, 1}.idx_f(1):DB.Sdata{16, 2}.idx_f(end), DB.Sdata{16, 3}.idx_f(1):DB.Sdata{16, 5}.idx_f(end)));
    % figure; imshow(x_color(DB.Sdata{16, 1}.idx_f(1):DB.Sdata{16, 2}.idx_f(end), DB.Sdata{15, 3}.idx_f(1):DB.Sdata{15, 5}.idx_f(end), :));
    % figure; imshow(x_color(DB.Sdata{16, 1}.idx_f(1):DB.Sdata{16, 2}.idx_f(end), DB.Sdata{16, 3}.idx_f(1):DB.Sdata{16, 5}.idx_f(end), :));
end


fprintf('=======================================\n');

end