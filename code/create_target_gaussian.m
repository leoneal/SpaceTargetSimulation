%% 生成指定数量的目标
function target_pre = create_target_gaussian(target_num, target_size, target_pos, target_mag, m, n)
% 调试函数用参数，调试完注释掉
% bg = imread('./image/3.jpg');
% bg = rgb2gray(bg);
% bg = im2double(bg);
% % figure(3);
% % imshow(bg);
% [m, n] = size(bg);
% target_size = 8;
% m = 256;
% n = 256;
% x = fix(m/2);
% y = fix(n/2);
% mag = 103;
% target_num = 1;
% target_size = [5];
% target_pos = [128 128];
% target_mag = [150];


sigma_arr = [0.2, 0.25, 0.4, 0.6, 0.707, 1, 1.3, 1.4, 1.53]; % 不同大小目标的标准差矩阵，下标对应目标大小

target_pre = zeros(m, n);
for i = 1 : target_num
    target = zeros(m, n);
    
    for row = 1 : 1 : m
        for col = 1 : 1 : n 
            target( row, col ) = ( row - target_pos(i, 1)).^2 + ( col - target_pos(i, 2)).^2; 
        end
    end
    sigma = sigma_arr(target_size(i));  % 由目标大小定sigma
    target = -target / ( 2 * sigma^2 );
    target = exp(target);
    target = target_mag(i) * target;
    
    target_pre = target_pre + target;
end


%target_pre = mat2gray(target_pre, [0 255]);  % 归一化像素值0-255
%imshow(target_pre);

end

% function target = create_target_gaussian(target_size, m, n, x, y, mag)
% % 调试函数用参数，调试完注释掉
% % bg = imread('./image/3.jpg');
% % bg = rgb2gray(bg);
% % bg = im2double(bg);
% % % figure(3);
% % % imshow(bg);
% % [m, n] = size(bg);
% % target_size = 8;
% % m = 256;
% % n = 256;
% % x = fix(m/2);
% % y = fix(n/2);
% % mag = 103;
% 
% 
% sigma_arr = [0.2, 0.25, 0.4, 0.6, 0.707, 1, 1.3, 1.4, 1.53]; % 不同大小目标的标准差矩阵，下标对应目标大小
% sigma = sigma_arr(target_size);  % 由目标大小定sigma
%  
% target = zeros(m, n);
% for row = 1 : 1 : m
%     for col = 1 : 1 : n 
%         target( row, col ) = ( row - x ).^2 + ( col - y ).^2; 
%     end
% end
% target = -target / ( 2 * sigma^2 );
% target = exp(target);
% target = mag * target;
% 
% %Z = mat2gray(Z, [0 255]);  % 归一化像素值0-255
% %imwrite(Z, 'target.jpg');
% 
% end