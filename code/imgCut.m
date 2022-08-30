imgPath = '10.jpg';
img = imread(imgPath);
figure(1);
imshow(img);
[x, y] = ginput(2)
img1 = imcrop(img, [x(1),y(1),abs(x(1)-x(2)),abs(y(1)-y(2))]);
figure(2);
imshow(img1);
imwrite(img1,'img_cut.jpg');