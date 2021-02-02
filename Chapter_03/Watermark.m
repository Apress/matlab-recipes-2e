%% WATERMARK Add a watermark to a figure. 
% This function creates two axes, one for the image and one for the text. 
% Calling it BEFORE plotting can cause unexpected results. It will reset 
% the current axes after adding the watermark. The default position is
% the lower left corner, (2,2).
%% Form
%   Watermark( fig, pos  )
%% Inputs
%   fig        (1,1) Figure hangle
%   pos        (1,2) Coordinates, (left, bottom)
%% Outputs
% None.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function Watermark( fig, pos  )

if (nargin<1 || isempty(fig))
  fig = figure('Name','Watermark Demo');
  set(fig,'color',[0.85 0.9 0.85]);
end

if (nargin<2 || isempty(pos))
  pos = [2 2];
end

string = 'MATLAB Recipes';

% Save the current axes so we can restore it
aX = [];
if ~isempty(get(fig,'CurrentAxes'))
  aX = gca;
end

% Draw the icon
%--------------
[d,map] = imread('matlabicon','gif');
posIcon = [pos(1:2) 16 16];
a = axes( 'Parent', fig, 'box', 'off', 'units', 'pixels', 'position', posIcon );
image( d );
colormap(a,map)
axis off

% Draw the text
%--------------
posText = [pos(1)+18 pos(2)+1 100 15];
axes( 'Parent', fig, 'box', 'off', 'units', 'pixels', 'position', posText );
t = text(0,0.5,string,'fontangle','italic');
set(t,'edgecolor',[0.87 0.5 0])
axis off

% Restore current axes in figure
if ~isempty(aX)
  set(fig,'CurrentAxes',aX);
end
  
set(fig,'tag','Watermarked')
