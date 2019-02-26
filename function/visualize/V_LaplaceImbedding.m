function G_LaplaceImbedding(DB)

if DB.opt.visualize

    close all
    num_video = 5;
%     idx_person = [1, 10, 15, 25];
    idx_person = [1:30];
    num_person = numel(idx_person);

    new_data_idx = [];
    for p = idx_person
        for v = 1 : num_video
            new_data_idx = cat(2, new_data_idx, DB.T.param.node{p, v}.idx);
        end
    end
    data = DB.T.sim.frame(new_data_idx, new_data_idx);

    idxmat = zeros(3, size(data, 1));
    cnt = 1;
    for p = idx_person
        for v = 1 : num_video
            [~, iidx, ~] = intersect(new_data_idx, DB.T.param.node{p, v}.idx);
            idxmat(1, iidx) = p;
            idxmat(2, iidx) = cnt;
            idxmat(3, iidx) = DB.gaitcycle{p, v}.phase_vec;
            cnt = cnt+1;
        end
    end



    N = size(data, 1);
    num_eig = 3;

    %% visualize the data
    flag_visual = 3; %1 : p, 2 : cnt, 3 : DB.gaitcycle{p, v}.phase_vec: 

    N_local = max(idxmat(flag_visual, :));
    cmap_local = jet(N_local);
    cmap = zeros(N, size(cmap_local, 2));
    for j = 1 : N
        cmap(j, :) = cmap_local(idxmat(flag_visual, j), :);
    end

    %% Changing these values will lead to different nonlinear embeddings
    % knn    = ceil(1/150*N); % each patch will only look at its knn nearest neighbors in R^d
    knn    = 30; % each patch will only look at its knn nearest neighbors in R^d
%     sigma2 = 10; % determines strength of connection in graph... see below %people ¿œ∂ß
    sigma2 = 100; % determines strength of connection in graph... see below

    %% now let's get pairwise distance info and create graph 
    m                = size(data,1);
    dt = data;
    [srtdDt,srtdIdx] = sort(dt,'ascend');
    dt               = srtdDt(1:knn+1,:);
    nidx             = srtdIdx(1:knn+1,:);

    % compute weights
    tempW  = exp(-dt.^2/sigma2); 

    % build weight matrix
    i = repmat(1:m,knn+1,1);
    W = sparse(i(:),double(nidx(:)),tempW(:),m,m); 
    W = max(W,W'); % for undirected graph.

    % The original normalized graph Laplacian, non-corrected for density
    ld = diag(sum(W,2).^(-1/2));
    DO = ld*W*ld;
    DO = max(DO,DO');%(DO + DO')/2;

    % get eigenvectors
    [v,~] = eigs(DO,num_eig,'la');

    if flag_visual==2
        eigVecIdx = nchoosek(2:num_eig,2);
        for i = 1:size(eigVecIdx,1)
            figure(i)
            scatter(v(:,eigVecIdx(i,1)),v(:,eigVecIdx(i,2)),20,cmap)
    %         legend('phase1', 'phase2', 'phase3', 'phase4');
            title('Nonlinear embedding');
            xlabel(['\phi_',num2str(eigVecIdx(i,1))]);
            ylabel(['\phi_',num2str(eigVecIdx(i,2))]);
        end
    elseif flag_visual==3
        idx1 = find(idxmat(3,:)==1);
        idx2 = find(idxmat(3,:)==2);
        idx3 = find(idxmat(3,:)==3);
        idx4 = find(idxmat(3,:)==4);
        color_map = lines;
        color1 = color_map(1, :);
        
        eigVecIdx = nchoosek(2:num_eig,2);
        for i = 1:size(eigVecIdx,1)
            figure(i)
            hold on
            plot(v(idx1,eigVecIdx(i,1)),v(idx1,eigVecIdx(i,2)), '.','Color', color_map(1, :)) 
            plot(v(idx2,eigVecIdx(i,1)),v(idx2,eigVecIdx(i,2)), '.','Color', color_map(2, :)) 
            plot(v(idx3,eigVecIdx(i,1)),v(idx3,eigVecIdx(i,2)), '.','Color', color_map(3, :))
            plot(v(idx4,eigVecIdx(i,1)),v(idx4,eigVecIdx(i,2)), '.' ,'Color', color_map(4, :))
            legend('phase1', 'phase2', 'phase3', 'phase4');
            title('Nonlinear embedding');
            xlabel(['\phi_',num2str(eigVecIdx(i,1))]);
            ylabel(['\phi_',num2str(eigVecIdx(i,2))]);
            axis square;
        end
    elseif flag_visual==1
        idxx = cell(1, num_person);
        cmap_local = hsv(num_person);
        for d = 1 : num_person
            if d == 1
                idxx{d} = find(idxmat(1,:)==idx_person(d)&idxmat(2,:)~=num_video);
                idxtrue = find(idxmat(1,:)==idx_person(d)&idxmat(2,:)==num_video);
            else
                idxx{d} = find(idxmat(1,:)==idx_person(d));
            end
        end
        eigVecIdx = nchoosek(2:num_eig,2);

        for i = 1:size(eigVecIdx,1)
            figure(i)
            hold on
            for d = 1 : num_person
                plot(v(idxx{d},eigVecIdx(i,1)),v(idxx{d},eigVecIdx(i,2)), 'square', 'DisplayName', ['Person ',num2str(idx_person(d)),' (Gallery)'])
            end
            plot(v(idxtrue,eigVecIdx(i,1)),v(idxtrue,eigVecIdx(i,2)), 'k.', 'DisplayName', ['Person ',num2str(idx_person(1)),' (Probe)'])
            legend('show');
            title('Nonlinear embedding');
            xlabel(['\phi_',num2str(eigVecIdx(i,1))]);
            ylabel(['\phi_',num2str(eigVecIdx(i,2))]);
            axis square;
        end


    end

end
end