function bgImg = J2000_to_picture(FOVstar,a,b,k,f,pixel)
%�õ�������ͼ�ϵ�λ����Ϣ���ǵȻҶ�ֵ
%star_fplace--���ӳ��ĺ���λ�ã�star_fVT--���ӳ��ĺ����ǵȣ�a,b,k,f--��������ָ����ת�ǣ����࣬m,n--��Ƭ�߿�
constants;
bgImg = zeros(pixel, pixel);  % ���ڱ�������
ar = a/180*DPI;br = b/180*DPI;kr = k/180*DPI;%deg to rad
FOVstar = table2array(FOVstar);
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

%���ӵ���ɢģ�͵ĻҶ�ֵ
%     for row = 1 : 1 : pixel
%         for col = 1 : 1 : pixel
%             bgImg( row, col ) = ( row - xf ).^2 + ( col - yf ).^2;
%         end
%     end
%     bgImg = -bgImg / ( 2 * 0.405^2 );
%     bgImg = exp(bgImg);

    if (FOVstar(i,2) >= 8)
        mag = 255/(2.51^(FOVstar(i,2)-7.5));  % ���ǻҶ�ֵ
    else
        mag = 255;
    end
    
%     bgImg = mag * bgImg;
    
    for m = -1:1
        for n = -1:1
            if (ceil(yf)+m)>0 && (ceil(yf)+m)<=pixel && (ceil(xf)+n)>0 && (ceil(xf)+n)<=pixel
                imag = mag*exp(-(m^2+n^2)/0.405);
                if bgImg(ceil(yf)+m, ceil(xf)+n)<imag
                    bgImg(ceil(yf)+m, ceil(xf)+n) = imag;
                end
            end
        end
    end 
end

end
