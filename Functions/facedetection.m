% faceDetector = vision.CascadeObjectDetector();
% pointTracker = vision.PointTracker('MaxBidirectionalError',2);

function finalImage = facedetection()
cam = webcam();
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
videoPlayer = vision.VideoPlayer('Position',[100 100 [frameSize(2), frameSize(1)]+30]);

runLoop = true;
numPts = 0;
frameCount = 0;
screenshots = {};
position = [50 200];

while runLoop && frameCount < 100

    % Get the next frame.
    videoFrame = snapshot(cam);
    value = frameCount;
    videoFrame = insertText(videoFrame,position,value,'AnchorPoint','LeftBottom','FontSize',100);
    screenshots = [screenshots; videoFrame];
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;


    % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);

    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
end

% Clean up.
clear cam;
release(videoPlayer);
montage(screenshots,'Indices', 1:100);
% prompt = 'Which image image index do you want?';
% cindex = input(prompt);

prompt = {'Index,Which Image Do You Want?'};
dlgtitle = 'Choosing Ear Image';
dims=[1 100];
cindex = inputdlg(prompt,dlgtitle,dims);
index = str2num(cindex{1});
finalImage = imcrop(screenshots{index})
% imshow(finalImage);
% title('Final Image', 'Fontsize',14);
end




