function img_out = normalize(img_in)
%将图片归一化到0-255间

max_val = max(max(img_in));
min_val = min(min(img_in));
img_out = (img_in - min_val) / (max_val - min_val);  % 0-1间
img_out = img_out * 255;  % 0-255间

end

