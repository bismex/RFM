clc, clear, close all

load fisheriris;
X = meas(:,1:3); % 150 points x 2 features
[n,p] = size(X);
rng(3); % For reproducibility

num_label = 5;
type1 = {'diagonal','diagonal','full','full'}; % sigma
type2 = {true,false,true,false}; % SharedCovariance
type2_text = {'true','false','true','false'};
d = 15;
x1 = linspace(min(X(:,1)) - 2,max(X(:,1)) + 2,d); % range
x2 = linspace(min(X(:,2)) - 2,max(X(:,2)) + 2,d); % range
x3 = linspace(min(X(:,3)) - 2,max(X(:,3)) + 2,d); % range
X0 = combvec(x1, x2, x3)';
% [x1grid,x2grid] = meshgrid(x1,x2);
% X0 = [x1grid(:) x2grid(:)];
% threshold = sqrt(chi2inv(0.99,2)); % Chi-square inverse cumulative distribution function
options = statset('MaxIter',1000); % Increase number of EM iterations

% figure;
for i = 1 : numel(type1)
    gmfit = fitgmdist(X,num_label,'CovarianceType',type1{i}, 'SharedCovariance',type2{i},'Options',options); % train
    clusterX = cluster(gmfit,X);
    mahalDist = mahal(gmfit,X0); % test
    [val, estimated_label] = min(mahalDist, [], 2);
end



% figure;
% plot(X(:,1),X(:,2),'.','MarkerSize',15);
% title('Fisher''s Iris Data Set');
% xlabel('Sepal length (cm)');
% ylabel('Sepal width (cm)');
% 
% subplot(2,2,i);
% hold on;
% h1 = gscatter(X(:,1),X(:,2),clusterX);
% for m = 1:k
%     idx = find(estimated_label == m);
% %         idx = mahalDist(:,m)<=threshold; % test
%     Color = h1(m).Color*0.75 + -0.5*(h1(m).Color - 1);
%     h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
%     uistack(h2,'bottom');
% end
% plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
% title(sprintf('Sigma is %s, SharedCovariance = %s',type1{i},type2_text{i}),'FontSize',8)
% legend(h1,{'1','2','3'});

%     for j = 1 : 5
%         X2 = meas(:,1:2) + randn;
%         clusterX2 = cluster(gmfit,X2);
%         h1 = gscatter(X2(:,1),X2(:,2),clusterX2);
%     end

% hold off

% cluster0 = {[ones(n-8,1); [2; 2; 2; 2]; [3; 3; 3; 3]];...
%             randsample(1:k,n,true); randsample(1:k,n,true); 'plus'};
% converged = nan(4,1);
% figure;
% for j = 1:4;
%     gmfit = fitgmdist(X,k,'CovarianceType','full',...
%         'SharedCovariance',false,'Start',cluster0{j},...
%         'Options',options);
%     clusterX = cluster(gmfit,X);
%     mahalDist = mahal(gmfit,X0);
%     subplot(2,2,j);
%     h1 = gscatter(X(:,1),X(:,2),clusterX);
%     hold on;
%     nK = numel(unique(clusterX));
%     for m = 1:nK;
%         idx = mahalDist(:,m)<=threshold;
%         Color = h1(m).Color*0.75 + -0.5*(h1(m).Color - 1);
%         h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
%         uistack(h2,'bottom');
%     end
% 	plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
%     legend(h1,{'1','2','3'});
%     hold off
%     converged(j) = gmfit.Converged;
% end
% sum(converged)