function FOVstar =star_Find(a,b,R,sao1)
%��������������γ���ӽ�ѡȡ����
%(a,b)-����������γ��deg��,R-�ӳ���Χ��sao1-�Ǳ���Ϣ
%FOVstar-������ţ��ǵȣ�λ�ã�rad��
constants;
FOVstar = [];
[sao1row,~] = size(sao1);
a1 = a-R/cos(b/180*DPI);a2 = a+R/cos(b/180*DPI);
b1 = b-R; b2 = b+R;
for i = 1:sao1row
   if table2array(sao1(i,3))/D2PI*360>a1 && table2array(sao1(i,3))/D2PI*360<a2 && table2array(sao1(i,4))/DPI*180>b1 && table2array(sao1(i,4))/DPI*180<b2 
        FOVstar = [FOVstar;sao1(i,:)];
    end  
end
end