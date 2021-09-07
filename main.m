clc;
clear;
close all;
%% 参数设置
% 种群数量
NIND = 100;
% 染色体长度（双层编码，第一层为任务顺序，第二层为任务对应被分配到的小车）
N = 60;
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
individual = chrom(1, :);
%% 提取个体中小车1和小车2各自分配到的任务及任务顺序
% 找到小车1分配到的任务在个体中的索引
vehicle1_task_index = find(individual==1) - N/2;
% 去除任务号为1的索引
vehicle1_task_index = vehicle1_task_index(vehicle1_task_index>0);
% 计算小车1实际的分配到的任务及任务顺序
vehicle1_task = individual(vehicle1_task_index);

% 找到小车2分配到的的任务在个体中的索引
vehicle2_task_index = find(individual==2) - N/2;
% 去除任务号为2的索引
vehicle2_task_index = vehicle2_task_index(vehicle2_task_index>0);
% 计算小车2实际的分配到的任务及任务顺序
vehicle2_task = individual(vehicle2_task_index);

% 小车1的当前坐标，将要执行任务的起始坐标，终止坐标，空载移动下一个坐标
vehicle1_coor = [vehicle_start_coor(1, :), task_coor(vehicle1_task(1), :), 0, 0];
vehicle2_coor = [vehicle_start_coor(2, :), task_coor(vehicle2_task(1), :), 0, 0];

% 发生死锁时的避让策略(小车1和小车2从当前坐标到各自任务起始坐标距离)
% 每完成一次任务，对应的vehicle_task_len-1，直到所有的任务全部完成；vehicle_coor在每次完成任务时需要实时更新
vehicle1_task_len = length(vehicle1_task);
vehicle2_task_len = length(vehicle2_task);
while vehicle1_task_len ~= 0
    while vehicle2_task_len ~= 0
        % 找出小车1和小车2当前坐标、任务起始坐标、任务终止坐标三者的最小值与最大值，判断小车1和小车2路径是否存在交叉
        vehicle1_coor_min = min(min(vehicle1_coor(1), vehicle1_coor(3)), vehicle1_coor(5));
        vehicle1_coor_max = max(max(vehicle1_coor(1), vehicle1_coor(3)), vehicle1_coor(5));
        vehicle2_coor_min = min(min(vehicle2_coor(1), vehicle2_coor(3)), vehicle2_coor(5));
        vehicle2_coor_max = max(max(vehicle2_coor(1), vehicle2_coor(3)), vehicle2_coor(5));
        if abs(vehicle1_coor(1)-vehicle1_coor(3)) > abs(vehicle2_coor(1)-vehicle2_coor(3))
            % 此时小车2当前坐标到任务起始坐标更近，小车2优先执行任务，此时小车1静止或执行避让策略
            % 小车1的当前坐标必须比小车2的当前坐标，任务起始坐标，任务终止坐标中最小值小或最大值大一单位安全距离
            % 判断小车1当前坐标距离小车2的当前坐标，任务起始坐标，任务终止坐标中最小值或最大值的绝对值更近距离
            vehicle1_vehicle2_min = abs(vehicle1_coor(1) - (vehicle2_coor_min - SAFE_DISTANCE));
            vehicle1_vehicle2_max = abs(vehicle1_coor(1) - (vehicle2_coor_max + SAFE_DISTANCE));
            if vehicle1_vehicle2_min > vehicle1_vehicle2_max
                % 小车1去往vehicle1_vehicle2_max
                vehicle1_coor(7:8) = [vehicle1_vehicle2_max, vehicle1_coor(2)];
                vehicle2_coor(7:8) = vehicle2_coor(1:2);
            else
                % 小车1去往vehicle1_vehicle2_min
                vehicle1_coor(7:8) = [vehicle1_vehicle2_min, vehicle1_coor(2)];
                vehicle2_coor(7:8) = vehicle2_coor(1:2);
            end
            % 计算小车1的避让时间
            
            
            % 计算小车1的空载距离(避让距离)
            
            % 小车2去往任务点并执行任务
            
            % 计算小车2的任务时间
            
            % 计算小车2的空载距离(去往任务起始坐标距离)
            
            
            % 小车2的任务数量减1
            vehicle2_task_len = vehicle2_task_len - 1;
            % 更新小车2的vehicle2_coor
            vehicle2_coor(1:2) = vehicle2_coor(5:6);
            vehicle2_coor(3:6) = task_coor(vehicle2_task(length(vehicle2_task)-vehicle2_task_len-1));     
        else
            % 此时小车1当前坐标到任务起始坐标更近，小车1优先执行任务，此时小车2静止或执行避让策略
            % 小车2的当前坐标必须比小车1的当前坐标，任务起始坐标，任务终止坐标中最小值小或最大值大一单位安全距离
            % 判断小车2当前坐标距离小车1的当前坐标，任务起始坐标，任务终止坐标中最小值或最大值的绝对值更近距离
            vehicle2_vehicle1_min = abs(vehicle2_coor(1) - (vehicle1_coor_min - SAFE_DISTANCE));
            vehicle2_vehicle1_max = abs(vehicle2_coor(1) - (vehicle1_coor_max + SAFE_DISTANCE));
            if vehicle2_vehicle1_min > vehicle2_vehicle1_max
                % 小车2去往vehicle2_vehicle1_max
                vehicle1_coor(7:8) = vehicle1_coor(1:2);
                vehicle2_coor(7:8) = [vehicle2_vehicle1_max, vehicle2_coor(2)];
            else
                % 小车2去往vehicle2_vehicle1_min
                vehicle1_coor(7:8) = vehicle1_coor(1:2);
                vehicle2_coor(7:8) = [vehicle2_vehicle1_min, vehicle2_coor(2)];
            end
            % 小车1执行任务
            
            
            % 小车1的任务数量减1
            vehicle1_task_len = vehicle1_task_len - 1;
            % 更新小车1的vehicle1_coor
            vehicle1_coor(1:2) = vehicle1_coor(5:6);
            vehicle1_coor(3:6) = task_coor(vehicle1_task(length(vehicle1_task)-vehicle1_task_len-1));
        end
    end
end






% 空载死锁时的避让策略

% 小车1和小车2同时开始执行任务(作业任务一旦开始执行则不进行避让，直到当前任务执行完毕)
% 判断是否存在路径冲突，在运行中能否保证安全作业距离(仅水平方向)

% 不存在路径冲突

% 存在路径冲突，则按照就近原则，距离任务点更近的小车先执行任务(或者使用随机数判断小车执行任务的顺序)

% 小车1和小车2同时处于初始坐标，判断小车1和小车2从初始坐标前往任务1的起始坐标之间的水平方向路径是否存在冲突。小车1到达起始坐标，
% 判断小车2就某个任务距离小车1起始坐标和终止坐标的最大或最小值之间保持安全作业距离
% 判断小车1和小车2的运动方向是否一致(不存在会等于0的情况)
if (vehicle1_coor(1)-vehicle1_coor(3)) * (vehicle2_coor(1)-vehicle2_coor(3)) > 0
    % 代表小车1和小车2的运动方向一致(0     0    32     1    37     3; 68     0     1     2    45     1)
    a = 1;
elseif (vehicle1_coor(1)-vehicle1_coor(3)) * (vehicle2_coor(1)-vehicle2_coor(3)) < 0
    % 代表小车1和小车2的运动方向不一致(32     0    1     1    37     3; 1     0     1     2    45     1)
    a = 1;
end















