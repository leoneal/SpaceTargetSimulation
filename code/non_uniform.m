function non_uniform_bg = non_uniform(min_gray, max_gray, x0, y0, mode, m, n)
% 生成非均匀分布的背景，灰度值范围为[min_gray, max_gray]，mode用于选择线性非均匀或高斯非均匀

% 调试参数
% min_gray = 30;
% max_gray = 100;
% x0 = 120;  
% y0 = -60;
% mode = 'linear';
% m = 256;
% n = 256;

switch mode
    case 'linear'
        k = (max_gray - min_gray) / m;  % 线性分布背景的增益系数
        b = min_gray;  % 偏置系数
        Y = ones(m, 1);  % 列向量
        X = 1:n;  % 行向量
        non_uniform_bg = Y * (k*X + b);
        non_uniform_bg = uint8(non_uniform_bg);
%         figure(1)
%         imshow(non_uniform_bg, [0,255])
    case 'gaussian'
        A = 0.3e8;   
        sigma = 200;
        non_uniform_bg = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                non_uniform_bg(i, j) = (i - x0).^2 + (j - y0).^2;
            end
        end
        non_uniform_bg = -non_uniform_bg / ( 2 * sigma^2 );
        non_uniform_bg = exp(non_uniform_bg);
        non_uniform_bg = A * (1 / (2 * pi * sigma^2)) * non_uniform_bg;
        non_uniform_bg = uint8(non_uniform_bg);
%         figure(1)
%         imshow(non_uniform_bg, [0,255])
end
end

