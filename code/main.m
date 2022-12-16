%% �ռ�Ŀ�꼰������ͼ����

%% �������
simu_type = 'pure';  % �������� 'pure'��������; 'half_phy'�����������
dataset_type = 'val';  % Ҫ���ɵ����ݼ����ͣ�'train' 'test' 'val'

frame_num = 8;  % �����֡��
noise_mean = 10;  %������˹������ֵ
noise_var = 15;  % ������˹��������
noise_lambda = 20;  % �������������Ĳ���
hot_pixel_prob = 0.2;  % �����м��������������ĸ���
hot_pixel_num = 2; % �����������صĸ���
hot_pixel_val = 200; % �����������ص�����ֵ
make_non_uniform_bg = false;  % �趨�Ƿ�Ҫ�ڱ�������ӷǾ�����ɢ��
non_uniform_mode = 'gaussian';  % �����ӹ�ķֲ�ģʽ: 'linear' 'gaussian'
non_uniform_min_gray = 30;  % ���������ӹ����С�Ҷ�
non_uniform_max_gray = 100;  % ���������ӹ�����Ҷ�
non_uniform_x0 = 120;  % ������˹�ӹ������x����
non_uniform_y0 = -60;  % ������˹�ӹ������y����
noise_filt = false;  % �Ƿ����ǰȥ��
img_height = 256;  % ����ͼƬ�ĸ�
img_width = 256;  % ����ͼƬ�Ŀ�

target_stay = false;  % �趨�Ƿ���Ҫ����Ŀ������Ԫ�ϵ�פ��Ч��
up_ratio = 4;  % ������Ԫפ��ʱ��ͼƬ�ϲ����ı���
target_num_mode = 'fixed_num';  % 'random_num' or 'fixed_num'
target_num = 1;  % �趨�ӳ�������Ŀ��ĸ��� 
target_size_kinds = [3 5];  % ����Ŀ������п��ܴ�С
target_SNR = 3;  % �趨Ŀ������ȣ���������������
target_starLevel = 10;  % �趨Ŀ���ǵ�
target_track_kinds = ['l2r' 'r2l' 'u2d' 'd2u' 'lu2rd' 'ld2ru' 'ru2ld' 'rd2lu']; % �趨Ŀ��켣 l2r:������ 
                                                                                % ���ڻ�Ӧʵ�ָ������ǹ������ʵ�����ù켣�Ĺ���
target_speed = [1 1];  % �趨Ŀ���x��y������˶��ٶȣ����ں�֡����ˣ�                                                                       
pix_move = 10;  % �趨Ŀ������Ƴ��ȣ�����Ϊ��֡��Ŀ�����Ƶĳ��ȣ�����Χ4-10������ģ��Ŀ��Ĳ�ͬ����ٶ�
target_create_method = 1;  % �趨����Ŀ���ģ�ͣ�1����˹ģ�ͣ�2�������ģ��

star_create_method = 'sao';  % ���ɷ��汳���ķ�ʽ��'sao'������sao�Ǳ����ɣ�'rand':���λ������
star_num = 50;  % �趨�ӳ������ɺ��ǵĸ��� �������������Ǳ���治��Ҫ���������
min_star_num_thre = 30;
Ra = 5;  % ��������ָ��ྭ
Dec = 5;  % ��������ָ���γ
uFOV = 3;  % �ӳ���
vFOV = 3;  % �ӳ���
k = 0;  % ��ת��
pixel = img_height;  % �����ֱ���
fuse_method = 1;  % �趨Ŀ���뱳���ںϵķ�ʽ��1�����Ե����ںϣ�2��С���ں�

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

%% ��ѭ��
rng('shuffle');
for group_num = 1 : max_group_num
    % ���ж��Ƿ�Ҫ����Ŀ��פ��Ч��
    if target_stay
        %% ��ñ���
        % disp('creating background......')
        switch simu_type
            case 'pure'
                if strcmp(star_create_method, 'rand')
                    img_bg = create_star_gaussian_custom(star_num, img_height, img_width);  % �����������
                elseif strcmp(star_create_method, 'sao')
                    img_bg = create_star_sao(Ra, Dec, uFOV, vFOV, k, pixel, min_star_num_thre);  % ����sao�Ǳ����ɱ���
                end
                if make_non_uniform_bg
                    non_uniform_bg = non_uniform(non_uniform_min_gray, non_uniform_max_gray, non_uniform_x0, non_uniform_y0, non_uniform_mode, img_height, img_width);
                    img_bg = img_bg + non_uniform_bg;
                end
            case 'half_phy'
                backImRead = imread('../image/img2.jpg');
                img_bg = backImRead(:,:,1);
        end
        
        [m_ori, n_ori] = size(img_bg);  % ԭʼ����ͼ��ߴ�
        
        % ������ͼ���ϲ���
        img_bg_up = imresize(img_bg, up_ratio, 'bilinear');  
        img_bg_keep = img_bg_up;
        figure(1)
        imshow(img_bg,[0,255])
        figure(2)
        imshow(img_bg_up,[0,255])
       
        % disp('creating background finished.')
        %% ����Ŀ�� + �����ں� 
        [m, n] = size(img_bg_up);  % ����ͼ��ߴ�

        % ���target_num���ÿ������֡����ģ���������ɱ�������֡�İ�����Ŀ����
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

        % �������ÿ��Ŀ��ĳ�ʼλ�á���С���켣����
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
        target_size = up_ratio * target_size;   % ��Ŀ���С���ϲ��������Ŵ�

        % ��������֡
        for i = 0 : frame_num - 1

            img_bg_up = add_noise(img_bg_keep, noise_mean, noise_var, noise_lambda, hot_pixel_prob, hot_pixel_num, hot_pixel_val);  % ��������

            target_pos = zeros(target_num, 2);  % ��¼ÿ��Ŀ��λ�õľ���
            target_mag = [];  % ��¼ÿ��Ŀ�����ĻҶ�ֵ������

            for j = 1 : target_num
                % ����Ŀ���˶��켣
                [x, y] = set_track(target_track(j), up_ratio*i, target_speed, target_init_pos(j, 1), target_init_pos(j, 2));   % Ҫ�ٿ�һ���ϲ���֮���ͼƬ��Ŀ���ٶ��ǲ���ҲҪ�ɱ��ı䣬������Ҫ���ٶ����ó�һ������
                target_pos(j, 1) = x;
                target_pos(j, 2) = y;

                % ����Ŀ�����ĻҶ�ֵ
                mag = calculate_mag(target_SNR, img_bg_up, target_pos(j, 1), target_pos(j, 2), target_size_keep(j));
                target_mag = [target_mag mag];
            end

            % ����Ŀ��
            target = create_target_gaussian_stay(target_num, target_size, target_pos, target_mag, up_ratio, m, n);   % ���˺���������Ϊ��������

            % Ŀ�걳���ں�
            fuse_result = fuse_add(target, img_bg_up);  % ����ͼƬ���ǰ�����һ���������溬��mat2grayͼƬ��һ������������imwrite��������ֵ�Զ���255

            % һά�˲�ȥ��
            if noise_filt
                fuse_result = MedFilt_1d(fuse_result);
            end
            
            % ͼƬ�²���
            fuse_result_down = imresize(fuse_result, 1/up_ratio, 'bilinear');
