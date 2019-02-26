function Xd=discretisationMatching_hungarian(X,E12,varargin);
% Timothee Cour, 21-Apr-2008 17:31:23
% This software is made publicly for research use only.
% It may be modified and redistributed under the terms of the GNU General Public License.

X=-X;
X=X-min(X(:));
X(E12==0)=Inf;
[Xd,score]=hungarian(X);
