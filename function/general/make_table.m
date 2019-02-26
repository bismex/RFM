table =    [94.68	95.94	49	16	610	1924
81.33	84.35	12766	2730	2	11
53.52	55.88	12605	2703	2	11
67.85	54.85	2274	484	13	62
56.61	70.36	1026	218	29	137
52.74	58.96	399	91	75	331
31.13	33.19	1041	208	29	144
];
% table(3, :) = [];
% table(:, 2) = [];
% table = table';
logical_text_bf = zeros(size(table));
logical_text_bf(1, :) = 1;
% for c = 1 : size(table, 2)
%     [~, idx] = max(table(:, c));
%     logical_text_bf(idx, c) = 1;
% end

for r = 1 : size(table, 1)
    for c = 1 : size(table, 2)
        if c == size(table, 2)
            if logical_text_bf(r, c) == 1
                fprintf(' \\textbf{%2.2f} \\\\', table(r, c));
            else
                fprintf(' %2.2f \\\\', table(r, c));
            end
        elseif c == 1
            if logical_text_bf(r, c) == 1
                fprintf('& \\textbf{%2.2f} &', table(r, c));
            else
                fprintf('& %2.2f &', table(r, c));
            end
        else
            if logical_text_bf(r, c) == 1
                fprintf(' \\textbf{%2.2f} &', table(r, c));
            else
                fprintf(' %2.2f &', table(r, c));
            end
        end
    end
    fprintf('\n')
end