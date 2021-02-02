%% Draw a JPEG image in a figure multiple ways
% We will load and display an image of a mug.
%% See also
% imread, pcolor, imagesc, imshow, colormap

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Read in the JPEG image
i = imread('Mug.jpg');

%% Draw the picture with imagesc
% This preserves an axes. Each pixel center of the image lies at integer
% coordinates ranging between 1 and M or N. Compare the result of imagesc to
% that of pcolor. axis image sets the aspect ratio so that tick marks on both
% axes are equal, and makes the plot box fit tightly around the data.
h = figure('name','Mug');
subplot(1,2,1)
pcolor(i)
shading('interp')
colorbar
axis image
title('pcolor with colorbar')
a = subplot(1,2,2);
% scale the image into the colormap
imagesc( i );
colormap(a,'gray')
axis image
grid on
title('imagesc with gray colormap')

%% Draw with imshow
% The axes will be turned off. The image will be scaled to fit the figure if it
% is too large.
f = figure('Name','Mug Image');
subplot(1,2,1)
imshow(i)
title('imshow')
subplot(1,2,2)
imshow(i,[30 200])
title('imshow with limits [30 200]')