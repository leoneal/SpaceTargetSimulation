%% 对目标和背景进行线性相加
function img_out = fuse_add(target_img, bg_img)
    % 调试参数
%     target_img = imread('target.jpg');
%     bg_img = imread('bg+noise.jpg');
    
%     figure(1)
%     imshow(target_img);
%     figure(2)
%     imshow(bg_img);

    img_out = target_img + bg_img;
    img_out = uint8(img_out);
    %img_out = uint8((double(img_out)/65535)*255);
    %img_out = mat2gray(img_out, [0 255])
    imwrite(img_out, 'target+bg+noise.png')
    % img = imread('target+bg+noise.png');
    
%     figure(3)
%     imshow(img_out);
end