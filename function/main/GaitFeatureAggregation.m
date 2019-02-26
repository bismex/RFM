%% Feature aggregation
function DB = GaitFeatureAggregation(DB, flag)

switch DB.opt.GaitRecogMethod 
    case 1 % none
    case 2
        switch DB.opt.GaitFeatureAggregation
            case 1, DB = OTHER_AggregationWWTEST(DB, flag);
            case 2, DB = OTHER_AggregationMNPD(DB, flag);
        end
    case 3, DB = OTHER_AggregationHIST(DB);
    case 4
    case 5, DB = OTHER_AggregationMEDIAN(DB);
    case 6, DB = OTHER_AggregationMAXMEANSTD(DB);
    case 7
    case 8
    case 9, DB = OTHER_AggregationReliable(DB);
end


%% NaN Detection
if numel(DB.feature.all(isnan(DB.feature.all)))
    fprintf('NaN is detected\n');
    DB.feature.all(isnan(DB.feature.all)) = rand(numel(DB.feature.all(isnan(DB.feature.all))));
end    

end