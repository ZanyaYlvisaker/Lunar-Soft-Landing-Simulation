function [psi, phi, t_go] = guidanceLaw(state, params)
% 多项式显式制导律
% 输入: 当前状态, 系统参数
% 输出: 推力方向角(psi, phi), 剩余时间估计(t_go)

% 解包状态变量
r = state(1);
u = state(4);
v = state(5);
w = state(6);
m = state(7);

delta_v = params.vf - v;
delta_w = params.wf - w;
V_horizontal = sqrt(delta_v^2 + delta_w^2);  % 当前水平速度

% 初始猜测：假设a_H = F/m
F = params.F_nominal * params.F_factor;
a_F = F / m;
a_H_initial = a_F;

% 剩余时间估计 (式17-16)
t_go_guess = V_horizontal / a_H_initial;
    
max_iter = 10;      % 最大迭代次数
tolerance = 1e-5;   % 收敛容差

for iter = 1:max_iter
    % 计算径向加速度a（式17-14）
    numerator_a = 6*(params.rf - r - u*t_go_guess) - 2*(params.uf - u)*t_go_guess;
    a_radial = numerator_a / (t_go_guess^2);
        
    % 计算psi角（式17-15）
    term_gravity = params.mu_moon / r^2;
    term_centrifugal = (v^2 + w^2) / r;
    numerator_psi = a_radial + term_gravity - term_centrifugal;
    cos_psi = numerator_psi / a_F;
    cos_psi = max(min(cos_psi, 1), 0); % 限制在有效范围
    psi = acos(cos_psi);
        
    % 更新水平加速度和剩余时间
    a_H = a_F * sin(psi);
    t_go_new = V_horizontal / a_H;
        
    % 检查收敛
    if abs(t_go_new - t_go_guess) < tolerance
        % disp([iter, "收敛"])
        break;
    end
    t_go_guess = t_go_new;
end
t_go = t_go_guess;

% 推力偏航角phi计算
Vc_x = params.vf - v;  % 纬度方向速度增量
Vc_y = params.wf - w;  % 经度方向速度增量

phi = acos(Vc_x/sqrt(Vc_x^2+Vc_y^2));
end