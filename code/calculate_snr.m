%% 计算局部SNR
% img: 包含目标 背景 噪声的图片
% x, y: 目标位置
% target_size：目标大小

function snr = calculate_snr(img, x, y, target_size)
    % 调试参数
    img = imread('./result/pure_sim/target+bg0.jpg');
    x = 128;
    y = 128;
    target_size = 3;
    
    r = 5;  % 定义邻域区域宽度
    neibor_region = [];  % 创建存放邻域像素值的向量
    target_region = [];  % 创建存放目标像素值的向量
    half_target_size = round(0.5 * target_size);

    for i = x - half_target_size - r : 1 : x + half_target_size + r
        for j = y - half_target_size - r : 1 : y + half_target_size + r
            if (i >= x - half_target_size + 1 && i <= x + half_target_size - 1) && (j >= y - half_target_size + 1 && j <= y + half_target_size - 1)
                % 像素属于目标区域
                target_region = [target_region double(img(i, j))];
                continue;
            end
            neibor_region = [neibor_region double(img(i, j))];
        end
    end
%     target_region
%     neibor_region
    
    mu_b = mean(neibor_region); % 邻域噪声的均值
    sigma_b = std(neibor_region);  % 邻域噪声的标准差
    
    mu_t = mean(target_region);    % 目标灰度值的均值
    
    snr = (mu_t - mu_b) / sigma_b;
end