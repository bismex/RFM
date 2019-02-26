function DB_R = OTHER_MAJORITY_VOTING(DB_R, DB_G)

idxrank = zeros(size(DB_R.test_vector));
cand_num = 30;
for i = 1 : size(DB_R.test_vector, 1)
    [~, idx] = sort(DB_R.test_vector(i, :), 'ascend');
    [~, idx] = sort(idx, 'ascend');
    idx(idx > cand_num) = cand_num + 1;
    idxrank(i, :) = idx;
end
if size(idxrank, 1) > 1
    idxrank = sum(idxrank, 1);
end
label =  ceil((1:DB_G.num.person*DB_G.num.video)/(DB_G.num.video));

[minval, minidx] = min(idxrank);
if sum(minval == idxrank)>1
    minidx = find(minval == idxrank);
    compairmat = DB_R.test_vector(:, minidx);
    if size(compairmat, 1) > 1
        compairmat = sum(compairmat, 1);
    end
    [~, idx] = min(compairmat);
    minidx = minidx(idx);
end
DB_R.score(label(minidx)) = 1;

end