

%CHANGE FILENAME HERE
galleryImage = imread('0148_right.jpg');

%=CHANGE DATABSE HERE
earDatabase = imageSet('cpic_right','recursive');

%if user wants to use webcam picture
prompt = 'Do you have an image already?Y/N [Y]:';
answer = input(prompt,'s');
if isempty(answer)
    answer = 'Y'
end
if answer == 'N'  
    facedetection;
    galleryImage = finalImage;
end

%user decides which algorithm to use
AlgQ = ['Which algorithm do you want to use?'...
'\nType 1 for Block Segmentation w/ Hu Moment Invariants',...
'\nType 2 for Eigenvector Analysis',...
'\nType 3 for Q-vector Analysis',...
'\nType 4 for a Measurement Match',...
'\n #:'];
AlgA = input(AlgQ);
if AlgA == 1
    %ask for rows and cols
    RowsQ = 'How many rows do you want to segment the image into?';
    numRows = input(RowsQ);
    ColsQ = 'How many columns do you want to segment?';
    numCols = input(ColsQ);
    notnormalized_sepim;
elseif AlgA == 2
    %put Scott's file here
    eigenears(galleryImage);
elseif AlgA == 3
    %put Luke's file here
    HOGIx;
elseif AlgA == 4
    measurement_match;  
end





