%% 为星图图片添加高斯噪声
function img_out = add_noise(img_in, mean, var, lambda, hot_pixel_prob, hot_pixel_num, hot_pixel_val)
    % 调试参数
%     img_in = imread('star_bg.jpg');
%     %img_in = zeros(256,256);
%     mean = 10;
%     var = 5;  % 方差
    
    [m, n] = size(img_in);
    
    % 添加正态分布噪声
    noise_norm = normrnd(mean, var, [m, n]);
    
    % 添加泊松分布噪声
    noise_poiss = poissrnd(lambda, m, n);
    
    % 将噪声加入图片
    img_out = double(img_in) + noise_norm + noise_poiss;
    
    % 添加热像素噪声（按hot_pixel_prob给定的概率）
    p = rand;
    if p < hot_pixel_prob
        % 生成给定数目的热像素
        for i = 1:hot_pixel_num
            % 随机热像素位置
            x = fix(m * rand(1));
            y = fix(n * rand(1));
            img_out(x,y) = hot_pixel_val;
        end
    end
end