function [bgImg, err_flag] = J2000_to_picture(FOVstar,a,b,k,f,pixel)
%�õ�������ͼ�ϵ�λ����Ϣ���ǵȻҶ�ֵ
%star_fplace--���ӳ��ĺ���λ�ã�star_fVT--���ӳ��ĺ����ǵȣ�a,b,k,f--��������ָ����ת�ǣ����࣬m,n--��Ƭ�߿�
constants;
bgImg = zeros(pixel, pixel);  % ���ڱ�������
ar = a/180*DPI;br = b/180*DPI;kr = k/180*DPI;%deg to rad

err_flag = isempty(FOVstar);
if err_flag
    return
end
    
% try
%     FOVstar = table2array(FOVstar);
% catch MException
%     disp(MException);
%     disp('�������');
%     err_flag = true;
% end

m11 = sin(ar)*cos(kr)+cos(ar)*sin(br)*sin(kr);
m12 = cos(ar)*cos(kr)-sin(ar)*sin(br)*sin(kr);
m13 = -cos(br)*sin(kr);
m21 = sin(ar)*sin(kr)-cos(ar)*sin(br)*cos(kr);
m22 = cos(ar)*sin(kr)+sin(ar)*sin(br)*cos(kr);
m23 = cos(br)*cos(kr);
m31 = cos(ar)*cos(br);
m32 = -sin(ar)*cos(br);
m33 = sin(br);

au = cos(ar)*cos(br);
av = cos(br)*sin(ar);
aw = sin(br);
x0 = f*(m11*au+m12*av+m13*aw)/(m31*au+m32*av+m33*aw);
y0 = f*(m21*au+m22*av+m23*aw)/(m31*au+m32*av+m33*aw);

target_size_arr = [3, 5, 7];
sigma_arr = [0, 0, 1, 0, 2.5, 0, 3, 0, 0]; % ��ͬ��СĿ��ı�׼������±��ӦĿ���С

[FOVstarrow,~] = size(FOVstar);

for i = 1:FOVstarrow
    u = cos(FOVstar(i,4))*cos(FOVstar(i,3));
    v = cos(FOVstar(i,4))*sin(FOVstar(i,3));
    w = sin(FOVstar(i,4));
    x = f*(m11*u+m12*v+m13*w)/(m31*u+m32*v+m33*w);
    y = f*(m21*u+m22*v+m23*w)/(m31*u+m32*v+m33*w);
    
    xf = (x-x0)/1.5+pixel/2;
    yf = (y-y0)/1.5+pixel/2;
    
%     xf = (x-6*pixel/5)*1.25;
%     yf = (y+2*pixel/5)*1.25; %������ͼ�е�λ��
%δ���ӵ���ɢģ�͵ĻҶ�ֵ
%     if 0<xf && xf<=pixel && 0<yf && yf<=pixel
%         if (FOVstar(i,2) >= 8) 
%             mag = 255/(2.51^(FOVstar(i,2)-8));  % ���ǻҶ�ֵ
%         else
%             mag = 255;
%         end
%         if bgImg(ceil(yf), ceil(xf))<mag
%             bgImg(ceil(yf), ceil(xf)) = mag;
%         end
%     end

    rand_num = rand(1);
    % �������Ǵ�С���ɣ�80% 3x3, 15% 5x5, 5% 7x7
    if rand_num > 0.85
        idx = 2;
    elseif rand_num < 0.05
        idx = 3;
    else
        idx = 1;
    end
    target_size = target_size_arr(idx);  % ���Ŀ���С
    sigma = sigma_arr(target_size);

%���ӵ���ɢģ�͵ĻҶ�ֵ
    if (FOVstar(i,2) >= 8)
        mag = 255/(2.51^(FOVstar(i,2)-7.5));  % ���ǻҶ�ֵ
    else
        mag = 255;
    end
    
    % m n: һ���ǵ�����Χ
    for m = -3:3
        for n = -3:3
            if (ceil(yf)+m)>0 && (ceil(yf)+m)<=pixel && (ceil(xf)+n)>0 && (ceil(xf)+n)<=pixel
                imag = mag*exp(-(m^2+n^2)/sigma);
                if bgImg(ceil(yf)+m, ceil(xf)+n)<imag
                    bgImg(ceil(yf)+m, ceil(xf)+n) = imag;
                end
            end
        end
    end 
end

end
