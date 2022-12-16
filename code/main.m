%% 空间目标及背景星图仿真

%% 仿真参数
simu_type = 'pure';  % 仿真类型 'pure'：纯仿真; 'half_phy'：半物理仿真
dataset_type = 'val';  % 要生成的数据集类型：'train' 'test' 'val'

frame_num = 8;  % 输出的帧数
noise_mean = 10;  %背景高斯噪声均值
noise_var = 15;  % 背景高斯噪声方差
noise_lambda = 20;  % 背景泊松噪声的参数
hot_pixel_prob = 0.2;  % 背景中加入热像素噪声的概率
hot_pixel_num = 2; % 背景中热像素的个数
hot_pixel_val = 200; % 背景中热像素的像素值
make_non_uniform_bg = false;  % 设定是否要在背景上添加非均匀杂散光
non_uniform_mode = 'gaussian';  % 背景杂光的分布模式: 'linear' 'gaussian'
non_uniform_min_gray = 30;  % 背景线性杂光的最小灰度
non_uniform_max_gray = 100;  % 背景线性杂光的最大灰度
non_uniform_x0 = 120;  % 背景高斯杂光的中心x坐标
non_uniform_y0 = -60;  % 背景高斯杂光的中心y坐标
noise_filt = false;  % 是否输出前去噪
img_height = 256;  % 生成图片的高
img_width = 256;  % 生成图片的宽

target_stay = false;  % 设定是否需要仿真目标在像元上的驻留效果
up_ratio = 4;  % 仿真像元驻留时将图片上采样的倍数
target_num_mode = 'fixed_num';  % 'random_num' or 'fixed_num'
target_num = 1;  % 设定视场里生成目标的个数 
target_size_kinds = [3 5];  % 生成目标的所有可能大小
target_SNR = 3;  % 设定目标信噪比（给定背景噪声）
target_starLevel = 10;  % 设定目标星等
target_track_kinds = ['l2r' 'r2l' 'u2d' 'd2u' 'lu2rd' 'ld2ru' 'ru2ld' 'rd2lu']; % 设定目标轨迹 l2r:从左到右 
                                                                                % 后期还应实现根据卫星轨道根数实现设置轨迹的功能
target_speed = [1 1];  % 设定目标的x、y方向的运动速度（用于和帧数相乘）                                                                       
pix_move = 10;  % 设定目标的像移长度（表现为单帧内目标条纹的长度），范围4-10，用来模拟目标的不同轨道速度
target_create_method = 1;  % 设定生成目标的模型，1：高斯模型，2：艾里斑模型

star_create_method = 'sao';  % 生成仿真背景的方式，'sao'：基于sao星表生成，'rand':随机位置生成
star_num = 50;  % 设定视场里生成恒星的个数 （半物理及基于星表仿真不需要这个参数）
min_star_num_thre = 30;
Ra = 5;  % 星敏感器指向赤经
Dec = 5;  % 星敏感器指向赤纬
uFOV = 3;  % 视场角
vFOV = 3;  % 视场角
k = 0;  % 旋转角
pixel = img_height;  % 背景分辨率
fuse_method = 1;  % 设定目标与背景融合的方式，1：线性叠加融合，2：小波融合

train_save_path = 'E:/KeTi/SpTarSim/code/SimuSystem/result/pure_sim/train/';
traindata_save_path = strcat(train_save_path, strcat('series_frames/', strcat('snr',num2str(target_SNR))));
traindata_save_path = strcat(traindata_save_path, '/');
trainlabel_save_path = strcat(train_save_path, strcat('labels/', strcat('snr',num2str(target_SNR))));
trainlabel_save_path = strcat(trainlabel_save_path, '/');

val_save_path = 'E:/KeTi/SpTarSim/code/SimuSystem/result/pure_sim/val/';
valdata_save_path = strcat(val_save_path, strcat('series_frames/', strcat('snr',num2str(target_SNR))));
valdata_save_path = strcat(valdata_save_path, '/');
vallabel_save_path = strcat(val_save_path, strcat('labels/', strcat('snr',num2str(target_SNR))));
vallabel_save_path = strcat(vallabel_save_path, '/');

