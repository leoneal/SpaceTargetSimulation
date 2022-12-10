%% 为星图图片添加高斯噪声
function img_out = add_noise(img_in, mean, var)
    % 调试参数
%     img_in = imread('star_bg.jpg');
%     %img_in = zeros(256,256);
%     mean = 10;
%     var = 5;  % 方差
    
    [m, n] = size(img_in);
    
    % 添加正态分布噪声
    noise = normrnd(mean, var, [m, n]);
    
    img_out = double(img_in) + noise;
end