function DB = OTHER_AggregationMNPD(DB, flag)

if flag == 0 % Training
    DB.feature.dissim = zeros(DB.num.video * DB.num.person, DB.num.video * DB.num.person);
    cnt1 = 1;
    for p1 = 1 : DB.num.person
        for v1 = 1 : DB.num.video
            cnt2 = 1;
            for p2 = 1 : DB.num.person
                for v2 = 1 : DB.num.video
                    if cnt2>=cnt1 % MMPD
                        feature1 = DB.feature.all(DB.feature.srt_idx(cnt1):DB.feature.end_idx(cnt1), :);
                        feature2 = DB.feature.all(DB.feature.srt_idx(cnt2):DB.feature.end_idx(cnt2), :);
                        distmat = pdist2(feature1, feature2, 'euclidean');
                        DB.feature.dissim(cnt1, cnt2) = (sum(min(distmat))+sum(min(distmat')))/(size(feature1, 1) + size(feature2, 1));
                    else
                        DB.feature.dissim(cnt1, cnt2) = DB.feature.dissim(cnt2, cnt1);
                    end
                    cnt2 = cnt2 + 1;
                end
            end
            cnt1 = cnt1 + 1;
        end
    end

elseif flag == 1 % Test(Do nothing)
    
    
end
    


end