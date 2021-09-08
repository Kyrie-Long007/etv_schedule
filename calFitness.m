function object_function = calFitness(N, SAFE_DISTANCE, HORIZONTAL_SPEED, VERTICAL_SPEED, individual, task_coor, vehicle_start_coor)
% 计算适应度函数
% 输入：个体；任务点之间的距离
% 输出：总时间，总空载距离
% 调用函数：无

%% 初始化目标函数，避让时间，空载时间(去往任务点的空载时间，即非避让的空载时间)，任务时间，总时间，初始空载距离
object_function = [];
total_time = 0;
total_empty_load_distance = 0;
vehicle1_escape_time = [];
vehicle1_empty_load_time = [];
vehicle1_task_time = [];
vehicle1_total_time = 0;
vehicle1_empty_load_distance = [];
vehicle1_total_empty_load_distance = 0;
vehicle2_escape_time = [];
vehicle2_empty_load_time = [];
vehicle2_task_time = [];
vehicle2_total_time = 0;
vehicle2_empty_load_distance = [];
vehicle2_total_empty_load_distance = 0;

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

% 发生死锁时的避让策略(小车1和小车2从当前坐标到各自任务起始坐标距离)
% 每完成一次任务，对应的vehicle_task_len-1，直到所有的任务全部完成；vehicle_coor在每次完成任务时需要实时更新
vehicle1_task_len = length(vehicle1_task);
vehicle2_task_len = length(vehicle2_task);

