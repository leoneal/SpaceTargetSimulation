%% 设置目标轨迹

function [x, y] = set_track(target_track, i, target_speed, init_x, init_y)
    %target_track
    switch target_track
        case 1 %'l2r'
            x = init_x + round(i * target_speed(1)); % 目标位置坐标x, y需要是整数，否则后面imshow会报错
            y = init_y;
        case 2  %'r2l'
            x = init_x - round(i * target_speed(1));
            y = init_y;
        case 3  %'u2d'
            x = init_x;
            y = init_y + round(i * target_speed(2));
        case 4  %'d2u'
            x = init_x;
            y = init_y - round(i * target_speed(2));
        case 5  %'lu2rd'
            x = init_x + round(i * target_speed(1));
            y = init_y + round(i * target_speed(2));
        case 6  %'ld2ru'
            x = init_x + round(i * target_speed(1));
            y = init_y - round(i * target_speed(2));
        case 7  %'ru2ld'
            x = init_x - round(i * target_speed(1));
            y = init_y + round(i * target_speed(2));
        case 8  %'rd2lu'
            x = init_x - round(i * target_speed(1));
            y = init_y - round(i * target_speed(2));
        otherwise
            warning('Unexpected target track type.');
    end
end