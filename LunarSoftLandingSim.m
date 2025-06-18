%% 主仿真脚本：LunarSoftLandingSim.m
% 月球软着陆制导控制系统综合仿真
% 包含：动力学模型、制导律、控制器、偏差注入和性能评估模块

clearvars; close all; clc;

%% 1. 系统参数初始化 (来自文档第8页)
simParams = struct();

% 物理常数
simParams.gE = 9.8;              % 地表重力加速度 [m/s²]
simParams.mu_moon = 4.88775e12;  % 月球引力常数 [m³/s²]
simParams.R_moon = 1738e3;       % 月球半径 [m]

% 推进系统参数
simParams.F_nominal = 1500;      % 标称推力 [N]
simParams.Isp_nominal = 300;     % 标称比冲 [s]
simParams.C_nominal = simParams.Isp_nominal * simParams.gE; % 发动机常数

% 初始状态
simParams.r0 = 1753e3;           % 初始月心距 [m]
simParams.beta0 = deg2rad(0);    % 初始纬度 [rad]
simParams.alpha0 = deg2rad(5);   % 初始经度 [rad]
simParams.u0 = 0;                % 初始径向速度 [m/s]
simParams.v0 = 1692;             % 初始横向速度1 [m/s]
simParams.w0 = 0;                % 初始横向速度2 [m/s]
simParams.m0 = 600;              % 初始质量 [kg]

% 终端约束
simParams.rf = 1740e3;           % 终端月心距 [m] (距月面2km)
simParams.uf = 0;                % 终端径向速度 [m/s]
simParams.vf = 0;                % 终端横向速度1 [m/s]
simParams.wf = 0;                % 终端横向速度2 [m/s]

% 仿真设置
simParams.tspan = [0, 2000];     % 仿真时间 [s]
simParams.reltol = 1e-6;         % 相对容差
simParams.abstol = 1e-6;         % 绝对容差

% 事件函数：检测高度是否达到终端
options = odeset('Events', @(t,y) landingEvents(t, y, simParams.rf));
%% 2. 运行标称工况仿真
[time_nominal, state_nominal] = runLandingSimulation(simParams);

%% 3. 参数偏差影响分析
% 3.1 推力偏差分析 (±10%)
thrust_deviations = [0.9, 1.0, 1.1]; % -10%, 标称, +10%
time_thrust = cell(size(thrust_deviations));
state_thrust = cell(size(thrust_deviations));

for i = 1:length(thrust_deviations)
    simParams.F_factor = thrust_deviations(i);
    [time_thrust{i}, state_thrust{i}] = runLandingSimulation(simParams);
end

% 3.2 比冲偏差分析 (±10%)
Isp_deviations = [0.9, 1.0, 1.1]; % -10%, 标称, +10%
time_Isp = cell(size(Isp_deviations));
state_Isp = cell(size(Isp_deviations));

for i = 1:length(Isp_deviations)
    simParams.Isp_factor = Isp_deviations(i);
    [time_Isp{i}, state_Isp{i}] = runLandingSimulation(simParams);
end

% 3.3 初始速度方向偏差分析
velocity_angles = deg2rad([-5, -3, 0, 3, 5]); % 偏差角度 [rad]
time_velocity = cell(size(velocity_angles));
state_velocity = cell(size(velocity_angles));

for i = 1:length(velocity_angles)
    simParams.velocity_angle = velocity_angles(i);
    [time_velocity{i}, state_velocity{i}] = runLandingSimulation(simParams);
end

%% 4. 结果可视化与分析
analyzeResults(time_nominal, state_nominal, time_thrust, state_thrust, time_Isp, state_Isp, time_velocity, state_velocity);