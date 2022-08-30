%% 根据星等计算灰度值

function mag = sl2mag(star_level)
    % star_level = 23;
    % mag = 16777216 / 2.51^(star_level - 5);
    mag = 255 / 2.51^(star_level - 20);
end