function result = reinsert(chrom, M, V, NIND)
% 将变异得到的子代种群重插入之前保留的父代种群生成子代种群
% 输入：选择操作后按适应度值从高到低排序的父代种群，变异后的子代种群，代沟
% 输出：下一代循环的初试父代种群
% 调用函数：无

[N, ~] = size(chrom);
[~,index] = sort(chrom(:,M + V + 1));

for i = 1 : N
    sorted_chromosome(i,:) = chrom(index(i),:);
end
 
max_rank = max(chrom(:,M + V + 1));
 
previous_index = 0;
for i = 1 : max_rank
    current_index = max(find(sorted_chromosome(:,M + V + 1) == i));
    if current_index > NIND
        remaining = NIND - previous_index;
        temp_pop = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
        [temp_sort,temp_sort_index] = ...
            sort(temp_pop(:, M + V + 2),'descend');
        for j = 1 : remaining
            result(previous_index + j,:) = temp_pop(temp_sort_index(j),:);
        end
    elseif current_index < NIND
        result(previous_index + 1 : current_index, :) = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
    else
        result(previous_index + 1 : current_index, :) = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
    end
    previous_index = current_index;
end