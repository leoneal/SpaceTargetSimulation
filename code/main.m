%% �ռ�Ŀ�꼰������ͼ����

%% �������
simu_type = 'pure';  % �������� 'pure'��������; 'half_phy'�����������

target_num = 3;  % �趨�ӳ�������Ŀ��ĸ���
target_size_kinds = [3 5];  % ����Ŀ������п��ܴ�С
target_SNR = 3;  % �趨Ŀ������ȣ���������������
target_starLevel = 10;  % �趨Ŀ���ǵ�
target_track_kinds = ['l2r' 'r2l' 'u2d' 'd2u' 'lu2rd' 'ld2ru' 'ru2ld' 'rd2lu']; % �趨Ŀ��켣 l2r:������ 
                                                                                % ���ڻ�Ӧʵ�ָ������ǹ������ʵ�����ù켣�Ĺ���
pix_move = 10;  % �趨Ŀ������Ƴ��ȣ�����Ϊ��֡��Ŀ�����Ƶĳ��ȣ�����Χ4-10������ģ��Ŀ��Ĳ�ͬ����ٶ�
target_create_method = 1;  % �趨����Ŀ���ģ�ͣ�1����˹ģ�ͣ�2�������ģ��

star_num = 50;  % �趨�ӳ������ɺ��ǵĸ��� �������������Ǳ���治��Ҫ���������
fuse_method = 1;  % �趨Ŀ���뱳���ںϵķ�ʽ��1�����Ե����ںϣ�2��С���ں�

frame_num = 5;  % �����֡��
noise_mean = 10;  %����������ֵ
noise_var = 15;  % ������������
img_height = 256;  % ����ͼƬ�ĸ�
img_width = 256;  % ����ͼƬ�Ŀ�

train_save_path = 'E:/KeTi/SpTarSim/code/SimuSystem/result/pure_sim/train/';
traindata_save_path = strcat(train_save_path, strcat('series_frames/', strcat('snr',num2str(target_SNR))));
traindata_save_path = strcat(traindata_save_path, '/');
trainlabel_save_path = strcat(train_save_path, strcat('labels/', strcat('snr',num2str(target_SNR))));
trainlabel_save_path = strcat(trainlabel_save_path, '/');

train_group_num = 1300;
val_group_num = 100;
test_group_num = 200;

%% ��ѭ��
for group_num = 1 : train_group_num
    %% ��ñ���
    switch simu_type
        case 'pure'
            img_bg = create_star_gaussian_custom(star_num, img_height, img_width);  % ���ɱ���
            img_bg = add_noise(img_bg, noise_mean, noise_var);  % ��������
        case 'half_phy'
            backImRead = imread('../image/img2.jpg');
            img_bg = backImRead(:,:,1);
    end
    %% ����Ŀ�� + �����ں� 
    [m, n] = size(img_bg);  % ����ͼ��ߴ�

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

        target_pos = zeros(target_num, 2);  % ��¼ÿ��Ŀ��λ�õľ���
        target_mag = [];  % ��¼ÿ��Ŀ�����ĻҶ�ֵ������

        for j = 1 : target_num
            % ����Ŀ���˶��켣
            [x, y] = set_track(target_track(j), i, target_init_pos(j, 1), target_init_pos(j, 2));
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
        
        % ���Ŀ��λ�ñ�ǩ
        % [status, msg, msgID] = mkdir(trainlabel_save_path, num2str(group_num-1));
        % folder_path = strcat(trainlabel_save_path, strcat(num2str(group_num), '/'));
        label_path = strcat(trainlabel_save_path, strcat(num2str(group_num-1), '.txt'));
        output_label(label_path, i, target_num, target_pos, target_size, m, n);
        
        % ����ͼƬ
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
