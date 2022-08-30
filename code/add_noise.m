%% 为星图图片添加高斯噪声
function img_out = add_noise(img_in, mean, var)
    % 调试参数，调试后注释掉
%     img_in = imread('star_bg.jpg');
%     %img_in = zeros(256,256);
%     mean = 10;
%     var = 5;  % 方差
    
    [m, n] = size(img_in);
%     % 添加泊松噪声，泊松噪声的参数是不可调的
%     img_in = imnoise(img_in, 'poisson');
%     % 添加高斯噪声
%     img_out = imnoise(img_in, 'gaussian', mean, var);
    
    noise = normrnd(mean, var, [m, n]);
    % noise
    
    img_out = double(img_in) + noise;
%     img_out = mat2gray(img_out, [0 255]);
    
%     figure(2)
%     imshow(img_out)
    %imwrite(img_out, './result/pure_sim/bg+noise.jpg')
    % imwrite(img_out, 'noise.jpg')
end