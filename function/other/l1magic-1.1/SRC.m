function [Class, SCI] = SRC(Samples, Training, Training_class, l1Err)

if size(Samples,2)~=size(Training,2)
    error('Test and Training Samples must have the same number of dimensions')
end
if size(Training_class,1)>size(Training_class,2); Training_class=Training_class';end
if size(Training_class,2)~=size(Training,1)
    error('Number of Training labels ~= Number of Training Samples')
end
if nargin<4
    l1Err=1E-3;
end

Ntr=size(Training,1);
Nts=size(Samples,1);
cl=unique(Training_class); Ncl=length(cl);
Samples=Samples';Training=Training';

tmp=sqrt(diag(Training'*Training));
tmp=repmat(tmp',size(Training,1),1);
Training=Training./tmp;

tmp=sqrt(diag(Samples'*Samples));
tmp=repmat(tmp',size(Samples,1),1);
Samples=Samples./tmp;

SCI=zeros(1,Ncl);
xp=zeros(Ntr,Nts);
sm=zeros(Nts,Ncl);
for i=1:Nts
    x0=Training'*Samples(:,i);
    xp(:,i)=l1eq_pd(x0,Training,[],Samples(:,i),l1Err);
    for k=1:Ncl
        d=xp(find(Training_class==cl(k)),i);
        t=Training(:,find(Training_class==cl(k)));
        app=t*d;
        sm(i,k)=sqrt(sum((Samples(:,i)-app).^2));
    end
    %disp(mat2str(i))
end

[aa,Class]=min(sm,[],2);
clear aa
%Class=Training_class(ind1);

d=zeros(1,Ncl);
for i=1:Nts
    for k=1:Ncl
        d(k)=sum(abs(xp(find(Training_class==cl(k),i))));
    end
    SCI(i)=(Ncl*(max(d)/sum(abs(xp(:,i))))-1)/(Ncl-1);
end