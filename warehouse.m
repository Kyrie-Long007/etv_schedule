%%
clear;
clc;
[num, txt, raw] = xlsread('实验数据.xlsx');
disp(num);
task1 = num(:, 2:3);
task2 = num(:, 5:6);
task_length = length(task1);

col = ['ro-', 'go-', 'bo-', 'mo-', 'co-','ro-', 'go-', 'bo-', 'mo-', 'co-'];
figure(1)
hold on
for i = 1:task_length
    scatter(task1(i, 1), task1(i, 2), 20, 'ro');
    text(task1(i, 1), task1(i, 2), ['', num2str(i)], 'FontSize', 10);
    scatter(task2(i, 1), task2(i, 2), 80, 'kv');
    text(task2(i, 1), task2(i, 2), ['', num2str(i)], 'FontSize', 10);
end

%%
% 先不考虑解决冲突（当成一个VRP问题）
% 在货架最大范围内随机产生两辆小车的位置，小车1在小车2的左边
% 1、假设小车1位置(0, 0),小车2的位置(1, 0)
% 假设小车1和小车2各完成15项任务
% 假设小车1和小车2可以在任意方向上移动




%%
% 初始化种群
% 计算适应度函数
% 交叉（改变小车任务顺序，改变任务分配）