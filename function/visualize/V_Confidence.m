function V_Confidence(DB)
if DB.opt.visualize
    a = cat(1, DB.result.conf_phase(:,:,1), zeros(1, 30), DB.result.conf_phase(:,:,2), zeros(1, 30), ...
        DB.result.conf_phase(:,:,3), zeros(1, 30), DB.result.conf_phase(:,:,4), ...
        zeros(1, 30), DB.result.conf_phase(:,:,5));
    b = cat(2, DB.result.conf_phase(:,:,1), DB.result.conf_phase(:,:,2), ...
        DB.result.conf_phase(:,:,3), DB.result.conf_phase(:,:,4), DB.result.conf_phase(:,:,5));
    c = reshape(DB.result.conf_phase, [150, 5])';
    d = reshape(sum(DB.result.conf_phase, 1), [30, 5])'/5;
    figure(3), imagesc(d), colormap(jet)
    e = DB.result.vote_frame;
    figure(4), bar(e);
end