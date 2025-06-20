function dstate = lunarDynamics(t, state, params)
% 月球软着陆6自由度动力学模型
% 状态变量: [r, beta, alpha, u, v, w, m]'
% 控制输入: [psi, phi] (推力方向角)

% 解包状态变量
r = state(1);       % 月心距 [m]
beta = state(2);    % 纬度 [rad]
u = state(4);       % 径向速度 [m/s]
v = state(5);       % 纬度方向速度 [m/s]
w = state(6);       % 经度方向速度 [m/s]
m = state(7);       % 质量 [kg]

% 避免奇点 (beta = 0)
if abs(beta) < 1e-5
    if beta == 0
        beta = 1e-5;
    else
    beta = sign(beta) * 1e-5;
    end
end

% 调用制导律计算控制角
[psi, phi] = guidanceLaw(state, params);

% 应用参数偏差
F = params.F_nominal * params.F_factor;
Isp = params.Isp_nominal * params.Isp_factor;
C = Isp * params.gE;

% 动力学方程 (式17-2)
dr = u;
dbeta = v / r;
dalpha = w / (r * sin(beta));

du = (F * cos(psi) / m) - params.mu_moon/r^2 + (v^2 + w^2)/r; % 径向加速度

dv = (F * sin(psi) * cos(phi) / m) - (u*v)/r + (w^2)/(r*tan(beta)); % 横向加速度
dw = (F * sin(psi) * sin(phi) / m) - (u*w)/r - (v*w)/(r*tan(beta));

dm = -F / C; % 质量变化

% 返回状态导数
dstate = [dr; dbeta; dalpha; du; dv; dw; dm];
end
