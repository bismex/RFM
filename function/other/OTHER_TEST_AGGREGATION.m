function DB_R = OTHER_TEST_AGGREGATION(DB_R, DB_P, DB_G)


switch DB_P.opt.GaitFeatureAggregation
    case 1 % WWTEST
        DB_R.test_vector = zeros(1, DB_G.num.person * DB_G.num.video);
        cnt = 1;
        for p2 = 1 : DB_G.num.person
            for v2 = 1 : DB_G.num.video
                feature1 = DB_G.feature.all(DB_G.feature.srt_idx(cnt):DB_G.feature.end_idx(cnt), :);
                feature2 = DB_P.feature.all;
                DB_R.test_vector(cnt) = WW_test(feature1, feature2);
                cnt = cnt + 1;
            end
        end
        DB_R.test_vector(DB_R.test_vector>0) = 0;
        DB_R.test_vector = abs(DB_R.test_vector);
    case 2 % MNPD
        DB_R.test_vector = zeros(1, DB_G.num.person * DB_G.num.video);
        cnt = 1;
        for p2 = 1 : DB_G.num.person
            for v2 = 1 : DB_G.num.video
                feature1 = DB_G.feature.all(DB_G.feature.srt_idx(cnt):DB_G.feature.end_idx(cnt), :);
                feature2 = DB_P.feature.all;
                distmat = pdist2(feature1, feature2, 'euclidean');
                DB_R.test_vector(cnt) = (sum(min(distmat))+sum(min(distmat')))/(size(feature1, 1) + size(feature2, 1));
                cnt = cnt + 1;
            end
        end
    case 3 % DTW kernel
        if DB_G.opt.GaitFeatureTest == 4
            dividx = DB_G.feature.division;
            srt_dim(1) = 1;
            srt_dim(2) = DB_G.feature.division(1)+1;
            end_dim(1) = DB_G.feature.division(1);
            end_dim(2) = sum(dividx);
        else
            srt_dim = 1;
            end_dim = size(DB_G.feature.all, 2);
            dividx = size(DB_G.feature.all, 2);
        end
        DB_R.test_vector = zeros(numel(dividx), DB_G.num.person * DB_G.num.video);
        cnt = 1;
        minlength = 3;
        samplelength = 36;
        phase2 = DB_P.feature.phase';
        idx2 = [];
        for i = 1 : numel(phase2) - minlength + 1
            idx = (phase2 == 1);
            if minlength == sum(idx(i:i + minlength - 1))
                idx2 = cat(2, idx2, i);
            end
        end
        if numel(idx2) == 0
            start2 = ceil(numel(phase2)/2);
        else
            start2 = idx2(find(diff([idx2(1), idx2]) ~= 1));
        end
        if numel(start2) == 1
            if (start2 + samplelength) <= numel(phase2)
                idx2 = [start2, start2 + samplelength];
            elseif (start2 - samplelength) >= 1
                idx2 = [start2-samplelength, start2];
            elseif numel(phase2) > samplelength
                idx2 = [ceil(numel(phase2)/2)-samplelength/2, ceil(numel(phase2)/2)+samplelength/2];
            else
                idx2 = [1, numel(phase2)];
            end
        elseif numel(start2) > 1
            gap2 = zeros(1, numel(start2) - 1);
            for i = 1 : numel(start2) - 1
                gap2(i) = start2(i+1) - start2(i);
            end
            [~, ii] = max(gap2);
            idx2 = [start2(ii), start2(ii+1)];
        elseif numel(start2) < 1
            fprintf('one cycle error\n');
        end
        feature2 = DB_P.feature.all(idx2(1):idx2(2), :);
        
        for p2 = 1 : DB_G.num.person
            for v2 = 1 : DB_G.num.video
                phase1 = DB_G.feature.phase(DB_G.feature.srt_idx(cnt):DB_G.feature.end_idx(cnt))';
                idx1 = [];
                for i = 1 : numel(phase1) - minlength + 1
                    idx = (phase1 == 1);
                    if minlength == sum(idx(i:i + minlength - 1))
                        idx1 = cat(2, idx1, i);
                    end
                end
                if numel(idx1) == 0
                    start1 = ceil(numel(phase1)/2);
                else
                    start1 = idx1(find(diff([idx1(1), idx1]) ~= 1));
                end
                if numel(start1) == 1
                    if (start1 + samplelength) <= numel(phase1)
                        idx1 = [start1, start1 + samplelength];
                    elseif (start1 - samplelength) >= 1
                        idx1 = [start1-samplelength, start1];
                    elseif numel(phase1) > samplelength
                        idx1 = [ceil(numel(phase1)/2)-samplelength/2, ceil(numel(phase1)/2)+samplelength/2];
                    else
                        idx1 = [1, numel(phase1)];
                    end
                elseif numel(start1) > 1
                    gap1 = zeros(1, numel(start1) - 1);
                    for i = 1 : numel(start1) - 1
                        gap1(i) = start1(i+1) - start1(i);
                    end
                    [~, ii] = max(gap1);
                    idx1 = [start1(ii), start1(ii+1)];
                elseif numel(start1) < 1
                    fprintf('one cycle error\n');
                end
                feature1 = DB_G.feature.all(DB_G.feature.srt_idx(cnt):DB_G.feature.end_idx(cnt), :);
                feature1 = feature1(idx1(1):idx1(2), :);
                
                for div = 1 : numel(dividx)
                    dimidx = srt_dim(div) : end_dim(div);
                    for d = 1 : dividx(div)
                        feat1 = feature1(:, dimidx(d));
                        feat2 = feature2(:, dimidx(d));
                        DB_R.test_vector(div, cnt) = DB_R.test_vector(div, cnt) + ...
                            dtw(feat1, feat2)/max(numel(feat1),numel(feat2)); % 작을수록 좋은 것
                    end
                end
                cnt = cnt + 1;
            end
        end
end

end