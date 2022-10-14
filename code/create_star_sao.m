function bgImg = create_star_sao(Ra, Dec, uFOV, vFOV, k, pixel)

load('sao.mat')
global sao1;
sao1 = sao;
%星敏感器指向,视角，半角，旋转角，分辨率，焦距,deg
% a = 5.2;b = 4.9;
a = Ra;b = Dec;
% uFOV = 4.8;vFOV = 4.8;
R = sqrt(uFOV*uFOV+vFOV*vFOV)/2;
% k = 0;
% pixel = 256;
constants;f = pixel/(2*tan((uFOV/180*DPI)/2));

%根据星敏感器经纬和视角选取恒星
FOVstar =star_Find(a,b,R,sao1);

%得到恒星在星图上的位置及星等灰度值
bgImg = J2000_to_picture(FOVstar,a,b,k,f,pixel);

%得到背景星图
bgImg = uint8(bgImg);
%img_out = uint8((double((bgImg)/65535)*255));
%img_out = mat2gray(bgImg, [0 255]);
%加入高斯噪声
% img_out = uint8(add_noise(img_in, 10, 5));
% imwrite(img_out, 'bg.png');
end
