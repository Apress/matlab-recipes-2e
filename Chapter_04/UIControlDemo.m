%% Demonstrate the use of a uicontrol button with a callback
% Create a window with a button that interacts with a global variable in the
% script.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Build the GUI
% This is a global to communicate the button push from the GUI
global stop;
stop = false;

% Build the GUI
set(0,'units','pixels')
p      = get(0,'screensize');
bottom = p(4) - 190;
fig    = figure('name','UIControlDemo','position',[340 bottom 298 90],...
                'NumberTitle','off','menubar','none',...
                'resize','off');

% The display text                 
speed = uicontrol( 'Parent', fig, 'position', [ 20 40 280 15],...
                   'style', 'text','string','Waiting to start.');

% This has a callback setting stop to 1
step = uicontrol( 'parent', fig, 'position',[ 40 40 40 20],...
                   'string','Stop', 'callback','stop = true;'); 

%% Run the GUI
for k = 1:1000
  pause(0.01)
  set( speed, 'String', k ); 
  if( stop )
    break; %#ok<UNRCH>
  end
  %drawnow   % alternative to pause
end

