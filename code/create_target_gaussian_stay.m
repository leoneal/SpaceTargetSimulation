%% ����ָ��������Ŀ��
function target_pre = create_target_gaussian_stay(target_num, target_size, target_pos, target_mag, up_ratio, m, n)
% ���Ժ����ò�����������ע�͵�
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


sigma_arr = [0.2, 0.25, 2, 0.6, 3, 1, 1.3, 1.4, 1.53]; % ��ͬ��СĿ��ı�׼������±��ӦĿ���С

target_pre = zeros(m, n);
for i = 1 : target_num
    target = zeros(m, n);
    
    for row = 1 : 1 : m
        for col = 1 : 1 : n 
            target( row, col ) = ( row - target_pos(i, 1)).^2 + ( col - target_pos(i, 2)).^2; 
        end
    end
    sigma = sigma_arr(target_size(i)/up_ratio);  % ��Ŀ���С��sigma
    target = -target / ( 2 * sigma^2 );
    target = exp(target);
    target = target_mag(i) * target;
    
    target_pre = target_pre + target;
end

end

