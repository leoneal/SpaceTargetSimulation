%% 输出仿真图片中的gt标签

function output_label(output_path, frame_n, target_num, target_pos, target_size, m, n)
    % 调试参数
%     output_path = 'label.txt';
%     x = 1;
%     y = 1;
%     target_size = 5;
%     m = 256;
%     n = 256;
    
    label = [];
    for i = 1 : target_num
        % 检测框左上角和右下角的归一化坐标
        % 如果坐标超出了图像边界，目前也将其保留，但这种保留好不好需要实验结果来看看
        x_min = (target_pos(i, 1) - target_size(i) / 2) / m;
        x_max = (target_pos(i, 1) + target_size(i) / 2) / m;
        y_min = (target_pos(i, 2) - target_size(i) / 2) / n;
        y_max = (target_pos(i, 2) + target_size(i) / 2) / n;

        label_cur = [frame_n; i - 1; x_min; y_min; x_max; y_max];
        label = [label label_cur];
    end
    
    file = fopen(output_path, 'a');
    fprintf(file, '%d %d %.6f %.6f %.6f %.6f\r\n', label);  %按列输出label
    fclose(file);
end


% function output_label(output_path, x, y, target_size, m, n)
%     % 调试参数
% %     output_path = 'label.txt';
% %     x = 1;
% %     y = 1;
% %     target_size = 5;
% %     m = 256;
% %     n = 256;
%     
%     % 检测框左上角和右下角的归一化坐标
%     % 如果坐标超出了图像边界，目前也将其保留，但这种保留好不好需要实验结果来看看
%     x_min = (x - target_size / 2) / m;
%     x_max = (x + target_size / 2) / m;
%     y_min = (y - target_size / 2) / n;
%     y_max = (y + target_size / 2) / n;
%     
%     label = [x_min y_min x_max y_max];
%     
%     file = fopen(output_path, 'a');
%     fprintf(file, '%.6f %.6f %.6f %.6f\r\n', label);
% end