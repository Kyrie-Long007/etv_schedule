function chrom = initPop(NIND, N, NUM)
% 初始化生成种群
% 输入：种群规模；染色体的长度（任务的数量）
% 输出：初代种群
% 调用函数：无

chrom = zeros(NIND, N);
for i = 1:NIND
    % 第一层染色体编码(初始化任务顺序)
    chrom(i, 1:N/2) = randperm(N/2);
    % 第二层染色体编码(给每一个任务随机分配小车)
    for j = (N/2+1):N
        vehicle_allocated = unidrnd(NUM);
        chrom(i, j) = vehicle_allocated;
    end
end