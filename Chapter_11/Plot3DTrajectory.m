%% PLOT3DTRAJECTORY Plot the trajectory of an aircraft in 3D.
%% Form
%   Plot3DTrajectory( x, varargin )
%% Decription
% Plot a 3D trajectory of an aircraft with times and local axes. Type
% Plot3DTrajectory for a demo.
%
%% Inputs
%   x        (6,:)   State vector [v;gamma;phi;x;y;h]
%   varargin  {:}    Parameters
% 
%% Outputs
% None.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function Plot3DTrajectory( x, varargin  )

% Demo
if( nargin  < 1 )
  disp('Demo of Plot3DTrajectory:');
  l = linspace(0,1e5);
  x = [200*ones(1,100);...
       (pi/4)*ones(1,100);...
       (pi/4)*ones(1,100);l;l;l];
  t = [200 300 400 500 600];
  k = [20  40  60  80 100];
  Plot3DTrajectory( x, 'time', t, 'time index', k, 'alpha',0.01*ones(1,100) );
  return;
end

% Defaults
xLabel    = 'x (m)';
yLabel    = 'y (m)';
zLabel    = 'z (m)';
figTitle	= 'Trajectory';
t         = [];
tIndex    = [];
alpha     = 0.02*ones(1,size(x,2));
phi       = 0.25*pi*ones(1,size(x,2));

for k = 1:2:length(varargin)
  switch lower(varargin{k})
    case 'x label'
      xLabel    = varargin{k+1};
    case 'y label'
      yLabel    = varargin{k+1};
    case 'z label'
      zLabel    = varargin{k+1};
    case 'figure title'
      figTitle  = varargin{k+1};
    case 'time'
      t         = varargin{k+1};
    case 'time index'
      tIndex    = varargin{k+1};
    case 'alpha'
      alpha     = varargin{k+1};
    case 'phi'
      phi       = varargin{k+1};
    otherwise
      error('%s is not a valid parameter',varargin{k});
  end
end

% Draw the figure
h = figure;
set(h,'Name',figTitle);
plot3(x(4,:),x(5,:),x(6,:));
xlabel(xLabel);
ylabel(yLabel);
zlabel(zLabel);

% Draw time and axes
if( ~isempty(t) && ~isempty(tIndex) )
  [t,~,tL] = TimeLabel(t);
  for k = 1:length(t)
    s = sprintf('  t = %3.0f (%s)',t(k), tL);
    i = tIndex(k);
    text(x(4,i),x(5,i),x(6,i),s);
    DrawAxes(x(:,i),alpha(1,i),phi(1,i));
  end
end

% Add the ground
xL    = get(gca,'xlim');
yL    = get(gca,'ylim');
v     = [xL(1) yL(1) 0;...
         xL(2) yL(1) 0;...
         xL(2) yL(2) 0;...
         xL(1) yL(2) 0];
 
patch('vertices',v,'faces',[1 2 3 4],'facecolor',[0.65 0.5 0.0],'edgecolor',[0.65 0.5 0.0]);
grid on
rotate3d on
axis image
zL    = get(gca,'zlim');
set(gca,'zlim',[0 zL(2)],'ZLimMode','manual');

%%% Plot3DTrajectory>DrawAxes subfunction
%   DrawAxes( x, alpha, phi )
function DrawAxes( x, alpha, phi )

gamma = x(2);
psi   = x(3);

% Aircraft frame is x forward, y out the right wing and z down
u0    = [1 0 0;0 1 0;0 0 -1];

cG    = cos(gamma+alpha);
sG    = sin(gamma+alpha);
cP    = cos(psi);
sP    = sin(psi);
cR    = cos(phi);
sR    = sin(phi);

u     =  [cP -sP   0;sP cP  0; 0   0  1]...
        *[cG   0 -sG; 0  1  0;sG   0 cG]...
        *[1    0    0;0 cR sR; 0 -sR cR]*u0;

% Find a length for scaling of the axes
xL    = get(gca,'xlim');
yL    = get(gca,'ylim');
zL    = get(gca,'zlim');

l     = sqrt((xL(2)-xL(1))^2 + (yL(2)-yL(1))^2 + (zL(2)-zL(1))^2)/20;

x0    = x(4:6);
for k = 1:3
  x1    = x0 + u(:,k)*l;
  c     = [0 0 0];
  c(k)  = 1;
  line([x0(1);x1(1)],[x0(2);x1(2)],[x0(3);x1(3)],'color',c);
end
