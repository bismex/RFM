function DB = OTHER_TRAIN_GSVM(DB)

DB.feature.model = cell(1, DB.num.person);
for p = 1 : DB.num.person
    new_label = zeros(size(DB.feature.label));
    new_label(DB.feature.label==p) = 1;
    new_label(DB.feature.label~=p) = -1;
    model = fitcsvm(DB.feature.all,new_label,'KernelFunction','rbf',...
        'BoxConstraint',Inf,'ClassNames',[-1, 1]);
    DB.feature.model{p} = model;
end

end