function dis = calDistance(nodeCoor, N)
% 计算车场与顾客点、顾客点与顾客点两两之间的距离
% 输入：车场和顾客点的位置矩阵；染色体的长度（顾客点的数量）
% 输出：车场与顾客点（第一行第一列）、顾客点与顾客点的距离矩阵（第二行到最后一行，第二列到最后一列）
% 调用函数：无

dis = zeros(N+1, N+1);
for i = 1:N+1
    for j = i:N+1
        dis(i, j) = sqrt((nodeCoor(i, 1) - nodeCoor(j, 1))^2 + (nodeCoor(i, 2) - nodeCoor(j, 2))^2);
        dis(j, i) = dis(i, j);
    end
end