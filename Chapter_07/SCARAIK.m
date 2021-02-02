%% SCARAIK Generate SCARA states for desired end effector position and angle.
%
%% Form
%  x = SCARAIK( r, d )
%
%% Description
% SCARA inverse kinematics. Uses fminsearch to find the link states given the
% effector location. The cost function is embedded. Type SCARAIK for a demo
% which creates a plot and a video.
%
%% Inputs
%  r          (3,:) End effector position [x;y;z]
%  d           (.)  Robot data structure
%                    .a1 (1,1) Link 1 length
%                    .a2 (1,1) Link 2 length
%                    .d1 (1,1) Distance of link 1 from ground
%
%% Outputs
%  x          (3,:) SCARA states [theta1;theta2;d3]

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function x = SCARAIK( r, d )

if( nargin < 1 )
  disp('Demo of SCARAIK...');
  r = [linspace(0,0.2);zeros(2,100)];
  d = SCARADataStructure;
  
  SCARAIK( r, d );
  return;
end

n  = size(r,2);
xY = zeros(2,n);

TolX        = 1e-5;
TolFun      = 1e-9;
MaxFunEvals = 1500;
Options = optimset('TolX',TolX,'TolFun',TolFun,'MaxFunEvals',MaxFunEvals);

x0 = [0;0];
for k = 1:n
  d.xT    = r(1:2,k);
  xY(:,k) = fminsearch(@Cost, x0, Options, d );
  x0      = xY(:,k);
end

x = [xY;d.d1-r(3,:)];

% Default output is to create a plot
%-----------------------------------
if( nargout == 0 )
  DrawSCARA( 'initialize', d );
  m = DrawSCARA( 'update', x );
  disp('Saving movie...')
  vidObj = VideoWriter('SCARAIK.avi');
  open(vidObj);
  writeVideo(vidObj,m);
end

end

%%% SCARAIK>Cost  
% Cost function. The cost is the difference between the position as computed from the
% states and the target position xT in d.
%
%  y = Cost( x, d )
function y = Cost( x, d )

xE = d.a1*cos(x(1)) + d.a2*cos(x(1)+x(2));
yE = d.a1*sin(x(1)) + d.a2*sin(x(1)+x(2));
y  = sqrt((xE-d.xT(1))^2+(yE-d.xT(2))^2);

end