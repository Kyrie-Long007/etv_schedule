function children = crossover(parent, PC)
% 将选择得到的子代种群作为交叉的父代种群，按照一定的交叉概率和交叉动作交叉生成子代种群
% 输入：父代种群；交叉率
% 输出：子代种群
% 调用函数：Intercross

% 计算子代的个数
nChildren = size(parent, 1);
% 初始化children
children = parent;
% 以下直接包括了nChildren为奇数和偶数两种情况
% 为奇数，按1-2， 3-4， (nChildren-2)-(nChildren-1)，nChildren不参与交叉
% 为偶数，按1-2， 3-4， (nChildren-1)-(nChildren)
for i = 1:2:nChildren - mod(nChildren, 2)
    % 如果交叉率大于产生的随机数则进行交叉操作
    if PC >= rand
        % 交叉方式很多，这里使用两点交叉方法，使用函数的方式的好处是便于更换交叉方法
        [children(i, :), children(i+1, :)] = Intercross(parent(i, :), parent(i+1, :));    
    end
end

function [child_chrom1, child_chrom2] = Intercross(parent_chrom1, parent_chrom2)
% 部分匹配交叉法（全局搜索，丰富种群的多样性，加快种群的收敛性，不和交叉前进行比较）
% 输入：a, b是两个待交叉的父代个体
% 输出：a, b是两个交叉完成之后的子代个体
% 调用函数：无

% 计算个体的长度
chrom_half_len = size(parent_chrom1,2) / 2;
% 初始化子代染色体
child_chrom1 = parent_chrom1;
child_chrom2 = parent_chrom2;
% 随机选择交叉位置，确保不存在极端位置
tmp = randperm(chrom_half_len);
location = tmp(1);
while location == chrom_half_len
    tmp = randperm(chrom_half_len);
    location = tmp(1);
end
% 子代染色体组成的前半部分直接复制同源父代染色体
child_chrom1(1:location) = parent_chrom1(1:location);
child_chrom1(chrom_half_len+1:chrom_half_len+location) = parent_chrom1(chrom_half_len+1:chrom_half_len+location);
child_chrom2(1:location) = parent_chrom2(1:location);
child_chrom2(chrom_half_len+1:chrom_half_len+location) = parent_chrom2(chrom_half_len+1:chrom_half_len+location);
% 子代染色体组成的后半部分采用非同源染色体的部分匹配交叉
% 找出子代中不存在的任务号(此时不需要考虑分配顺序)
child_chrom1_nexist_task = parent_chrom1(location+1:chrom_half_len);
child_chrom2_nexist_task = parent_chrom2(location+1:chrom_half_len);
for i = 1:length(child_chrom1_nexist_task)
    single1 = child_chrom1_nexist_task(i);
    single2 = child_chrom2_nexist_task(i);
    % 在非同源染色体前半段中找到对应的single(要考虑任务号1和2和小车1和2的问题)
    index1 = find(parent_chrom2(1:chrom_half_len)==single1, 1);
    index2 = find(parent_chrom1(1:chrom_half_len)==single2, 1);
    if length(index1) ~= 1 || length(index2) ~= 1
        disp('index1: ', index1);
        disp('index2: ', index2);
    end
    % 这里应该是location+i 不是 location+1
    child_chrom1(location+i) = parent_chrom2(index1);
    child_chrom1(chrom_half_len+location+i) = parent_chrom2(chrom_half_len+index1);
    child_chrom2(location+i) = parent_chrom1(index2);
    child_chrom2(chrom_half_len+location+i) = parent_chrom1(chrom_half_len+index2);
end
% debug: 判断子代染色体是否存在重复任务
if length(unique(child_chrom1)) < chrom_half_len || length(unique(child_chrom2)) < chrom_half_len
    disp('存在问题')
end