% 执行任务(只要还有小车存在任务，持续循环)
while vehicle1_task_len > 0 && vehicle2_task_len > 0
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
            % 小车1去往vehicle1_vehicle2_max，随后小车2去往任务点起始坐标
            vehicle1_coor(7:8) = [vehicle1_vehicle2_max, vehicle1_coor(2)];
            vehicle2_coor(7:8) = vehicle2_coor(3:4);
        else
            % 小车1去往vehicle1_vehicle2_min，随后小车2去往任务点起始坐标
            vehicle1_coor(7:8) = [vehicle1_vehicle2_min, vehicle1_coor(2)];
            vehicle2_coor(7:8) = vehicle2_coor(3:4);
        end
        % 计算小车1的避让时间
        vehicle1_escape_time = [vehicle1_escape_time, max(abs(vehicle1_coor(1)-vehicle1_coor(7))/HORIZONTAL_SPEED, abs(vehicle1_coor(2)-vehicle1_coor(8))/VERTICAL_SPEED)];  
        % 计算小车1的空载距离(避让距离)
        vehicle1_empty_load_distance = [vehicle1_empty_load_distance, abs(vehicle1_coor(1)-vehicle1_coor(7))+abs(vehicle1_coor(2)-vehicle1_coor(8))];
        % 小车2去往任务点并执行任务，计算小车2的空载时间和空载距离(去往任务起始坐标距离)
        vehicle2_empty_load_time = [vehicle2_empty_load_time, max(abs(vehicle2_coor(1)-vehicle2_coor(7))/HORIZONTAL_SPEED, abs(vehicle2_coor(2)-vehicle2_coor(8))/VERTICAL_SPEED)];
        vehicle2_empty_load_distance = [vehicle2_empty_load_distance, abs(vehicle2_coor(1)-vehicle2_coor(7))+abs(vehicle2_coor(2)-vehicle2_coor(8))];
        % 计算小车2的任务时间
        vehicle2_task_time = [vehicle2_task_time, max(abs(vehicle2_coor(3)-vehicle2_coor(5))/HORIZONTAL_SPEED, abs(vehicle2_coor(4)-vehicle2_coor(6))/VERTICAL_SPEED)];
        % 小车2的任务数量减1
        vehicle2_task_len = vehicle2_task_len - 1;
        % 更新小车2的vehicle2_coor
        if vehicle2_task_len > 0
            vehicle2_coor(1:2) = vehicle2_coor(5:6);
            vehicle2_coor(3:6) = task_coor(vehicle2_task(length(vehicle2_task)-vehicle2_task_len+1), :);
        end
    else
        % 此时小车1当前坐标到任务起始坐标更近，小车1优先执行任务，此时小车2静止或执行避让策略
        % 小车2的当前坐标必须比小车1的当前坐标，任务起始坐标，任务终止坐标中最小值小或最大值大一单位安全距离
        % 判断小车2当前坐标距离小车1的当前坐标，任务起始坐标，任务终止坐标中最小值或最大值的绝对值更近距离
        vehicle2_vehicle1_min = abs(vehicle2_coor(1) - (vehicle1_coor_min - SAFE_DISTANCE));
        vehicle2_vehicle1_max = abs(vehicle2_coor(1) - (vehicle1_coor_max + SAFE_DISTANCE));
        if vehicle2_vehicle1_min > vehicle2_vehicle1_max
            % 小车2去往vehicle2_vehicle1_max，随后小车1去往任务点起始坐标
            vehicle1_coor(7:8) = vehicle1_coor(3:4);
            vehicle2_coor(7:8) = [vehicle2_vehicle1_max, vehicle2_coor(2)];
        else
            % 小车2去往vehicle2_vehicle1_min，随后小车1去往任务点起始坐标
            vehicle1_coor(7:8) = vehicle1_coor(3:4);
            vehicle2_coor(7:8) = [vehicle2_vehicle1_min, vehicle2_coor(2)];
        end
        % 计算小车2的避让时间
        vehicle2_escape_time = [vehicle2_escape_time, max(abs(vehicle2_coor(1)-vehicle2_coor(7))/HORIZONTAL_SPEED, abs(vehicle2_coor(2)-vehicle2_coor(8))/VERTICAL_SPEED)];  
        % 计算小车2的空载距离(避让距离)
        vehicle2_empty_load_distance = [vehicle2_empty_load_distance, abs(vehicle2_coor(1)-vehicle2_coor(7))+abs(vehicle2_coor(2)-vehicle2_coor(8))];
        % 小车1去往任务点并执行任务，计算小车1的空载时间和空载距离(去往任务起始坐标距离)
        vehicle1_empty_load_time = [vehicle1_empty_load_time, max(abs(vehicle1_coor(1)-vehicle1_coor(7))/HORIZONTAL_SPEED, abs(vehicle1_coor(2)-vehicle1_coor(8))/VERTICAL_SPEED)];
        vehicle1_empty_load_distance = [vehicle1_empty_load_distance, abs(vehicle1_coor(1)-vehicle1_coor(7))+abs(vehicle1_coor(2)-vehicle1_coor(8))];
        % 计算小车1的任务时间
        vehicle1_task_time = [vehicle1_task_time, max(abs(vehicle1_coor(3)-vehicle1_coor(5))/HORIZONTAL_SPEED, abs(vehicle1_coor(4)-vehicle1_coor(6))/VERTICAL_SPEED)];
        % 小车1的任务数量减1
        vehicle1_task_len = vehicle1_task_len - 1;
        % 更新小车1的vehicle1_coor
        if vehicle1_task_len > 0
            vehicle1_coor(1:2) = vehicle1_coor(5:6);
            vehicle1_coor(3:6) = task_coor(vehicle1_task(length(vehicle1_task)-vehicle1_task_len+1), :);
        end
    end
    % 每执行完一次任务都要判断是否存在小车已经完成了被分配的所有任务，小车执行完任务的返回坐标(0或者68)，取决于下一次另一辆小车的执行方向
    if vehicle2_task_len == 0
        % 剩下仅完成小车1的任务即可(假设小车2在完成任务后直接消失，不存在阻挡小车1剩下路径)
        while vehicle1_task_len > 0
            vehicle1_empty_load_time = [vehicle1_empty_load_time, max(abs(vehicle1_coor(1)-vehicle1_coor(3))/HORIZONTAL_SPEED, abs(vehicle1_coor(2)-vehicle1_coor(4))/VERTICAL_SPEED)];
            vehicle1_empty_load_distance = [vehicle1_empty_load_distance, abs(vehicle1_coor(1)-vehicle1_coor(3))+abs(vehicle1_coor(2)-vehicle1_coor(4))];
            vehicle1_task_time = [vehicle1_task_time, max(abs(vehicle1_coor(3)-vehicle1_coor(5))/HORIZONTAL_SPEED, abs(vehicle1_coor(4)-vehicle1_coor(6))/VERTICAL_SPEED)];
            vehicle1_task_len = vehicle1_task_len - 1;
            if vehicle1_task_len > 0
                vehicle1_coor(1:2) = vehicle1_coor(5:6);
                vehicle1_coor(3:6) = task_coor(vehicle1_task(length(vehicle1_task)-vehicle1_task_len+1), :);
            end
        end
    elseif vehicle1_task_len == 0
        % 剩下仅完成小车2的任务即可(假设小车1在完成任务后直接消失，不存在阻挡小车2剩下路径)
        while vehicle2_task_len > 0
            vehicle2_empty_load_time = [vehicle2_empty_load_time, max(abs(vehicle2_coor(1)-vehicle2_coor(3))/HORIZONTAL_SPEED, abs(vehicle2_coor(2)-vehicle2_coor(4))/VERTICAL_SPEED)];
            vehicle2_empty_load_distance = [vehicle2_empty_load_distance, abs(vehicle2_coor(1)-vehicle2_coor(3))+abs(vehicle2_coor(2)-vehicle2_coor(4))];
            vehicle2_task_time = [vehicle2_task_time, max(abs(vehicle2_coor(3)-vehicle2_coor(5))/HORIZONTAL_SPEED, abs(vehicle2_coor(4)-vehicle2_coor(6))/VERTICAL_SPEED)];
            vehicle2_task_len = vehicle2_task_len - 1;
            if vehicle2_task_len > 0
                vehicle2_coor(1:2) = vehicle2_coor(5:6);
                vehicle2_coor(3:6) = task_coor(vehicle2_task(length(vehicle2_task)-vehicle2_task_len+1), :);
            end
        end
    end
end

%% 计算小车的总运行时间和总空载距离
vehicle1_total_time = vehicle1_total_time + sum(vehicle1_escape_time) + sum(vehicle1_empty_load_time) + sum(vehicle1_task_time);
vehicle1_total_empty_load_distance = vehicle1_total_empty_load_distance + sum(vehicle1_empty_load_distance);
vehicle2_total_time = vehicle2_total_time + sum(vehicle2_escape_time) + sum(vehicle2_empty_load_time) + sum(vehicle2_task_time);
vehicle2_total_empty_load_distance = vehicle2_total_empty_load_distance + sum(vehicle2_empty_load_distance);
total_time = total_time + vehicle1_total_time + vehicle2_total_time;
total_empty_load_distance = total_empty_load_distance + vehicle1_total_empty_load_distance + vehicle2_total_empty_load_distance;

%% 最终目标函数
object_function(1) = total_time;
object_function(2) = total_empty_load_distance;
