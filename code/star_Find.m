function FOVstar =star_Find(a,b,R,filted_sao)
    %��������������γ���ӽ�ѡȡ����
    %(a,b)-����������γ��deg��,R-�ӳ���Χ��sao1-�Ǳ���Ϣ
    %FOVstar-������ţ��ǵȣ�λ�ã�rad��
    constants;
    FOVstar = [];
    [m,~] = size(filted_sao);
    a1 = a-R/cos(b/180*DPI);
    a2 = a+R/cos(b/180*DPI);
    b1 = b-R; 
    b2 = b+R;
    % for i = 1:m
    %    if table2array(sao1(i,3))/D2PI*360>a1 && table2array(sao1(i,3))/D2PI*360<a2 && table2array(sao1(i,4))/DPI*180>b1 && table2array(sao1(i,4))/DPI*180<b2 
    %         FOVstar = [FOVstar;sao1(i,:)];
    %     end  
    % end
    filted_sao_cut_3 = filted_sao(:, 3);
    filted_sao_cut_3_deg = filted_sao_cut_3 / D2PI*360;
    row3 = filted_sao_cut_3_deg > a1 & filted_sao_cut_3_deg < a2;
    filted_sao1 = filted_sao(row3, :);
    
    filted_sao1_cut_4 = filted_sao1(:, 4);
    filted_sao1_cut_4_deg = filted_sao1_cut_4 / D2PI*360;
    row4 = filted_sao1_cut_4_deg > b1 & filted_sao1_cut_4_deg < b2;
    FOVstar = filted_sao1(row4, :);

end