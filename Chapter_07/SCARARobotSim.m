%% SCARA Robot Demo
% Perform a simulation of the SCARA robot arm.
%% Description
% The dynamics in RHSSCARA are integrated using a fixed time step and the 
% resulting motion is then animated using DrawSCARA.
%% Reference
% Lung-wen Tsai, "Robot Analysis," Wiley-Interscience, 1999. 
% Example 9.8.2, p. 405.
%% See also
% RungeKutta, RHSSCARA, SCARADataStructure, DrawSCARA

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

%% Initialize
% Specify the time, robot geometry and the control target.

% Simulation time settings
tEnd        = 20.0;     % sec
dT          = 0.025;
nSim        = tEnd/dT+1;
controlIsOn = true;

% Robot parameters
d = SCARADataStructure(3,2,1,4,6,1);

% Set the initial arm states
x0    = zeros(6,1);
%x0(5) = 0.05;

% Pick the location to place the end effector, [x;y;z]
r = [4;2;0];

% Find the two angles for the joints
setPoint = SCARAIK( r, d );

%% Control Design
% We will use two PD controllers, one for each rotational joint.

% Controller parameters
dC1        = PDControl( 'struct' );
dC1.zeta   = 1.0;
dC1.wN     = 0.6;
dC1.wD     = 60.0;
dC1.tSamp  = dT;
dC2        = dC1;

% Create the two controllers
dC1       = PDControl( 'initialize', dC1 );
dC2       = PDControl( 'initialize', dC2 );

%% Simulation
% The simulation can be run with or without control, i.e. closed or open
% loop.
x       = x0;
xPlot   = zeros(4,nSim);
tqPlot  = zeros(2,nSim);
inrPlot = zeros(2,nSim);

for k = 1:nSim 
  % Control error
  thetaError  = setPoint(1:2) - x(1:2);
  [~,inertia] = RHSSCARA( 0, x, d );
  acc         = zeros(2,1);
  
  % Apply the control
  if( controlIsOn )
    [acc(1,1), dC1] = PDControl('update',thetaError(1),dC1);
    [acc(2,1), dC2] = PDControl('update',thetaError(2),dC2);
    torque          = inertia(1:2,1:2)*acc;
  else
    torque = zeros(2,1);
  end
  d.t1 = torque(1);
  d.t2 = torque(2);
  
  % Plotting array
  xPlot(:,k)   = [x(1:2);thetaError];
  tqPlot(:,k)  = torque;
  inrPlot(:,k) = [inertia(1,1);inertia(2,2)];
  
  % Enter the motor torques into the dynamics model
  x = RungeKutta( @RHSSCARA, 0, x, dT, d );
end

%% Plot the results
% Plot a time history and perform an animation.

% Plot labels
yL = {'\theta_1 (rad)' '\theta_2 (rad)' 'Error \theta_1 (rad)' 'Error \theta_2 (rad)'};

% Time histories
[t,tL] = TimeLabel(dT*(0:(nSim-1)));
PlotSet( t, xPlot, 'y label', yL, 'x label', tL );
PlotSet( t, tqPlot, 'y label', {'T_x','T_y'}, 'x label', tL );
PlotSet( t, inrPlot, 'y label', {'I_{11}','I_{22}'}, 'x label', tL );
 
% Animation
DrawSCARA( 'initialize', d );
DrawSCARA( 'update', [xPlot(1:2,:);zeros(1,nSim)] );
