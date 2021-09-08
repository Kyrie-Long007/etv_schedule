clc;
clear;
close all;
%% 参数设置
% 目标数量
M = 2;
% 种群数量
NIND = 100;
% 染色体长度（双层编码，第一层为任务顺序，第二层为任务对应被分配到的小车）
N = 60;
% 下界
min_range = zeros(1, N);
% 上界
max_range = ones(1, N);
% 迭代次数
GEN = 100;
% 交叉概率
PC = 0.8;
% 变异概率
PM = 0.1; 
% 小车数量
VEHICLE_NUM = 2;
% 小车间的安全距离
SAFE_DISTANCE = 1.5;
% 小车速度
HORIZONTAL_SPEED = 3;
VERTICAL_SPEED = 2;
% 读取任务坐标
[coor, ~, ~] = xlsread('实验数据.xlsx');
% 前两列为任务的起始坐标，后两列为任务的终止坐标
task_coor = [coor(:, 2:3), coor(:, 5:6)];
% 小车初始坐标(两辆小车的初始位置可以在货架最大范围内随机产生，但要求小车1在小车2的左边)
vehicle_start_coor = [0, 0; 68, 0];

%% 初始化种群
chrom = initPop(NIND, N, VEHICLE_NUM);
chrom = non_domination_sort_mod(chrom, M, N);

%% 计算适应度函数
object_function = zeros(size(chrom, 1), 2);
for i = 1:size(chrom, 1)
    individual = chrom(i, :);
    object_function(i, :) = calFitness(N, SAFE_DISTANCE, HORIZONTAL_SPEED, VERTICAL_SPEED, individual, task_coor, vehicle_start_coor);
end

for i = 1:size(chrom, 1)
    scatter(object_function(i, 1), object_function(i, 2), 20, 'ro');
    % text(object_function(i, 1), object_function(i, 2), ['', num2str(i)], 'FontSize', 10);
    hold on;
end
%% 选择(快速非支配排序)
pool = round(size(chrom, 1));
tour = 2;
f = selection(chrom, pool, tour);

object_function1 = zeros(size(chrom, 1), 2);
for i = 1:size(f, 1)
    individual = f(i, :);
    object_function1(i, :) = calFitness(N, SAFE_DISTANCE, HORIZONTAL_SPEED, VERTICAL_SPEED, individual, task_coor, vehicle_start_coor);
end

for i = 1:size(chrom, 1)
    scatter(object_function1(i, 1), object_function1(i, 2), 20, 'ro');
    % text(object_function(i, 1), object_function(i, 2), ['', num2str(i)], 'FontSize', 10);
    hold on;
end















