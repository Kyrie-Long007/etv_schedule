function result = selection(chrom, pool_size, tour_size)
% 选择函数
% 输入：种群；子代种群数量；候选人数量
% 输出：子代种群
% 调用函数：无

[pop, variables] = size(chrom);
rank = variables - 1;
distance = variables;
for i = 1 : pool_size
    for j = 1 : tour_size
        candidate(j) = round(pop*rand(1));
        if candidate(j) == 0
            candidate(j) = 1;
        end
        if j > 1
            while ~isempty(find(candidate(1:j - 1) == candidate(j)))
                candidate(j) = round(pop*rand(1));
                if candidate(j) == 0
                    candidate(j) = 1;
                end
            end
        end
    end
    for j = 1 : tour_size
        c_obj_rank(j) = chrom(candidate(j),rank);
        c_obj_distance(j) = chrom(candidate(j),distance);
    end
    min_candidate = ...
        find(c_obj_rank == min(c_obj_rank));
    if length(min_candidate) ~= 1
        max_candidate = ...
        find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
        if length(max_candidate) ~= 1
            max_candidate = max_candidate(1);
        end
        result(i,:) = chrom(candidate(min_candidate(max_candidate)),:);
    else
        result(i,:) = chrom(candidate(min_candidate(1)),:);
    end
end