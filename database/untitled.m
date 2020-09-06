I = imread('0148_right.jpg');
position = [1 50; 100 50];
value = [555 pi];
J = insertText(I,position,value,'AnchorPoint','LeftBottom');
imshow(J);
