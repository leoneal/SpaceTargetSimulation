%% ��������������dim��ʹ��

function y = h(x)
F = 500;  %���൥λmm
f = 1;   %��Ȧ
B = (3 * pi^2 * F) / (8 * f);
b = (pi * F) / f;
y = B * (besselj(1, x*2) / (b * x*2)) ^ 2;
