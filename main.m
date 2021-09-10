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
% 迭代次数
GEN = 200;
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

%% 计算适应度函数
object_function = zeros(size(chrom, 1), 2);
for i = 1:size(chrom, 1)
    individual = chrom(i, :);
    object_function(i, :) = calFitness(N, SAFE_DISTANCE, HORIZONTAL_SPEED, VERTICAL_SPEED, individual, task_coor, vehicle_start_coor);
end

figure(1);
for i = 1:size(chrom, 1)
    scatter(object_function(i, 1), object_function(i, 2), 20, 'ro');
    % text(object_function(i, 1), object_function(i, 2), ['', num2str(i)], 'FontSize', 10);
    hold on;
end

%% 在染色体中增加适应度函数
chrom = [chrom, object_function];

%% 对染色体进行快速非支配排序和拥挤度计算
chrom = nonDominationSort(chrom, M, N);
% 初始种群最优解
fprintf('Pareto Random Front:\n');
fprintf('(%.4f, %.4f)\n', chrom(1,N+1), chrom(1,N+2));
xlabel('f_1');
ylabel('f_2');
title('Pareto Random Front')

%% 迭代优化
for gen = 1:GEN
    % 查看进化代数
    disp(['gen：', num2str(gen)]);
    % 子代种群数量
    pool = round(size(chrom, 1)/2);
    % 候选人数量
    tour = 2;
    % 选择操作(锦标赛)
    parent_chrom = selection(chrom, pool, tour);
    % 在遗传操作之前，去除种群中适应度函数、排序值和拥挤距离
    parent_chrom = parent_chrom(:, 1:N);
    % 交叉操作
    child_chrom = crossover(parent_chrom, PC);
    % 变异操作
    child_chrom = mutation(child_chrom, PM);
    % 父代种群规模
    parent_chrom_size = size(parent_chrom, 1);
    % 子代种群规模
    child_chrom_size = size(child_chrom, 1);
    % 初始化临时种群(不初始化，下一次循环时 immed_chrom 和 parent_chrom/child_chrom 的数组结构不一致)
    immed_chrom = zeros(size(parent_chrom,1)+size(child_chrom,1), size(parent_chrom,2));
    % 增加临时种群
    immed_chrom(1:parent_chrom_size, :) = parent_chrom;
    % 合并父代种群和子代种群（2N）
    immed_chrom(parent_chrom_size+1:parent_chrom_size+child_chrom_size, :) = child_chrom;
    % 计算适应度函数
    object_function = zeros(size(immed_chrom, 1), 2);
    for i = 1:size(immed_chrom, 1)
        individual = immed_chrom(i, :);
        object_function(i, :) = calFitness(N, SAFE_DISTANCE, HORIZONTAL_SPEED, VERTICAL_SPEED, individual, task_coor, vehicle_start_coor);
    end
    % 在染色体中增加适应度函数
    immed_chrom = [immed_chrom, object_function];
    % 快速非支配排序和拥挤度计算
    immed_chrom = nonDominationSort(immed_chrom, M, N);
    % 子代重插入父代
    chrom = reinsert(immed_chrom, M, N, NIND);
end
    
%% 绘制图形
figure(2);
% 帕累托前沿曲线
if M == 2
    plot(chrom(:,N+1), chrom(:,N+2), '*');
    xlabel('f_1');
    ylabel('f_2');
    title('Pareto Optimal Front');
% 帕累托前沿曲面
elseif M == 3
    plot3(chrom(:,N+1), chrom(:,N+2), chrom(:,N+3), '*');
    xlabel('f_1');
    ylabel('f_2');
    zlabel('f_3');
    title('Pareto Optimal Surface');
end

%% 输出前20个最优解
fprintf('\nPareto Optimal Front:\n')
for i = 1:20
    fprintf('(%.4f, %.4f)\n', chrom(i,N+1), chrom(i,N+2))
end