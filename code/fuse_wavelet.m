%% �Դ��ڱ����õ��ĵ���ɢЧӦ���������������ں�
%% 

function im = fuse_wavelet(m1,m2)
%%%����С���任��ͼ������ں�
zt= 4; % С���ֽ�Ĳ���
wtype = 'haar'; % С��������
[c0,s0] = wavedec2(m1, zt, wtype);%��߶ȶ�άС���ֽ�
[c1,s1] = wavedec2(m2, zt, wtype);%��߶ȶ�άС���ֽ�

%%%%%%%%%%
KK = size(c1);
Coef_Fusion = zeros(1,KK(2));
Temp = zeros(1,2);
Coef_Fusion(1:s1(1,1)) = (c0(1:s1(1,1))+c1(1:s1(1,1)))/2;  %��Ƶϵ���Ĵ���
                     %���������Ƶϵ��һ�����ˣ����Ǻ��洦���Ƶϵ����ʱ�򣬻Ὣ������ǣ�����û�й�ϵ

   %�����Ƶϵ��
    MM1 = c0(s1(1,1)+1:KK(2));
    MM2 = c1(s1(1,1)+1:KK(2));
    mm = (abs(MM1)) > (abs(MM2));
  	Y  = (mm.*MM1) + ((~mm).*MM2);
    Coef_Fusion(s1(1,1)+1:KK(2)) = Y;
    %�����Ƶϵ��end
 
 %�ع�
 Y = waverec2(Coef_Fusion,s0,wtype);
 

%��ʾͼ��  
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
% title('�ں�ͼ��');
im = Y;
% axis square;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%