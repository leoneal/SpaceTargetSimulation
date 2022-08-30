%% 对纯黑背景得到的点扩散效应与所给背景进行融合
%% 

function im = fuse_wavelet(m1,m2)
%%%运用小波变换对图像进行融合
zt= 4; % 小波分解的层数
wtype = 'haar'; % 小波基函数
[c0,s0] = wavedec2(m1, zt, wtype);%多尺度二维小波分解
[c1,s1] = wavedec2(m2, zt, wtype);%多尺度二维小波分解

%%%%%%%%%%
KK = size(c1);
Coef_Fusion = zeros(1,KK(2));
Temp = zeros(1,2);
Coef_Fusion(1:s1(1,1)) = (c0(1:s1(1,1))+c1(1:s1(1,1)))/2;  %低频系数的处理
                     %这儿，连高频系数一起处理了，但是后面处理高频系数的时候，会将结果覆盖，所以没有关系

   %处理高频系数
    MM1 = c0(s1(1,1)+1:KK(2));
    MM2 = c1(s1(1,1)+1:KK(2));
    mm = (abs(MM1)) > (abs(MM2));
  	Y  = (mm.*MM1) + ((~mm).*MM2);
    Coef_Fusion(s1(1,1)+1:KK(2)) = Y;
    %处理高频系数end
 
 %重构
 Y = waverec2(Coef_Fusion,s0,wtype);
 

%显示图像  
% subplot(2,2,1);imshow(im);
% colormap(gray);
% title('input2');
% axis square  
%  
% subplot(2,2,2);imshow(m,[0,255]);
% colormap(gray);
% title('input2');
% axis square  

% imshow(Y,[]);
% colormap(gray);
% title('融合图像');
im = Y;
% axis square;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%