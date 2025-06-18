function [time, state] = ...
    runLandingSimulation(params)
% 执行单次着陆仿真

% 初始化控制参数
if ~isfield(params, 'F_factor'), params.F_factor = 1.0; end
if ~isfield(params, 'Isp_factor'), params.Isp_factor = 1.0; end
if ~isfield(params, 'velocity_angle'), params.velocity_angle = 0; end

% 初始状态向量
initial_state = [params.r0; params.beta0; params.alpha0; ...
                params.u0; params.v0; params.w0; params.m0];

% 定义事件函数 (终止条件)
options = odeset('RelTol', params.reltol, 'AbsTol', params.abstol, ...
                 'Events', @(t,y) landingEvents(t,y,params.rf));

% 使用ode45求解器
odefun = @(t,y) lunarDynamics(t, y, params);
[time, state] = ...
    ode45(odefun, params.tspan, initial_state, options);
end