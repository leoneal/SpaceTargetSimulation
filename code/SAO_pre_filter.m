function filted_SAO = SAO_pre_filter(SAO, a_max, a_min, b_max, b_min, uFOV, vFOV)
    constants;
    
    SAO_arr = table2array(SAO);
    
    SAO_arr_cut_3 = SAO_arr(:, 3);
    SAO_arr_cut_3_deg = SAO_arr_cut_3 / D2PI*360;
    row3 = (SAO_arr_cut_3_deg > a_min - uFOV) & (SAO_arr_cut_3_deg < a_max + uFOV);
    filted_SAO_arr = SAO_arr(row3,:);
    
    filted_SAO_arr_cut_4 = filted_SAO_arr(:, 4);
    filted_SAO_arr_cut_4_deg = filted_SAO_arr_cut_4 / D2PI*360;
    row4 = (filted_SAO_arr_cut_4_deg >= b_min - vFOV) & (filted_SAO_arr_cut_4_deg <= b_max + vFOV);
    filted_SAO = filted_SAO_arr(row4, :);

end
