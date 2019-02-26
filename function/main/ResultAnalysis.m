%% 5) Results analysis
% This process analyzes all of the results.

function DB_R = ResultAnalysis(DB_R, DB_P, DB_G)

%% Initialization
if DB_R.iter == 1
    DB_R.accum = 100;
    DB_R.gap = 0.035;
    DB_R.present_accuracy1 = zeros(1, DB_R.iterMAX);
    DB_R.total_accuracy1 = zeros(1, DB_R.iterMAX);
    DB_R.present_accuracy2 = zeros(1, DB_R.iterMAX);
    DB_R.total_accuracy2 = zeros(1, DB_R.iterMAX);
    DB_R.present_accuracy3 = zeros(1, DB_R.iterMAX);
    DB_R.total_accuracy3 = zeros(1, DB_R.iterMAX);
    DB_R.present_accuracy4 = zeros(1, DB_R.iterMAX);
    DB_R.total_accuracy4 = zeros(1, DB_R.iterMAX);
    DB_R.present_accuracy5 = zeros(1, DB_R.iterMAX);
    DB_R.total_accuracy5 = zeros(1, DB_R.iterMAX);
    DB_R.accum_accuracy = zeros(1, DB_R.iterMAX);
    DB_R.mean_accuracy = zeros(1, DB_R.iterMAX);
    DB_R.pre_time = zeros(1, DB_R.iterMAX);
    DB_R.ext_time = zeros(1, DB_R.iterMAX);
    DB_R.agg_time = zeros(1, DB_R.iterMAX);
    DB_R.tra_time = zeros(1, DB_R.iterMAX);
    DB_R.REG_time = zeros(1, DB_R.iterMAX);
    DB_R.REC_time = zeros(1, DB_R.iterMAX);
    DB_R.p_videos = zeros(1, DB_R.iterMAX);
    DB_R.g_videos = zeros(1, DB_R.iterMAX);
    DB_R.p_frames = zeros(1, DB_R.iterMAX);
    DB_R.g_frames = zeros(1, DB_R.iterMAX);
    DB_R.opt = DB_P.opt;
end


%% Accuracy
% DB_R.present_accuracy1(DB_R.iter) = 100*mean(DB_R.rank(:, DB_R.iter) == 1); % rank = 1

if DB_R.opt.openset_ratio > 0
    
    estimate_idx = zeros(size(DB_R.identification_all(:, :, DB_R.iter), 1), 1);
    num_seen = size(DB_R.identification_all(:, :, DB_R.iter), 2);
    GT_idx = repmat(1:num_seen, [DB_R.num.P_video, 1]);
    GT_idx = GT_idx(:);
    GT_idx = cat(1, GT_idx, (num_seen+1)*ones(DB_R.num.P_video * (DB_R.num.P_person - DB_R.num.G_person), 1));
    estimate_mat = DB_R.identification_all(:, :, DB_R.iter) == 1;
    for i = 1 : size(DB_R.identification_all(:, :, DB_R.iter), 1)
        estimate_idx(i) = find(estimate_mat(i, :));
    end
    estimate_idx(DB_R.score_all(:, DB_R.iter) < DB_R.opt.openset_score) = num_seen+1;
    
    seen_accuracy = mean(estimate_idx(1:num_seen*DB_R.num.P_video) == GT_idx(1:num_seen*DB_R.num.P_video));
    unseen_accuracy = mean(estimate_idx(num_seen*DB_R.num.P_video+1:end) == GT_idx(num_seen*DB_R.num.P_video+1:end));
    all_accuracy = mean(estimate_idx == GT_idx);
    
    confusion_mat = zeros(num_seen+1, num_seen+1);
    
    for r = 1 : num_seen+1
        for c = 1 : num_seen+1
            confusion_mat(r, c) = sum((estimate_idx == r) .* (GT_idx == c));
        end
    end
    
    all_metric = zeros(num_seen+1, 4); % TP, FP, FN, TN
    for i = 1 : num_seen+1
        all_metric(i, 1) = confusion_mat(i, i); % TP
        all_metric(i, 2) = sum(confusion_mat(i, :)) - confusion_mat(i, i); % FP
        all_metric(i, 3) = sum(confusion_mat(:, i)) - confusion_mat(i, i); % FN
        all_metric(i, 4) = sum(confusion_mat(:)) - sum(all_metric(i, 1:3)); % TN
    end
    
    all_metric2 = zeros(num_seen+1, 4); % Recall, precision, F-score, accuracy
    all_metric2(:, 1) = all_metric(:, 1) ./ (all_metric(:, 1) + all_metric(:, 3)+eps); % Recall
    all_metric2(:, 2) = all_metric(:, 1) ./ (all_metric(:, 1) + all_metric(:, 2)+eps); % Precision
    all_metric2(:, 3) = 2 * (all_metric2(:, 1).*all_metric2(:, 2))./(all_metric2(:, 1)+all_metric2(:, 2)+eps);
    all_metric2(:, 4) = (all_metric(:, 1) + all_metric(:, 4))./(sum(all_metric, 2)+eps);
    all_metric2(all_metric(:, 1) == 0, 1:3) = 0;
    
    seen_macro_recall = mean(all_metric2(1:end-1, 1));
    seen_micro_recall = sum(all_metric(1:end-1, 1))/(sum(all_metric(1:end-1, 1)) + sum(all_metric(1:end-1, 3))+eps);
    unseen_recall = all_metric2(end, 1);
    macro_recall = mean(all_metric2(:, 1));
    micro_recall = sum(all_metric(:, 1))/(sum(all_metric(:, 1)) + sum(all_metric(:, 3))+eps);
    
    seen_macro_precision = mean(all_metric2(1:end-1, 2));
    seen_micro_precision = sum(all_metric(1:end-1, 1))/(sum(all_metric(1:end-1, 1)) + sum(all_metric(1:end-1, 2))+eps);
    unseen_precision = all_metric2(end, 2);
    macro_precision = mean(all_metric2(:, 2));
    micro_precision = sum(all_metric(:, 1))/(sum(all_metric(:, 1)) + sum(all_metric(:, 2))+eps);
    
    seen_macro_fscore = 2 * seen_macro_recall * seen_macro_precision / ( seen_macro_recall + seen_macro_precision +eps);
    seen_micro_fscore = 2 * seen_micro_recall * seen_micro_precision / ( seen_micro_recall + seen_micro_precision +eps);
    unseen_fscore = 2 * unseen_recall * unseen_precision / ( unseen_recall + unseen_precision +eps);
    macro_fscore = 2 * macro_recall * macro_precision / ( macro_recall + macro_precision +eps);
    micro_fscore = 2 * micro_recall * micro_precision / ( micro_recall + micro_precision +eps);
    
    if DB_R.opt.openset_result == 1
        probability1 = seen_macro_precision;
        probability2 = seen_micro_precision;
        probability3 = unseen_precision;
        probability4 = macro_precision;
        probability5 = micro_precision;
    elseif DB_R.opt.openset_result == 2
        probability1 = seen_macro_recall;
        probability2 = seen_micro_recall;
        probability3 = unseen_recall;
        probability4 = macro_recall;
        probability5 = micro_recall;
    elseif DB_R.opt.openset_result == 3
        probability1 = seen_macro_precision;
        probability2 = seen_macro_recall;
        probability3 = seen_micro_precision;
        probability4 = seen_micro_recall;
        probability5 = 0;
    end
