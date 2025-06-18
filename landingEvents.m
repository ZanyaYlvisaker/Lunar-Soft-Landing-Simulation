function [value, isterminal, direction] = landingEvents(~, y, rf)
% 定义仿真终止事件
% 达到目标高度 (高度<2km)
value = y(1) - rf;           % 目标高度2km
isterminal(1) = 1;           % 触发时终止
direction(1) = -1;           % 下降穿过阈值时触发
end