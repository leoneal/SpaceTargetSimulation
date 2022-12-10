function FOVstar =star_Find(a,b,R,sao1)
%根据星敏感器经纬和视角选取恒星
%(a,b)-星敏感器经纬（deg）,R-视场范围，sao1-星表信息
%FOVstar-恒星序号，星等，位置（rad）
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