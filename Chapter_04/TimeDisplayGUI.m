%% TIMEDISPLAYGUI  Displays an estimate of time to go in a loop.
% Call TimeDisplayGUI('update') each step; the step counter is incremented
% automatically using a persistent variable. Updates at 0.5 sec intervals.
%
%   TimeDisplayGUI( 'initialize', nameOfGUI, totalSteps )
%   TimeDisplayGUI( 'update' )
%   TimeDisplayGUI( 'close' )
%
% You can only have one TimeDisplayGUI operating at once. The built-in demo uses
% pause to run for about 5 seconds.
%% Form:
%   TimeDisplayGUI( action, varargin )
%% Inputs
%   action        (1,:)    'initialize', 'update', or 'close'
%   nameOfGUI     (1,:)    Name to display
%   totalSteps    (1,1)    Total number of steps
%
%% Outputs
%   None

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function TimeDisplayGUI( action, varargin )

persistent hGUI

if nargin == 0
  % Demo
  disp('Initializing demo window with 100 steps.')
  TimeDisplayGUI( 'initialize', 'TimeDisplay Demo', 100 );
  for k = 1:100
    pause(0.05)
    TimeDisplayGUI( 'update' );
  end
  return;
end

switch action
  case 'initialize'
    hGUI            = BuildGUI( varargin{1} );
    hGUI.totalSteps = varargin{2};
    hGUI.stepsDone  = 0;
    hGUI.date0      = now;
    hGUI.lastDate   = now;
  case 'update'
    if( isempty( hGUI ) )
      return
    end
    hGUI.stepsDone = hGUI.stepsDone + 1;
    hGUI = Update( hGUI );
  case 'close'
    if ~isempty(hGUI) && ishandle(hGUI.fig)
      delete( hGUI.fig );
    else
      delete(gcf)
    end
    hGUI = [];
end


function hGUI = Update( hGUI )
% Update the display

thisDate = now;
dTReal   = thisDate-hGUI.lastDate; % days
if (dTReal > 0.5/86400)
  % Increment every 1/2 second
  stepPer   = hGUI.stepsDone/(thisDate - hGUI.date0);
  stepsToGo = hGUI.totalSteps - hGUI.stepsDone;
  tToGo     = stepsToGo/stepPer;
  datev     = datevec(tToGo);
  str       = FormatString( hGUI.stepsDone/hGUI.totalSteps, datev );

  set( hGUI.percent, 'String', str );   
  drawnow;
  hGUI.lastDate = thisDate;
end


function h = BuildGUI( name )
% Initialize the GUIs

set(0,'units','pixels')
p           = get(0,'screensize');
bottom      = p(4) - 190;
h.fig       = figure('name',name,'Position',[340 bottom 298 90],'NumberTitle','off',...
                     'menubar','none','resize','off','closerequestfcn',...
                     'TimeDisplayGUI(''close'')');

v           = {'Parent',h.fig,'Units','pixels','fontunits','pixels'};

str = FormatString( 0, [0 0 0 0 0 0] );
h.percent   = uicontrol( v{:}, 'Position',[ 20 35 260 20], 'Style','text',...
                         'fontsize',12,'string',str,'Tag','StaticText2');
drawnow;


function str = FormatString( fSteps, date )
% Format the time to go string

str = sprintf('%4.2f%% complete with %2.2i:%2.2i:%5.2f to go',...
                    100*fSteps,date(4),date(5),date(6)); 
