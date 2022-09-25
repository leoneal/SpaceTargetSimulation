function img_out = MedFilt_1d(img_in)
    %% 一维窗口大小
    W0 = 100;
    W1 = 16;
    C0 = 8;
    W_max = 64;

    %% 读取图片
    %imgPath = '0.png';
    %imgPath = './image/3.jpg';
    %img0 = imread(imgPath);
    % img0 = rgb2gray(img0);
    
    img0 = img_in;
    img0=im2double(img0);
    %figure(1);
    %imshow(img0);
   
    % img0 = medfilt2(img0); % 第0次中值滤波 二维中值滤波 去除离散噪声
    % figure(2);
    % imshow(img0);

    % imgBg1 = img0;

    %% 第一次中值滤波
    imgBg1 = medfilt1(img0, W0); % 背景估计图像
%     figure(3);
%     imshow(imgBg1);
    % imwrite(imgBg1, './image/dev1/imgBg1.jpg');

    img1 = abs(img0 - imgBg1); % 第一次减除非均匀性噪声背景后的图像
%     figure(4);
%     imshow(img1);
    % imwrite(img1, './image/dev1/img1.jpg');

    avg = mean2(img1); % 图像的均值

    %% 第二次中值滤波
    imgBg2 = medfilt1(img1,W1);

% %     figure(5);
% %     imshow(imgBg2);

    img2 = abs(img1 - imgBg2);
%     figure(6);
%     imshow(img2);
    % imwrite(img2, './image/dev1/img2.jpg');

    %% 第三次中值滤波
    imgBg3 = medfilt1(img2, W1/2); 
%     figure(7);
%     imshow(imgBg3);

    img3 = abs(img2 - imgBg3); 
%     figure(8);
%     imshow(img3);
    %% 第4次中值滤波
%     imgBg4 = medfilt1(img3, W1/4); 
%     %     figure(7);
%     %     imshow(imgBg3);
% 
%     img4 = abs(img3 - imgBg4); 
%     %     figure(8);
%     %     imshow(img3);
    %% 输出
    img_out = img3;
end