test_save_path = 'E:/KeTi/SpTarSim/code/SimuSystem/result/pure_sim/test/';
testdata_save_path = strcat(test_save_path, strcat('series_frames/', strcat('snr',num2str(target_SNR))));
testdata_save_path = strcat(testdata_save_path, '/');
testlabel_save_path = strcat(test_save_path, strcat('labels/', strcat('snr',num2str(target_SNR))));
testlabel_save_path = strcat(testlabel_save_path, '/');

train_group_num = 20000;
val_group_num = 2;
test_group_num = 2000;

switch dataset_type
    case 'train'
        max_group_num = train_group_num;
        data_save_path = traindata_save_path;
        label_save_path = trainlabel_save_path;
    case 'test'
        max_group_num = test_group_num;
        data_save_path = testdata_save_path;
        label_save_path = testlabel_save_path;
    case 'val'
        max_group_num = val_group_num;
        data_save_path = valdata_save_path;
        label_save_path = vallabel_save_path;
end

%% 主循环
rng('shuffle');
for group_num = 1 : max_group_num
    % 先判断是否要仿真目标驻留效果
    if target_stay
        %% 获得背景
        % disp('creating background......')
        switch simu_type
            case 'pure'
                if strcmp(star_create_method, 'rand')
                    img_bg = create_star_gaussian_custom(star_num, img_height, img_width);  % 生成随机背景
                elseif strcmp(star_create_method, 'sao')
                    img_bg = create_star_sao(Ra, Dec, uFOV, vFOV, k, pixel, min_star_num_thre);  % 基于sao星表生成背景
                end
                if make_non_uniform_bg
                    non_uniform_bg = non_uniform(non_uniform_min_gray, non_uniform_max_gray, non_uniform_x0, non_uniform_y0, non_uniform_mode, img_height, img_width);
                    img_bg = img_bg + non_uniform_bg;
                end
            case 'half_phy'
                backImRead = imread('../image/img2.jpg');
                img_bg = backImRead(:,:,1);
        end
        
        [m_ori, n_ori] = size(img_bg);  % 原始背景图像尺寸
        
        % 将背景图像上采样
        img_bg_up = imresize(img_bg, up_ratio, 'bilinear');  
        img_bg_keep = img_bg_up;
        figure(1)
        imshow(img_bg,[0,255])
        figure(2)
        imshow(img_bg_up,[0,255])
       
        % disp('creating background finished.')
        %% 生成目标 + 背景融合 
        [m, n] = size(img_bg_up);  % 背景图像尺寸

        % 如果target_num设成每条序列帧随机的，则随机生成本条序列帧的包含的目标数
        switch target_num_mode
            case 'random_num'
                random_for_target_num = rand;
                if random_for_target_num < 0.33
                    target_num = 3;
                elseif random_for_target_num > 0.67
                    target_num = 2;
                else
                    target_num = 1;
                end
        end

        % 随机生成每个目标的初始位置、大小、轨迹方向
        target_init_pos = zeros(target_num, 2);
        target_size = [];
        target_track = [];  
        for i = 1 : target_num
            target_init_pos(i, 1) = fix(m * rand(1));
            target_init_pos(i, 2) = fix(n * rand(1));

            random = rand;
            if random > 0.5
                target_size= [target_size target_size_kinds(1)];
            else
                target_size = [target_size target_size_kinds(2)];
            end

            if random < 0.125
                target_track = [target_track 1];
            elseif random >= 0.125 && random < 0.25
                target_track = [target_track 2];
            elseif random >= 0.25 && random < 0.375
                target_track = [target_track 3];
            elseif random >= 0.375 && random < 0.5
                target_track = [target_track 4];
            elseif random >= 0.5 && random < 0.625
                target_track = [target_track 5];
            elseif random >= 0.625 && random < 0.75
                target_track = [target_track 6];
            elseif random >= 0.75 && random < 0.875
                target_track = [target_track 7];
            else
                target_track = [target_track 8];
            end
        end
        
        target_size_keep = target_size;
        target_size = up_ratio * target_size;   % 对目标大小按上采样倍数放大

        % 生成序列帧
        for i = 0 : frame_num - 1

            img_bg_up = add_noise(img_bg_keep, noise_mean, noise_var, noise_lambda, hot_pixel_prob, hot_pixel_num, hot_pixel_val);  % 背景加噪

            target_pos = zeros(target_num, 2);  % 记录每个目标位置的矩阵
            target_mag = [];  % 记录每个目标中心灰度值的向量

            for j = 1 : target_num
                % 设置目标运动轨迹
                [x, y] = set_track(target_track(j), up_ratio*i, target_speed, target_init_pos(j, 1), target_init_pos(j, 2));   % 要再看一下上采样之后的图片，目标速度是不是也要成倍改变，可能需要将速度设置成一个变量
                target_pos(j, 1) = x;
                target_pos(j, 2) = y;

                % 计算目标中心灰度值
                mag = calculate_mag(target_SNR, img_bg_up, target_pos(j, 1), target_pos(j, 2), target_size_keep(j));
                target_mag = [target_mag mag];
            end

            % 生成目标
            target = create_target_gaussian_stay(target_num, target_size, target_pos, target_mag, up_ratio, m, n);   % 将此函数参数改为传入向量

            % 目标背景融合
            fuse_result = fuse_add(target, img_bg_up);  % 储存图片结果前的最后一步，这里面含有mat2gray图片归一化操作，后面imwrite会有像素值自动乘255

            % 一维滤波去噪
            if noise_filt
                fuse_result = MedFilt_1d(fuse_result);
            end
            
            % 图片下采样
            fuse_result_down = imresize(fuse_result, 1/up_ratio, 'bilinear');
