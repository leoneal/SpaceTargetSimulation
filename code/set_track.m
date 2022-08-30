%% 设置目标轨迹

function [x, y] = set_track(target_track, i, init_x, init_y)
    %target_track
    switch target_track
        case 1 %'l2r'
            x = init_x + i; % 目标位置坐标x, y需要是整数，否则后面imshow会报错
            y = init_y;
        case 2  %'r2l'
            x = init_x - i;
            y = init_y;
        case 3  %'u2d'
            x = init_x;
            y = init_y + i;
        case 4  %'d2u'
            x = init_x;
            y = init_y - i;
        case 5  %'lu2rd'
            x = init_x + i;
            y = init_y + i;
        case 6  %'ld2ru'
            x = init_x + i;
            y = init_y - i;
        case 7  %'ru2ld'
            x = init_x - i;
            y = init_y + i;
        case 8  %'rd2lu'
            x = init_x - i;
            y = init_y - i;
        otherwise
            warning('Unexpected target track type.');
    end
end