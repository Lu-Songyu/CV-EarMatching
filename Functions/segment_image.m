%apply weiner filter to image
% galleryImage = rgb2gray(galleryImage);
% galleryImage = wiener2(galleryImage,[3 3]);
 
% imshow(galleryImage);
f1 = figure('Visible','off'); 

[n1,m1] = giveDimensions(galleryImage,numCols,numRows);
seg(galleryImage,n1,m1);

% f1=figure('visible','off');
saveas(f1,'segmentedEar','jpg');

function [subc_size,subr_size]= giveDimensions(I,c,r)
% I=imread(I);
[y,x,z] = size(I);
n=idivide(int32(x),int32(c)); %number of columns
n=cast(n,'double');
m=idivide(int32(y),int32(r)); %number of rows
m=cast(m,'double');
subc_size = n;
subr_size = m;
end

function splitImage = seg(og_image, subc_size, subr_size)
imshow(og_image);
[ydim,xdim,zdim] = size(og_image);
x1=xdim;
y1=ydim;
axis on;
hold on;  
    while x1>=0 
        if mod(x1,subc_size) == 0 
            p1 = [x1,x1];
            p2 = [0,ydim];
            line(p1,p2);
       end
    x1=x1-1;
    end
    
  while y1>=0
         if mod(y1,subr_size) == 0 
             p3 = [y1,y1];
             p4 = [0,xdim];
            line(p4,p3);
         end
     y1=y1-1;
     end
splitImage = og_image;
end