%             figure(3)
%             imshow(fuse_result, [0,255])
%             figure(4)
%             imshow(fuse_result_down, [0,255])
            
            % 转换target_pos到原图尺度
            target_pos_down = floor(target_pos / up_ratio) + mod(target_pos, up_ratio) * (1 / up_ratio);
            
            % 再次加噪（下采样好像会有降噪的效果）
            fuse_result_down = add_noise(fuse_result_down, noise_mean, noise_var);
            fuse_result_down = mat2gray(fuse_result_down, [0, 255]);
            
            % 输出目标位置标签
            % [status, msg, msgID] = mkdir(trainlabel_save_path, num2str(group_num-1));
            % folder_path = strcat(trainlabel_save_path, strcat(num2str(group_num), '/'));
            label_path = strcat(label_save_path, strcat(num2str(group_num-1), '.txt'));
            output_label(label_path, i, target_num, target_pos_down, target_size_keep, m_ori, n_ori);

            % 储存图片
        %     save_name = strcat('target', strcat(num2str(i),'.jpg'));
        %     imwrite(target, strcat(save_path, save_name));
            [status, msg, msgID] = mkdir(data_save_path, num2str(group_num-1));
            img_save_path = strcat(data_save_path, strcat(num2str(group_num-1), '/'));
            save_name = strcat(num2str(i), '.png');
            imwrite(fuse_result_down, strcat(img_save_path, save_name));
            %figure(1);
            %imshow(Im);
        end
        img_save_path
    else
        %% 获得背景
        % disp('creating background......')
        switch simu_type
            case 'pure'
                if strcmp(star_create_method, 'rand')
                    img_bg = create_star_gaussian_custom(star_num, img_height, img_width);  % 生成随机背景
                elseif strcmp(star_create_method, 'sao')
                    img_bg = create_star_sao(Ra, Dec, uFOV, vFOV, k, pixel, min_star_num_thre);  % 基于sao星表生成背景
                end
                if make_non_uniform_bg
                    non_uniform_bg = non_uniform(non_uniform_min_gray, non_uniform_max_gray, non_uniform_x0, non_uniform_y0, non_uniform_mode, img_height, img_width);
                    img_bg = img_bg + non_uniform_bg;
                end
                img_bg_keep = img_bg;
            case 'half_phy'
                backImRead = imread('../image/img2.jpg');
                img_bg = backImRead(:,:,1);
        end
        % disp('creating background finished.')
        %% 生成目标 + 背景融合 
        [m, n] = size(img_bg);  % 背景图像尺寸

        % 如果target_num设成每条序列帧随机的，则随机生成本条序列帧的包含的目标数
        switch target_num_mode
            case 'random_num'
                random_for_target_num = rand;
                if random_for_target_num < 0.33
                    target_num = 3;
                elseif random_for_target_num > 0.67
                    target_num = 2;
                else
                    target_num = 1;
                end
        end

        % 随机生成每个目标的初始位置、大小、轨迹方向
        target_init_pos = zeros(target_num, 2);
        target_size = [];
        target_track = [];  
        for i = 1 : target_num
            target_init_pos(i, 1) = fix(m * rand(1));
            target_init_pos(i, 2) = fix(n * rand(1));

            random = rand;
            if random > 0.5
                target_size= [target_size target_size_kinds(1)];
            else
                target_size = [target_size target_size_kinds(2)];
            end

            if random < 0.125
                target_track = [target_track 1];
            elseif random >= 0.125 && random < 0.25
                target_track = [target_track 2];
            elseif random >= 0.25 && random < 0.375
                target_track = [target_track 3];
            elseif random >= 0.375 && random < 0.5
                target_track = [target_track 4];
            elseif random >= 0.5 && random < 0.625
                target_track = [target_track 5];
            elseif random >= 0.625 && random < 0.75
                target_track = [target_track 6];
            elseif random >= 0.75 && random < 0.875
                target_track = [target_track 7];
            else
                target_track = [target_track 8];
            end
        end

        % 生成序列帧
        for i = 0 : frame_num - 1

            img_bg = add_noise(img_bg_keep, noise_mean, noise_var, noise_lambda, hot_pixel_prob, hot_pixel_num, hot_pixel_val);  % 背景加噪

            target_pos = zeros(target_num, 2);  % 记录每个目标位置的矩阵
            target_mag = [];  % 记录每个目标中心灰度值的向量

            for j = 1 : target_num
                % 设置目标运动轨迹
                [x, y] = set_track(target_track(j), i, target_speed, target_init_pos(j, 1), target_init_pos(j, 2));
                target_pos(j, 1) = x;
                target_pos(j, 2) = y;

                % 计算目标中心灰度值
                mag = calculate_mag(target_SNR, img_bg, target_pos(j, 1), target_pos(j, 2), target_size(j));
                target_mag = [target_mag mag];
            end

            % 生成目标
            target = create_target_gaussian(target_num, target_size, target_pos, target_mag, m, n);   % 将此函数参数改为传入向量

            % 目标背景融合
            fuse_result = fuse_add(target, img_bg);  % 储存图片结果前的最后一步，这里面含有mat2gray图片归一化操作，后面imwrite会有像素值自动乘255

            % 一维滤波去噪
            if noise_filt
                fuse_result = MedFilt_1d(fuse_result);
            end

            % 输出目标位置标签
            % [status, msg, msgID] = mkdir(trainlabel_save_path, num2str(group_num-1));
            % folder_path = strcat(trainlabel_save_path, strcat(num2str(group_num), '/'));
            label_path = strcat(label_save_path, strcat(num2str(group_num-1), '.txt'));
            output_label(label_path, i, target_num, target_pos, target_size, m, n);

            % 储存图片
        %     save_name = strcat('target', strcat(num2str(i),'.jpg'));
        %     imwrite(target, strcat(save_path, save_name));
            [status, msg, msgID] = mkdir(data_save_path, num2str(group_num-1));
            img_save_path = strcat(data_save_path, strcat(num2str(group_num-1), '/'));
            save_name = strcat(num2str(i), '.png');
            imwrite(fuse_result, strcat(img_save_path, save_name));
            %figure(1);
            %imshow(Im);
        end
        img_save_path
   end
end
