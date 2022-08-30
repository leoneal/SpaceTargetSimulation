%% 得到纯黑背景下照片
%% m, n为要融合的背景图片的高和宽，x，y为目标位置，tag为目标灰度值0-255
%% im为照片矩阵 大小为480x640

function im = dim(m, n, x, y, tag)
% im = zeros(480,640);
im = zeros(m, n);
high = 12.8;   %CCD靶面的高度 单位mm
width = 9.6;   %CCD靶面宽度 单位mm
d = 9.6 / n;   %CCD单元宽度
center = 0.5;  %中心
%tag = 250;
% for i = 1:480
%     for j =1:640
%         temp=sqrt(((i+center-x))^2+((j+center-y))^2);
%         %z=sqrt(F^2+temp^2)-F; 
%         rate(i,j)=h(temp);
%     end
% end

for i = 1 : m
    for j =1 : n
        distance = sqrt(((i + center - x)) ^ 2 + ((j + center - y)) ^ 2);
        %z=sqrt(F^2+temp^2)-F;
        rate(i, j) = h(distance);
    end
end

% rate = zeros(m, n);
% for i = x : x + high
%     for j =y : y + width
%         distance = sqrt(((i + center - x)) ^ 2 + ((j + center - y)) ^ 2);
%         %z=sqrt(F^2+temp^2)-F;
%         rate(i, j) = h(distance);
%     end
% end

im = tag * rate / (sum(sum(rate)));
imshow(im);
% map=imread('19.jpg');
% m=double(map(:,:,1));
% m1=m+im;
% imshow(m1,[0,255]);
% im = m1;
end

