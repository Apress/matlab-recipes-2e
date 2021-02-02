%% ADDFILLTOPWM Add shading to the motor pulsewidth plot
% Adds gray shading to alternate pulsewidths for the last 5 pulses of the
% plot. The pulsewidth plot should be the current axes.
%
%% Form
%  AddFillToPWM( dT )
%
%% Input
%  dT    (1,1)    Pulsewidth
%% Output
% None.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function AddFillToPWM( dT )

if nargin == 0
  dT = 0.001;
end

hAxes = get(gcf,'children');
nAxes = length(hAxes);

for j = 1:nAxes
  if strcmp(hAxes(j).type,'axes')
    axes(hAxes(j));
    AddFillToAxes;
  end
end

  function AddFillToAxes

  hold on;
  y = axis;
  xMin = y(2) - 5*dT;
  xMax = y(2);
  axis([xMin xMax y(3:4)])
  x0    = xMin;
  yMin  = y(3) + 0.01*(y(4)-y(3));
  yMax  = y(4) - 0.01*(y(4)-y(3));
  for k = [2 4]
    xMinK = x0 + (k-1)*dT;
    xMaxK = x0 + k*dT;

    fill([xMinK xMaxK xMaxK xMinK],...
         [yMin,yMin,yMax,yMax],...
         [0.8 0.8 0.8],'edgecolor','none','facealpha',0.5);
       
  end
  babes = get(gca,'children');
  set(gca,'children',[babes(end); babes(1:end-1)])
  hold off;
  
  end

end