%             figure(3)
%             imshow(fuse_result, [0,255])
%             figure(4)
%             imshow(fuse_result_down, [0,255])
            
            % ת��target_pos��ԭͼ�߶�
            target_pos_down = floor(target_pos / up_ratio) + mod(target_pos, up_ratio) * (1 / up_ratio);
            
            % �ٴμ��루�²���������н����Ч����
            fuse_result_down = add_noise(fuse_result_down, noise_mean, noise_var);
            fuse_result_down = mat2gray(fuse_result_down, [0, 255]);
            
            % ���Ŀ��λ�ñ�ǩ
            % [status, msg, msgID] = mkdir(trainlabel_save_path, num2str(group_num-1));
            % folder_path = strcat(trainlabel_save_path, strcat(num2str(group_num), '/'));
            label_path = strcat(label_save_path, strcat(num2str(group_num-1), '.txt'));
            output_label(label_path, i, target_num, target_pos_down, target_size_keep, m_ori, n_ori);

            % ����ͼƬ
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
        %% ��ñ���
        % disp('creating background......')
        switch simu_type
            case 'pure'
                if strcmp(star_create_method, 'rand')
                    img_bg = create_star_gaussian_custom(star_num, img_height, img_width);  % �����������
                elseif strcmp(star_create_method, 'sao')
                    img_bg = create_star_sao(Ra, Dec, uFOV, vFOV, k, pixel, min_star_num_thre);  % ����sao�Ǳ����ɱ���
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
        %% ����Ŀ�� + �����ں� 
        [m, n] = size(img_bg);  % ����ͼ��ߴ�

        % ���target_num���ÿ������֡����ģ���������ɱ�������֡�İ�����Ŀ����
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

        % �������ÿ��Ŀ��ĳ�ʼλ�á���С���켣����
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

        % ��������֡
        for i = 0 : frame_num - 1

            img_bg = add_noise(img_bg_keep, noise_mean, noise_var, noise_lambda, hot_pixel_prob, hot_pixel_num, hot_pixel_val);  % ��������

            target_pos = zeros(target_num, 2);  % ��¼ÿ��Ŀ��λ�õľ���
            target_mag = [];  % ��¼ÿ��Ŀ�����ĻҶ�ֵ������

            for j = 1 : target_num
                % ����Ŀ���˶��켣
                [x, y] = set_track(target_track(j), i, target_speed, target_init_pos(j, 1), target_init_pos(j, 2));
                target_pos(j, 1) = x;
                target_pos(j, 2) = y;

                % ����Ŀ�����ĻҶ�ֵ
                mag = calculate_mag(target_SNR, img_bg, target_pos(j, 1), target_pos(j, 2), target_size(j));
                target_mag = [target_mag mag];
            end

            % ����Ŀ��
            target = create_target_gaussian(target_num, target_size, target_pos, target_mag, m, n);   % ���˺���������Ϊ��������

            % Ŀ�걳���ں�
            fuse_result = fuse_add(target, img_bg);  % ����ͼƬ���ǰ�����һ���������溬��mat2grayͼƬ��һ������������imwrite��������ֵ�Զ���255

            % һά�˲�ȥ��
            if noise_filt
                fuse_result = MedFilt_1d(fuse_result);
            end

            % ���Ŀ��λ�ñ�ǩ
            % [status, msg, msgID] = mkdir(trainlabel_save_path, num2str(group_num-1));
            % folder_path = strcat(trainlabel_save_path, strcat(num2str(group_num), '/'));
            label_path = strcat(label_save_path, strcat(num2str(group_num-1), '.txt'));
            output_label(label_path, i, target_num, target_pos, target_size, m, n);

            % ����ͼƬ
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
