function DB = FrameLevelWeightedVoting(DB, DB_P)

d1 = DB.Vp(:, 1)+eps;
d2 = DB.Vp(:, 2)+eps;
qual_p = DB.Vp(:, 3);

logical_on = d1 < d2;

if DB.opt.score == 1
    score = qual_p.*(d2./d1).*(1./d1).*logical_on;
    score = score./numel(score);
elseif DB.opt.score == 2
    score = (d2./d1).*(1./d1).*logical_on;
    score = score./numel(score);
else
    score = ones(size(d1));
    score = score./numel(score);
end

%% allocate each score
label_estim = DB.Rp(:,1);
score_all = zeros(1, DB.num.G_person);
for i = 1 : numel(label_estim)
    score_all(label_estim(i)) = score_all(label_estim(i)) + score(i);
%     score_all(label_estim(i)) = score_all(label_estim(i)) + 1; %majority voting
end
DB.score = score_all;


end