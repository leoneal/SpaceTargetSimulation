%% 空间目标及背景星图仿真

%% 仿真参数
simu_type = 'pure';  % 仿真类型 'pure'：纯仿真; 'half_phy'：半物理仿真

target_num = 3;  % 设定视场里生成目标的个数
target_size_kinds = [3 5];  % 生成目标的所有可能大小
target_SNR = 3;  % 设定目标信噪比（给定背景噪声）
target_starLevel = 10;  % 设定目标星等
target_track_kinds = ['l2r' 'r2l' 'u2d' 'd2u' 'lu2rd' 'ld2ru' 'ru2ld' 'rd2lu']; % 设定目标轨迹 l2r:从左到右 
                                                                                % 后期还应实现根据卫星轨道根数实现设置轨迹的功能
pix_move = 10;  % 设定目标的像移长度（表现为单帧内目标条纹的长度），范围4-10，用来模拟目标的不同轨道速度
target_create_method = 1;  % 设定生成目标的模型，1：高斯模型，2：艾里斑模型

star_num = 50;  % 设定视场里生成恒星的个数 （半物理及基于星表仿真不需要这个参数）
fuse_method = 1;  % 设定目标与背景融合的方式，1：线性叠加融合，2：小波融合

frame_num = 5;  % 输出的帧数
noise_mean = 10;  %背景噪声均值
noise_var = 15;  % 背景噪声方差
img_height = 256;  % 生成图片的高
img_width = 256;  % 生成图片的宽

train_save_path = 'E:/KeTi/SpTarSim/code/SimuSystem/result/pure_sim/train/';
traindata_save_path = strcat(train_save_path, strcat('series_frames/', strcat('snr',num2str(target_SNR))));
traindata_save_path = strcat(traindata_save_path, '/');
trainlabel_save_path = strcat(train_save_path, strcat('labels/', strcat('snr',num2str(target_SNR))));
trainlabel_save_path = strcat(trainlabel_save_path, '/');

train_group_num = 1300;
val_group_num = 100;
test_group_num = 200;

%% 主循环
for group_num = 1 : train_group_num
    %% 获得背景
    switch simu_type
        case 'pure'
            img_bg = create_star_gaussian_custom(star_num, img_height, img_width);  % 生成背景
            img_bg = add_noise(img_bg, noise_mean, noise_var);  % 背景加噪
        case 'half_phy'
            backImRead = imread('../image/img2.jpg');
            img_bg = backImRead(:,:,1);
    end
    %% 生成目标 + 背景融合 
    [m, n] = size(img_bg);  % 背景图像尺寸

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

        target_pos = zeros(target_num, 2);  % 记录每个目标位置的矩阵
        target_mag = [];  % 记录每个目标中心灰度值的向量

        for j = 1 : target_num
            % 设置目标运动轨迹
            [x, y] = set_track(target_track(j), i, target_init_pos(j, 1), target_init_pos(j, 2));
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
        
        % 输出目标位置标签
        % [status, msg, msgID] = mkdir(trainlabel_save_path, num2str(group_num-1));
        % folder_path = strcat(trainlabel_save_path, strcat(num2str(group_num), '/'));
        label_path = strcat(trainlabel_save_path, strcat(num2str(group_num-1), '.txt'));
        output_label(label_path, i, target_num, target_pos, target_size, m, n);
        
        % 储存图片
    %     save_name = strcat('target', strcat(num2str(i),'.jpg'));
    %     imwrite(target, strcat(save_path, save_name));
        [status, msg, msgID] = mkdir(traindata_save_path, num2str(group_num-1));
        img_save_path = strcat(traindata_save_path, strcat(num2str(group_num-1), '/'));
        img_save_path
        save_name = strcat(num2str(i), '.png');
        imwrite(fuse_result, strcat(img_save_path, save_name));
        %figure(1);
        %imshow(Im);
    end
end
