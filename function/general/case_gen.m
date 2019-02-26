function flag_all = case_gen(start_num, case1, case2)

num1 = numel(case1);
num2 = numel(case2);
flag_all = zeros(3, num1*num2);
flag_all(1, :) = start_num : start_num + num1 * num2 - 1;
temp = repmat(case1, [num2, 1]);
flag_all(2, :) = temp(:);
flag_all(3, :) = repmat(case2, [1, num1]);

end