else
    probability1 = mean(DB_R.rank(:, DB_R.iter) <= 1);
    probability2 = mean(DB_R.rank(:, DB_R.iter) <= 2);
    probability3 = mean(DB_R.rank(:, DB_R.iter) <= 3);
    probability4 = mean(DB_R.rank(:, DB_R.iter) <= 4);
    probability5 = mean(DB_R.rank(:, DB_R.iter) <= 5);
end
DB_R.present_accuracy1(DB_R.iter) = 100*probability1;
DB_R.present_accuracy2(DB_R.iter) = 100*probability2;
DB_R.present_accuracy3(DB_R.iter) = 100*probability3;
DB_R.present_accuracy4(DB_R.iter) = 100*probability4;
DB_R.present_accuracy5(DB_R.iter) = 100*probability5;
DB_R.total_accuracy1(DB_R.iter) = mean(DB_R.present_accuracy1(1 : DB_R.iter));
DB_R.total_accuracy2(DB_R.iter) = mean(DB_R.present_accuracy2(1 : DB_R.iter));
DB_R.total_accuracy3(DB_R.iter) = mean(DB_R.present_accuracy3(1 : DB_R.iter));
DB_R.total_accuracy4(DB_R.iter) = mean(DB_R.present_accuracy4(1 : DB_R.iter));
DB_R.total_accuracy5(DB_R.iter) = mean(DB_R.present_accuracy5(1 : DB_R.iter));

if DB_P.opt.realtime
    DB_R.total_mean_accuracy(DB_R.iter) = mean(mean(DB_R.rank1ratio(:, 1:DB_R.iter)))*100;
    fprintf('[%dth test set] Rank-1 Accuracy : %3.2f%% (Total mean accuracy : %3.2f%% / Total accuracy : %3.2f%%)', ...
        DB_R.iter, DB_R.present_accuracy1(DB_R.iter), DB_R.total_mean_accuracy(DB_R.iter), DB_R.total_accuracy1(DB_R.iter));
else
    
    fprintf('[%dth test set] Rank-1 Accuracy : %3.2f%% (Total accuracy : %3.2f%%)', ...
        DB_R.iter, DB_R.present_accuracy1(DB_R.iter), DB_R.total_accuracy1(DB_R.iter));
    
end

