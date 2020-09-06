% galleryImage = imread('0148_right.jpg');
%[n,m] = giveDimensions(galleryImage,3,3);
% C = mat2tiles(I,[m,n]);
% D=seg(I,n,m);


%  numRows=8; %change these for different row and column values
%  numCols=8;
% earDatabase = imageSet('subset-1 copy','recursive'); %load database
%  personToQuery =24; %change tester here
%  galleryImage =read(earDatabase,personToQuery);
load anthro.mat
[n1,m1] = giveDimensions(galleryImage,numCols,numRows);
D= seg(galleryImage,n1,m1);
figure;

%apply weiner filter to image
galleryImage = rgb2gray(galleryImage);
galleryImage = wiener2(galleryImage,[3 3]);

%find hu moment vector of test image
[gI_h,gI_w] = size(galleryImage);
seg_test = mat2tiles(galleryImage,[m1,n1]);
[cell_h,cell_w]=size(seg_test);
if mod(gI_h,m1) ~= 0
    seg_test(cell_h,:) =[];
end
if mod(gI_w,n1) ~= 0
    seg_test(:,cell_w)=[];
end   
seg_hu = cellfun(@hu_moments,seg_test,'UniformOutput',false);
[numRows,numCols]=size(seg_hu);
seg_hu = reshape(seg_hu,1,numCols*numRows);
seg_hu = cell2mat(seg_hu);

% finding hu moments of training
HV = [];
cArrays =[];
for j= 1:earDatabase.Count
     queryImage = read(earDatabase,j);
     queryImage = rgb2gray(queryImage);
     queryImage = wiener2(queryImage,[6 6]);
     
     
     [n,m] = giveDimensions(queryImage,numCols,numRows);
     C= seg(queryImage,n,m);
       %figure;
     
     
     cells = mat2tiles(queryImage,[m,n]);
     
     [gI_h2,gI_w2] = size(queryImage);
     [cell_h2,cell_w2]=size(cells);
    if mod(gI_h2,m) ~= 0
    cells(cell_h2,:) =[];
    end
    if mod(gI_w2,n) ~= 0
    cells(:,cell_w2)=[];
    end 
     
     [numRows,numCols]=size(cells);
     z=reshape(cells,1,numCols*numRows);
     cArrays = [cArrays;z]; %add cell arrays to an array
     x = cellfun(@hu_moments,cells,'UniformOutput',false);
     y= reshape(x,1,numCols*numRows);
     HV = [HV;y];%add Hu vectors to array   
end

%findest closest classifier
A = cell2mat(HV);
[rdim,cdim]=size(A);
e_dist = [];
single_a = [];
for l=1:rdim
for i=1:cdim
    if mod(i, cdim) ~= 0
        single_a = [single_a A(l,i)];
    else
        single_a = [single_a A(l,i)];
        distance = norm(seg_hu - single_a);
        e_dist =[e_dist distance];
        single_a = [];
    end     
end
end
[match, index]=min(e_dist);
% subplot(1,2,1);imshow(imresize(galleryImage,3));title('Query Ear');
% subplot(1,2,2);imshow(imresize(read(earDatabase,index),3));title('Matched Class');
match_num=id(int8(index));

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
%imshow(og_image);
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
     
function outCell=mat2tiles(inArray,varargin)
%MAT2TILES - breaks up an array into a cell array of adjacent sub-arrays of
%            equal sizes
%
%   C=mat2tiles(X,D1,D2,D3,...,Dn)
%   C=mat2tiles(X,[D1,D2,D3,...,Dn])
%
%will produce a cell array C containing adjacent chunks of the array X,
%with each chunk of dimensions D1xD2xD3x...xDn. If a dimensions Di does
%not divide evenly into size(X,i), then the chunks at the upper boundary of
%X along dimension i will be truncated.

tileSizes=[varargin{:}];

N=length(tileSizes);

Nmax=ndims(inArray);

if N<Nmax
   
    tileSizes=[tileSizes,inf(1,Nmax-N)];
    
    
elseif N>Nmax    
    
    tileSizes=tileSizes(1:Nmax);
    
end
N=Nmax;

C=cell(1,N);

for ii=1:N %loop over the dimensions
    
 dim=size(inArray,ii);
 T=min(dim, tileSizes(ii));
 
 if T~=floor(T) || T<=0
     error 'Tile dimension must be a strictly positive integer or Inf'
 end
 
 nn=( dim / T );
   nnf=floor(nn);
 
 resid=[];
 if nnf~=nn 
    nn=nnf;
    resid=dim-T*nn;
 end
 
 C{ii}=[ones(1,nn)*T,resid];    
    
    
end

outCell=mat2cell(inArray,C{:});

end

