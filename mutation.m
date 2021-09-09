function children = mutation(children, PM)
% 将交叉得到的子代种群作为变异的父代种群，按照一定的变异概率和变异动作变异生成子代种群
% 输入：父代种群；变异率
% 输出：子代种群
% 调用函数：无

% 计算子代的个数和个体的长度
[nChildren, L] = size(children);
% 对于每一个个体，满足变异率大于生成的随机数则进行变异操作
for i = 1:nChildren
    if PM >= rand
        % 随机取两个变异的位置
        location = randperm(L);
        children(i, location(1:2)) = children(i, location(2:-1:1));
    end
end