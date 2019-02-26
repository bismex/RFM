%% 2) Data construction
% Dataset must be included in each folder.
% Please refer to DataConstruction.m (data load)
% DataPreprocessing function is for simulation.

function [DB, DB_P, DB_G] = DataConstruction(DB, DB_P, DB_G)

[DB, DB_P, DB_G] = NodeComposition(DB, DB_P, DB_G); % Data configuration
DB_P = DataPreprocessing(DB_P); % Pre-processing (for simulation) [Probe]
DB_G = DataPreprocessing(DB_G); % Pre-processing (for simulation) [Gallery]

end