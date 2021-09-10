function children = mutation(children, PM)
% 将交叉得到的子代种群作为变异的父代种群，按照一定的变异概率和变异动作变异生成子代种群
% 输入：父代种群；变异率
% 输出：子代种群
% 调用函数：无

% 计算个体的长度
chrom_half_len = size(children,2) / 2;
% 计算子代的个数和个体的长度
nChildren = size(children, 1);
% 对于每一个个体，满足变异率大于生成的随机数则进行变异操作
for i = 1:nChildren
    if PM >= rand
        % 随机取两个变异的位置
        tmp = randperm(chrom_half_len);
        location = tmp(1);
        while location == chrom_half_len || location == 1
            tmp = randperm(chrom_half_len);
            location = tmp(1);
        end
        children(i, :) = [children(i, location+1:chrom_half_len), children(i, 1:location), children(i, chrom_half_len+1:chrom_half_len*2)];
    end
end