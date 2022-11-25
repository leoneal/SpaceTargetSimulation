function bgImg = create_star_sao(Ra, Dec, uFOV, vFOV, k, pixel, min_star_num_thre)

    load('sao.mat')
    global sao1;
    sao1 = sao;

    %星敏感器指向范围
    a_min = -Ra;
    a_max = Ra;
    b_min = -Dec;
    b_max = Dec;
    % 视角
    % uFOV = 3;
    % vFOV = 3;
    % 半角
    R = sqrt(uFOV*uFOV+vFOV*vFOV)/2;
    % 旋转角
    % k = 0;
    % 分辨率
    % pixel = 256;
    % 焦距
    constants;f = pixel/(2*tan((uFOV/180*DPI)/2));

    % 星表预过滤
    filted_sao = SAO_pre_filter(sao1, a_max, a_min, b_max, b_min, uFOV, vFOV);

    % 寻找视场里包含足够多恒星的区域，并返回其中的恒星
    m = 0;
    while m < min_star_num_thre
        rng('shuffle');

        a = randi([a_min,a_max]);
        b = randi([b_min,b_max]);

        %根据星敏感器经纬和视角选取恒星
        FOVstar =star_Find(a,b,R,filted_sao);
        [m, ~] = size(FOVstar);
    end

    %得到恒星在星图上的位置及星等灰度值
    [bgImg, ~] = J2000_to_picture(FOVstar,a,b,k,f,pixel);
    
    %得到背景星图
    bgImg = uint8(bgImg);

end
