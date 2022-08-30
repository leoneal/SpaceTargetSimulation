%% 贝塞尔函数，在dim中使用

function y = h(x)
F = 500;  %焦距单位mm
f = 1;   %光圈
B = (3 * pi^2 * F) / (8 * f);
b = (pi * F) / f;
y = B * (besselj(1, x*2) / (b * x*2)) ^ 2;
