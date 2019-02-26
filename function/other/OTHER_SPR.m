function DB = OTHER_SPR(DB, iter)

D = DB.T.sim.video;
% num_iter = DB.num.iter;
 
Ntest=DB.num.probe;
gap = DB.num.probe;
% for iter=1:num_iter %iterrations (with random initialization)

Indtrain=1:DB.num.person*DB.num.video;
Indtest=[];
for i=1:DB.num.person
    tmp=randsample(DB.num.video,Ntest);
    Indtest=[Indtest ((i-1)*DB.num.video+tmp)'];
end
Indtrain(Indtest)=[];
[U,S,V]=svds(D(Indtrain,Indtrain),76);
DR=D(:,Indtrain)*V;
[Class, SCI] = SRC(DR(Indtest,:), DR(Indtrain,:), ceil((1:length(Indtrain))/(DB.num.video-Ntest)), 1E-3);

label = (Class'==ceil((1:length(Indtest))/Ntest))';
%     for i = 1 : gap
%         DB.result.accuracy_rank1 = DB.result.accuracy_rank1 + label(i:gap:end);
%     end

for i = 1 : gap
    for j = 1 : DB.num.person
        if label(gap*(j-1)+i)
            DB.result.matchrank(j,j,i, iter) = 1; % diagonal elements : rank
        else
            DB.result.matchrank(j,j,i, iter) = DB.num.person; % diagonal elements : rank
        end
    end
end
    
% end

end