function analyzeResults(t1, s1, t2, s2, t3, s3, t4, s4)
% 可视化仿真结果
colors = {'r', 'b', 'g', 'm', 'k'};

%% 1. 标称工况轨迹
figure('Name', '标称工况着陆轨迹');

% 3D轨迹
subplot(2,2,1);
[x, y, z] = sph2cart(s1(:,3), s1(:,2), s1(:,1));
plot3(x/1000, y/1000, z/1000, 'b', 'LineWidth', 2);
title('3D着陆轨迹');
xlabel('X (km)'); ylabel('Y (km)'); zlabel('高度 (km)');
grid on; legend('着陆轨迹');

% 高度变化
subplot(2,2,2);
plot(t1, s1(:,1)/1000, 'b', 'LineWidth', 2);
title('高度随时间变化');
xlabel('时间 (s)'); ylabel('高度 (km)');
grid on;

% 经纬度变化
subplot(2,2,3);
plot(t1, s1(:,3), 'b-', 'LineWidth', 2);
hold on;
plot(t1, s1(:,2), 'r-', 'LineWidth', 2);
title('推力方向角');
xlabel('时间 (s)'); ylabel('经纬度 (度)');
legend('经度', '纬度');
grid on;

% 质量变化
subplot(2,2,4);
plot(t1, s1(:,7), 'm-', 'LineWidth', 2);
title('探测器质量');
xlabel('时间 (s)'); ylabel('质量 (kg)');
grid on;

%% 2. 推力偏差影响分析
figure('Name', '推力偏差影响分析');

thrust_labels = {'-10%', '标称', '+10%'};

subplot(2,2,1);
hold on;
time_thrust = zeros(1,3);
for i = 1:3
    time_thrust(i) = t2{i}(end);
end
bar(categorical(thrust_labels), time_thrust);
title('推力偏差对着陆时间的影响');
ylabel('时间 (s)');
grid on;

subplot(2,2,2);
fuel_consumed_thrust = zeros(1,3);
for i = 1:3
    fuel_consumed_thrust(i) = 600 - s2{i}(end, 7);
end
bar(categorical(thrust_labels), fuel_consumed_thrust);
title('推力偏差对燃料消耗的影响');
ylabel('燃料消耗量 (kg)');
grid on;

subplot(2,2,3);
hold on;
for i = 1:3
    plot(t2{i}, s2{i}(:,3), '-', 'Color', colors{i}, 'LineWidth', 2);
end
title('推力偏差对经度的影响');
xlabel('时间 (s)'); ylabel('经度 (度)');
legend({'-10%', '标称', '+10%'}, 'Location', 'best');
grid on;

subplot(2,2,4);
hold on;
for i = 1:3
    plot(t2{i}, s2{i}(:,2), '-', 'Color', colors{i}, 'LineWidth', 2);
end
title('推力偏差对纬度的影响');
xlabel('时间 (s)'); ylabel('纬度 (度)');
legend({'-10%', '标称', '+10%'}, 'Location', 'best');
grid on;

%% 3. 比冲偏差影响分析
figure('Name', '比冲偏差影响分析');

Isp_labels = {'-10%', '标称', '+10%'};

subplot(2,2,1);
hold on;
time_Isp = zeros(1,3);
for i = 1:3
    time_Isp(i) = t3{i}(end);
end
bar(categorical(thrust_labels), time_Isp);
title('比冲偏差对着陆时间的影响');
ylabel('时间 (s)');
grid on;

subplot(2,2,2);
fuel_consumed_Isp = zeros(1,3);
for i = 1:3
    fuel_consumed_Isp(i) = 600 - s3{i}(end, 7);
end
bar(categorical(Isp_labels), fuel_consumed_Isp);
title('比冲偏差对燃料消耗的影响');
ylabel('燃料消耗量 (kg)');
grid on;

subplot(2,2,3);
hold on;
for i = 1:3
    plot(t3{i}, s3{i}(:,3), '-', 'Color', colors{i}, 'LineWidth', 2);
end
title('比冲偏差对经度的影响');
xlabel('时间 (s)'); ylabel('经度 (度)');
legend({'-10%', '标称', '+10%'}, 'Location', 'best');
grid on;

subplot(2,2,4);
hold on;
for i = 1:3
    plot(t3{i}, s3{i}(:,2), '-', 'Color', colors{i}, 'LineWidth', 2);
end
title('比冲偏差对纬度的影响');
xlabel('时间 (s)'); ylabel('纬度 (度)');
legend({'-10%', '标称', '+10%'}, 'Location', 'best');
grid on;

%% 4. 初始速度方向偏差影响
figure('Name', '初始速度方向偏差影响');
velocity_labels = {'-5°', '-3°', '标称', '+3°', '+5°'};

subplot(2,2,1);
hold on;
time_velocity = zeros(1,5);
for i = 1:5
    time_velocity(i) = t4{i}(end);
end
bar(categorical(velocity_labels), time_velocity);
title('初始速度方向偏差对着陆时间的影响');
ylabel('时间 (s)');
grid on;

subplot(2,2,2);
fuel_consumed_velocity = zeros(1,5);
for i = 1:5
    fuel_consumed_velocity(i) = 600 - s4{i}(end, 7);
end
bar(categorical(velocity_labels), fuel_consumed_velocity);
title('初始速度方向偏差对燃料消耗的影响');
ylabel('燃料消耗量 (kg)');
grid on;

subplot(2,2,3);
hold on;
for i = 1:5
    plot(t4{i}, s4{i}(:,3), '-', 'Color', colors{i}, 'LineWidth', 2);
end
title('初始速度方向偏差对经度的影响');
xlabel('时间 (s)'); ylabel('经度 (度)');
legend({'-5°', '-3°', '标称', '+3°', '+5°'}, 'Location', 'best');
grid on;

subplot(2,2,4);
hold on;
for i = 1:5
    plot(t4{i}, s4{i}(:,2), '-', 'Color', colors{i}, 'LineWidth', 2);
end
title('初始速度方向偏差对纬度的影响');
xlabel('时间 (s)'); ylabel('纬度 (度)');
legend({'-5°', '-3°', '标称', '+3°', '+5°'}, 'Location', 'best');
grid on;

end