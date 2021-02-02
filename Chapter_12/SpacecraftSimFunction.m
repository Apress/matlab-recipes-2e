%% SPACECRAFTSIMFUNCTION Spacecraft reaction wheel simulation function
% Perform a simulation of a spacecraft with reaction wheels given a
% particular initial state. If there are no inputs it will perform a demo for an
% open loop system. If there are no outputs it will create plots via
% PlotSpacecraftSim.
%% Form
%  d = SpacecraftSimFunction( x0, qTarget, input )
%% Inputs
%  x0    (7+n,1) Initial state
%  qTarget (4,1) Target quaternion
%  input    (.)  Data structure
%                 .rhs   (.)  RHS data
%                 .pd    (:)  Controllers
%                 .dT   (1,1) Timestep
%                 .tEnd (1,1) Duration
%                 .controlIsOn Flag
%% Outputs
%  d       (.)   Data structure
%                 .input   (.)   Input structure
%                 .x0    (7+n,1) Initial state
%                 .qTarget (4,1) Target quaternion
%                 .xPlot (7+n,:) State data
%                 .dPlot (4+n,:) Torque and angle error data
%                 .tPlot  (1,:)  Time data
%                 .yLabel  {}    State labels
%                 .dLabel  {}    Data labels
%                 .tLabel  ''    Time label string
%% See also
% RHSSpacecraftWithRWA, ErrorFromQuaternion, PDControl, RungeKutta, TimeLabel,
% PlotSpacecraftSim

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function d = SpacecraftSimFunction( x0, qTarget, input )

% Handle inputs
if nargin == 0
  % perform an open loop simulation
  disp('SpacecraftSimFunction: Open loop simulation for 10 minutes. Initial rates are random.')
  input = struct;
  input.rhs  = RHSSpacecraftWithRWA;
  input.pd   = [];
  input.dT   = 1; % sec
  input.tEnd = 600; % sec
  input.controlIsOn = false;
  x0 = [1;0;0;0;1e-3*randn(6,1)];
  SpacecraftSimFunction( x0, [], input );
  return;
end

if isempty(x0)
  qECIToBody  = [1;0;0;0];
  omega       = [0;0;0]; % rad/sec
  omegaRWA    = [0;0;0];  % rad/sec
  x0 = [qECIToBody;omega;omegaRWA];
end

if isempty(qTarget)
  qTarget = x0(1:4);
end

% State vector
x = x0;
nWheels = length(x0)-7;

% Plotting and number of steps
n   = ceil(input.tEnd/input.dT);
xP  = zeros(length(x),n);
dP  = zeros(7,n);

% Find the initial angular momentum
d = input.rhs;
[~,hECI0] = RHSSpacecraftWithRWA(0,x,d);

% Run the simulation
for k = 1:n
  % Control
  u = [0;0;0];
  angleError = [0;0;0];
  if( input.controlIsOn )
    % Find the angle error
    angleError = ErrorFromQuaternion( x(1:4), qTarget );
    % Update the controllers individually
    for j = 1:nWheels
      [u(j), input.pd(j)] = PDControl('update',angleError(j),input.pd(j));
    end
  end
  
  % Wheel torque
  d.torqueRWA = d.inr*u;
  
  % Get the delta angular momentum
  [~,hECI]  = RHSSpacecraftWithRWA(0,x,d);
  dHECI     = hECI - hECI0;
  hMag      = sqrt(dHECI'*dHECI);
   
  % Plot storage
  xP(:,k)	= x;
  dP(:,k)	= [hMag;d.torqueRWA;angleError];
 
  % Right hand side
  x       = RungeKutta(@RHSSpacecraftWithRWA,0,x,input.dT,d);
end

[t,tL] = TimeLabel((0:(n-1))*input.dT);

% Record initial conditions and results
d = struct;
d.input   = input;
d.x0      = x0;
d.qTarget = qTarget;
d.xPlot = xP;
d.dPlot = dP;
d.tPlot = t;
d.tLabel = tL;

y = cell(1,nWheels);
for k = 1:nWheels
  y{k} = sprintf('\\omega_%d',k);
end
d.yLabel = [{'q_s','q_x','q_y','q_z','\omega_x','\omega_y','\omega_z'} y];
d.dLabel = {'\Delta H (Nms)','T_x (Nm)', 'T_y (Nm)', 'T_z (Nm)', ...
  '\theta_x (rad)', '\theta_y (rad)', '\theta_z (rad)'};

if nargout == 0
  PlotSpacecraftSim( d );
end
