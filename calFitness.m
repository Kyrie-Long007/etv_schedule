function object_function = calFitness(individual, task_coor, vehicle_start_coor)
% 计算适应度函数
% 输入：个体；任务点之间的距离
% 输出：总时间，总空载距离
% 调用函数：无

%% 初始化目标函数
object_function = [];
total_time = 0;
total_empty_load_distance = 0;

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

%% 制定策略：当前坐标距离任务起始坐标更近的小车先执行任务；同一时刻只能有一辆小车处于运动状态；不先执行任务的小车先静止或者避让，若是死锁，避让也是按照上述顺序
% 小车当前坐标，将要执行任务的起始坐标，终止坐标
vehicle1_coor = [vehicle_start_coor(1, :), task_coor(vehicle1_task(1), :)];
vehicle2_coor = [vehicle_start_coor(2, :), task_coor(vehicle2_task(1), :)];
% 判断两辆小车当前坐标距离任务起始坐标的水平方向位移（双层循环，直至小车执行完成所有任务）
if abs(vehicle1_coor(1)-vehicle1_coor(3)) > abs(vehicle2_coor(1)-vehicle2_coor(3))
    a = 1;
else
    a = 1;
end


%% 计算小车的总运行时间
%             if vehicle1_coor_min > vehicle2_coor_max || vehicle2_coor_min > vehicle1_coor_max
%                 % 情况1：不存在路径交叉
%                 if vehicle1_coor_min > vehicle2_coor_max
%                     % 判断小车1与小车2之间的安全距离是否大于预设值
%                     if vehicle1_coor_min - vehicle2_coor_max >= SAFE_DISTANCE
%                         % 大于安全距离，小车1静止，小车2执行任务
%                     else
%                         % 不大于安全距离，小车1先执行避让策略，小车2再执行任务
%                     end
%                 else
%                     % 判断小车1与小车2之间的安全距离是否大于预设值
%                     if vehicle2_coor_min - vehicle1_coor_max >= SAFE_DISTANCE
%                         % 大于安全距离，小车1静止，小车2执行任务
%                     else
%                         % 不大于安全距离，小车1先执行避让策略，小车2再执行任务
%                     end
%                 end
%                         
%             else
%                 % 情况2：存在路径交叉
%                 
%             end



%% 最终目标函数
object_function(1) = total_time;
object_function(2) = total_empty_load_distance;