%% Processing time
DB_R.REG_time(DB_R.iter) = DB_G.time.reg;
DB_R.REC_time(DB_R.iter) = DB_R.time.rec;
DB_R.g_videos(DB_R.iter) = DB_G.num.video * DB_G.num.person;
DB_R.p_videos(DB_R.iter) = DB_P.num.video * DB_P.num.person;
DB_R.g_frames(DB_R.iter) = DB_G.num.frame;
DB_R.p_frames(DB_R.iter) = DB_P.num.frame;
fprintf(' (Time : %3.2fs / %3.2fs)', round(mean(DB_R.REG_time(1:DB_R.iter)), 2), round(mean(DB_R.REC_time(1:DB_R.iter)), 2));
fprintf(' (vps : %3.2f / %3.2f)', round(mean(DB_R.g_videos(1:DB_R.iter)./DB_R.REG_time(1:DB_R.iter)), 2), ...
    round(mean(DB_R.p_videos(1:DB_R.iter)./DB_R.REC_time(1:DB_R.iter)), 2));
fprintf(' (fps : %3.2f / %3.2f)\n', round(mean(DB_R.g_frames(1:DB_R.iter)./DB_R.REG_time(1:DB_R.iter)), 2), ...
    round(mean(DB_R.p_frames(1:DB_R.iter)./DB_R.REC_time(1:DB_R.iter)), 2));

%% Condition of converge (not used....)
if mean(abs(DB_R.total_accuracy1(max(1,DB_R.iter-DB_R.accum+1):DB_R.iter) - DB_R.total_accuracy1(DB_R.iter)) < DB_R.gap) == 1 ...
        && DB_R.iter > 2 * DB_R.accum
    DB_R.opt.probe = DB_P.opt;
    DB_R.opt.gallery = DB_G.opt;
    DB_R.num.probe = DB_P.num;
    DB_R.num.gallery = DB_G.num;
    DB_R.final_accuracy1 = DB_R.total_accuracy1(DB_R.iter);
    DB_R.final_accuracy2 = DB_R.total_accuracy2(DB_R.iter);
    DB_R.final_accuracy3 = DB_R.total_accuracy3(DB_R.iter);
    DB_R.final_accuracy4 = DB_R.total_accuracy4(DB_R.iter);
    DB_R.final_accuracy5 = DB_R.total_accuracy5(DB_R.iter);
    
    if DB_P.opt.realtime
        DB_R.final_mean_accuracy = DB_R.total_mean_accuracy(DB_R.iter);
    end
	DB_R.final_REG_time = round(mean(DB_R.REG_time(1:DB_R.iter)), 2);
    DB_R.final_REC_time = round(mean(DB_R.REC_time(1:DB_R.iter)), 2);
	DB_R.final_g_vps = round(mean(DB_R.g_videos(1:DB_R.iter)./DB_R.REG_time(1:DB_R.iter)), 2);
    DB_R.final_p_vps = round(mean(DB_R.p_videos(1:DB_R.iter)./DB_R.REC_time(1:DB_R.iter)), 2);
	DB_R.final_g_fps = round(mean(DB_R.g_frames(1:DB_R.iter)./DB_R.REG_time(1:DB_R.iter)), 2);
    DB_R.final_p_fps = round(mean(DB_R.p_frames(1:DB_R.iter)./DB_R.REC_time(1:DB_R.iter)), 2);
    fprintf('[OVERALL] Rank-1 Accuracy : %3.2f%%\n', DB_R.final_accuracy1);
    DB_R.iterEXIT = DB_R.iter;
    DB_R.iter = DB_R.iterMAX;
elseif DB_R.iter == DB_R.iterMAX
    DB_R.opt.probe = DB_P.opt;
    DB_R.opt.gallery = DB_G.opt;
    DB_R.num.probe = DB_P.num;
    DB_R.num.gallery = DB_G.num;
    DB_R.final_accuracy1 = DB_R.total_accuracy1(DB_R.iter);
    DB_R.final_accuracy2 = DB_R.total_accuracy2(DB_R.iter);
    DB_R.final_accuracy3 = DB_R.total_accuracy3(DB_R.iter);
    DB_R.final_accuracy4 = DB_R.total_accuracy4(DB_R.iter);
    DB_R.final_accuracy5 = DB_R.total_accuracy5(DB_R.iter);
    
    if DB_P.opt.realtime
        DB_R.final_mean_accuracy = DB_R.total_mean_accuracy(DB_R.iter);
    end
	DB_R.final_REG_time = round(mean(DB_R.REG_time(1:DB_R.iter)), 2);
    DB_R.final_REC_time = round(mean(DB_R.REC_time(1:DB_R.iter)), 2);
	DB_R.final_g_vps = round(mean(DB_R.g_videos(1:DB_R.iter)./DB_R.REG_time(1:DB_R.iter)), 2);
    DB_R.final_p_vps = round(mean(DB_R.p_videos(1:DB_R.iter)./DB_R.REC_time(1:DB_R.iter)), 2);
	DB_R.final_g_fps = round(mean(DB_R.g_frames(1:DB_R.iter)./DB_R.REG_time(1:DB_R.iter)), 2);
    DB_R.final_p_fps = round(mean(DB_R.p_frames(1:DB_R.iter)./DB_R.REC_time(1:DB_R.iter)), 2);
    fprintf('[OVERALL] Rank-1 Accuracy : %3.2f%%\n', DB_R.final_accuracy1);
end

DB_R.iter = DB_R.iter + 1;


end