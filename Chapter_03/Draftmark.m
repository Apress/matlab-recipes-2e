%% DRAFTMARK Add a draft marking to a figure. 
% This function creates two axes, one each block of text. 
% Calling it BEFORE plotting can cause unexpected results. It will reset 
% the current axes after adding the watermark. The default position is
% the lower left corner, (2,2).
%% Form
%   Draftmark( fig, pos  )
%% Inputs
%   fig        (1,1) Figure hangle
%   pos        (1,2) Coordinates, (left, bottom)
%% Outputs
% None.

%% Copyright
%	Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function Draftmark( fig, pos  )

if (nargin<1 || isempty(fig))
  fig = figure('Name','Draft Demo');
  set(fig,'color',[0.85 0.9 0.85]);
end

if (nargin<2 || isempty(pos))
  pos = [2 2];
end

string = 'DRAFT';

% Save the current axes so we can restore it
aX = [];
if ~isempty(get(fig,'CurrentAxes'))
  aX = gca;
end

% Draw the text
%--------------
pf = get(fig,'position');
posText = [pos(1)+5 pos(2)+0.5*pf(4)-40 20 80];
axes( 'Parent', fig, 'box', 'on', 'units', 'pixels', 'outerposition', posText );
t1 = text(0,0,string,'fontsize',20,'color',[0.8 0.8 0.8]);
set(t1,'rotation',90,'edgecolor',[0.8 0.8 0.8],'linewidth',2)
axis off

posText = [pos(1)+pf(3)-25 pos(2)+0.5*pf(4)-40 20 80];
axes( 'Parent', fig, 'box', 'on', 'units', 'pixels', 'outerposition', posText );
t2 = text(0,1,string,'fontsize',20,'color',[0.8 0.8 0.8]);
set(t2,'rotation',270,'edgecolor',[0.8 0.8 0.8],'linewidth',2)
axis off


% Restore current axes in figure
if ~isempty(aX)
  set(fig,'CurrentAxes',aX);
end
  