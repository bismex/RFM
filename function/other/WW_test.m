function   [W,R] = WW_test(X,Y)

% Implementation of the multivariate Wald Wolfovitz test
% (Matlab functions version)
% by J. Rigas 2010

% X, Y  -->  the multivariate samples to be compared
% R     -->  disjoint subtrees that result
% W     -->  expresses the level of significance for the multivariate samples
%            X,Y to come from different distribution   

[m,Mm] = size(X); [n,Nn] = size(Y);
N = m+n;
TOTAL = [X;Y];

% d = dmatrix(TOTAL);
 d = squareform(pdist(TOTAL));
S = sparse(d);

[Tree,pred] = graphminspantree(S);      % Tree is in sparse matrix form 

[nodes1 nodes2 weights] = find(Tree);   % find edge nodes and weights
edges = [nodes2 nodes1];

for i=1:N                               % find the degree of each node in 
    di(i) = length(find(edges==i));     % the overall MST
end 

C = 0.5*[sum(di.*(di-1))];              % number of edge pairs of MST 
                                        % sharing a common node

Zi = [(edges(:,1)<=m).*(edges(:,2)>m)]; % cross-sample edges
R = sum(Zi) + 1;                        % number of disjoint subtrees                

ER = (2*m*n)/N + 1;                     % mean value and variance of R
varRC = [(2*m*n)/(N*(N-1))]*[(2*m*n-N)/N+(C-N+2)/((N-2)*(N-3))*[N*(N-1)-4*m*n+2]];
                                       
                                        
W = (R-ER)/sqrt(varRC);                 % value of W

return;

function d = dmatrix(x)
% Efficient computational trick to compute the data distance matrix
% 06/2001, N. Laskaris

% d=dmatrix(data =[N x p]),
%           data=[#vectors x dimensionality of the vector-space]
% data=[channels x time-instants]
% or data=[#trials x  time-imstants] 

[m,n]=size(x);

a=x*x';
e=ones(m,m) ;
d=diag(diag(a))*e + e*diag(diag(a))-2*a ;

return;
