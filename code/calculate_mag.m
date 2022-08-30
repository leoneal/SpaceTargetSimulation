%% 给定SNR，计算生成目标的中心灰度值
% 参数
% snr: 指定的信噪比
% img_bg：背景图片
% x, y: 生成目标的位置
% target_size:生成目标的大小

function mag = calculate_mag(snr, img_bg, x, y, target_size)
    %% 调试参数，调完注释掉
%     snr = 3;
%     img_bg = imread('bg+noise.jpg');
%     [m, n] = size(img_bg);
%     x = 1;
%     y = 1;
%     target_size = 5;

%%
    [m, n] = size(img_bg);
    r = 5;  % 定义邻域区域宽度
    neibor_region = [];  % 创建存放邻域像素值的向量
    if mod(target_size, 2) == 1
        half_target_size = round(0.5 * target_size);
    else 
        half_target_size = target_size / 2;
    end
    for i = x - half_target_size - r : 1 : x + half_target_size + r
        for j = y - half_target_size - r : 1 : y + half_target_size + r
            if (i >= x - half_target_size && i <= x + half_target_size) && (j >= y - half_target_size && j <= y + half_target_size)
                % 像素属于目标区域
                continue;
            end
            if i > m
                i = m;
            elseif i < 1
                i = 1;
            end
            if j > n
                j = n;
            elseif j < 1
                j = 1;
            end
%             i
%             j
            neibor_region = [neibor_region double(img_bg(i, j))];
        end
    end
   
    mu_b = mean(neibor_region);  % 邻域噪声的均值
    sigma_b = std(neibor_region);  % 邻域噪声的标准差
     
%% 用推导的公式算mag
%     mu_t = mu_b + snr * sigma_b  % 目标像素均值
%     sigma_arr = [0.2, 0.25, 0.4, 0.6, 0.707, 1, 1.3, 1.4, 1.53]; % 不同大小目标的标准差矩阵，下标对应目标大小
%     sigma_t = sigma_arr(target_size)  % 目标像素标准差
%     
%     F = 0;
%     for i = - half_target_size : 1 : half_target_size
%         for j = - half_target_size : 1 : half_target_size
%             F = F + exp(-(i * i + j * j) / (2 * sigma_t * sigma_t));
%         end
%     end
%     F
%     
%     % mag = (mu_t * target_size * target_size) / 0.9;
%     mag = mu_t * target_size * target_size / F

%% 暴力枚举要求的mag

    sigma_arr = [0.2, 0.25, 0.4, 0.6, 0.707, 1, 1.3, 1.4, 1.53]; % 不同大小目标的标准差矩阵，下标对应目标大小
    sigma = sigma_arr(target_size);  % 由目标大小定sigma
     
    Z = zeros(target_size, target_size);
    % half_target_size = round(0.5 * target_size);
    for row = 1 : 1 : target_size
        for col = 1 : 1 : target_size
            Z( row, col ) = ( row - half_target_size ).^2 + ( col - half_target_size ).^2; 
        end
    end

    Z = -Z / ( 2 * sigma^2 );
    Z = exp(Z);
    Z_ori = Z;
    
    if mod(target_size, 2) == 1
        if x - half_target_size + 1 < 1
            x_start_idx = 1;
        else
            x_start_idx = x - half_target_size + 1;
        end
        if x + half_target_size - 1 > m
            x_end_idx = m;
        else
            x_end_idx = x + half_target_size - 1;
        end
        
        if y - half_target_size + 1 < 1
            y_start_idx = 1;
        else
            y_start_idx = y - half_target_size + 1;
        end
        if y + half_target_size - 1 > n
            y_end_idx = n;
        else
            y_end_idx = y + half_target_size - 1;
        end
        target_region_ori = double(img_bg(x_start_idx : x_end_idx, y_start_idx : y_end_idx));  % 得到的是目标区域的原有噪声
    else
        if x - half_target_size + 1 < 1
            x_start_idx = 1;
        else
            x_start_idx = x - half_target_size + 1;
        end
        if x + half_target_size - 1 > m
            x_end_idx = m;
        else
            x_end_idx = x + half_target_size;
        end
        
        if y - half_target_size + 1 < 1
            y_start_idx = 1;
        else
            y_start_idx = y - half_target_size + 1;
        end
        if y + half_target_size - 1 > n
            y_end_idx = n;
        else
            y_end_idx = y + half_target_size;
        end
        target_region_ori = double(img_bg(x_start_idx : x_end_idx, y_start_idx : y_end_idx));
    end
    
    mag = 1;
    while(true)
        Z = mag * Z;
        
        % 如果目标区域在图像边缘，尺寸比设定的目标尺寸小，需扩充到设定的目标尺寸
        [dz1, dz2] = size(Z);
        [dt1, dt2] = size(target_region_ori);
        while(dt1 < dz1)
            dt1_add = zeros(1, dt2);
            target_region_ori = [target_region_ori; dt1_add];
            [dt1, dt2] = size(target_region_ori);
        end
        [dt1, dt2] = size(target_region_ori);
        while(dt2 < dz2)
            dt2_add = zeros(dt1, 1);
            target_region_ori = [target_region_ori dt2_add];
            [dt1, dt2] = size(target_region_ori);
        end
     
        
        Z = Z + target_region_ori;
        mu_t = mean(mean(Z));
        snr_tmp = (mu_t - mu_b) / sigma_b;
        if mag > 255 || abs(snr_tmp - snr) < 0.3
            break;
        end
        mag = mag + 1;
        Z = Z_ori;
    end
   
    %Z = mat2gray(Z, [0 255]);  % 归一化像素值0-255
    
end
