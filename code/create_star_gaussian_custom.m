%% 跟据给定的恒星数量生成随机恒星背景图
% star_num: 恒星数量
% m, n: 生成的背景图片的大小

function bgImg = create_star_gaussian_custom(star_num, m, n)
% 调试参数
% m = 256;
% n = 256;
% star_num = 70;


% 仿真参数
target_size_arr = [3, 5, 7];
sigma_arr = [0.2, 0.25, 0.4, 0.6, 0.707, 1, 1.3, 1.4, 1.53]; % 不同大小目标的标准差矩阵，下标对应目标大小
bgImg = zeros(m, n);  % 纯黑背景基底
Z_pre = bgImg;

for i = 1 : star_num
    
    rand_num = rand(1);
    if rand_num > 0.67 
        idx = 2;
    elseif rand_num < 0.33
        idx = 3;
    else
        idx = 1;
    end
    target_size = target_size_arr(idx);  % 随机目标大小
    sigma = sigma_arr(target_size);  % 由目标大小定sigma
    
    % 随机目标位置
    x = fix(m * rand(1));
    y = fix(n * rand(1));
    
    for row = 1 : 1 : m
        for col = 1 : 1 : n 
            bgImg( row, col ) = ( row - x ).^2 + ( col - y ).^2;
        end
    end
    bgImg = -bgImg / ( 2 * sigma^2 );
    bgImg = exp(bgImg);
    
    mag = 255 * rand(1);  % 随机灰度值
    bgImg = mag * bgImg;
    bgImg = bgImg + Z_pre;
    Z_pre = bgImg;
    
end

end