%% Spacecraft reaction wheel simulation script
% An attitude control simulation using reaction wheels.
%% Description
% The dynamics of a spacecraft with reaction wheels are simulated. The attitude
% is controlled using reaction wheels with a PD controller.
%% See also
% RungeKutta, RHSSpacecraftWithRWA, ErrorFromQuaternion, PDControl, PlotSet

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

%% Data structure for the right hand side
d	= RHSSpacecraftWithRWA;

%% User initialization
% Initialize duration, delta time states and inertia
tEnd        = 600;
dT          = 1;
controlIsOn = true;
qECIToBody  = [1;0;0;0];
omega       = [0;0;0]; % rad/sec
omegaRWA    = [0;0;0];  % rad/sec
d.inr       = [3 0 0;0 10 0;0 0 5];  % kg-m^2
qTarget     = QUnit([1;0.004;0.0;0]); % Normalize
d.torque    = [0;0;0]; % Disturbance torque

%% Control design
% Design a PD controller. The same controller is used for all 3 axes.
dC            = PDControl( 'struct' );
dC(1).zeta    = 1;
dC(1).wN      = 0.02;
dC(1).wD      = 5*dC(1).wN;
dC(1).tSamp   = dT;
dC(1)         = PDControl( 'initialize', dC(1) );

% Make all 3 axis controllers identical
dC(2)         = dC(1);
dC(3)         = dC(1);

%% Simulation
% Initialize the plotting arrays and perform a fixed timestep loop using
% Runge-Kutta integration.

% State vector
x = [qECIToBody;omega;omegaRWA];

% Plotting and number of steps
n   = ceil(tEnd/dT);
xP  = zeros(length(x)+7,n);

% Find the initial angular momentum
[~,hECI0] = RHSSpacecraftWithRWA(0,x,d);

% Run the simulation
for k = 1:n
  % Find the angle error
  angleError = ErrorFromQuaternion( x(1:4), qTarget );
  if( controlIsOn )
    u = [0;0;0];
    for j = 1:3
      [u(j), dC(j)] = PDControl('update',angleError(j),dC(j));
    end
  else
    u	= [0;0;0];
  end
  
  % Wheel torque is on the left hand side
  d.torqueRWA = d.inr*u;
  
  % Get the delta angular momentum
  [~,hECI]  = RHSSpacecraftWithRWA(0,x,d);
  dHECI     = hECI - hECI0;
  hMag      = sqrt(dHECI'*dHECI);
   
  % Plot storage
  xP(:,k)	= [x;d.torqueRWA;hMag;angleError];
 
  % Right hand side
  x  = RungeKutta(@RHSSpacecraftWithRWA,0,x,dT,d);
end

%% Plotting
% Generate plots of the attitude, body and wheel rates, control torque, angular
% momentum, and anglular error. If there is no external disturbance torque than
% angular momentum should be conserved.
[t,tL] = TimeLabel((0:(n-1))*dT);
        
yL     = {'q_s', 'q_x', 'q_y', 'q_z'};
PlotSet( t, xP(1:4,:), 'x label', tL, 'y label', yL,...
  'plot title', 'Attitude', 'figure title', 'Attitude');

yL     = {'\omega_x', '\omega_y', '\omega_z'};
PlotSet(t, xP(5:7,:), 'x label', tL, 'y label', yL,...
  'plot title', 'Body Rates', 'figure title', 'Body Rates');

yL     = {'\omega_1', '\omega_2', '\omega_3'};
PlotSet( t, xP(8:10,:), 'x label', tL, 'y label', yL,...
  'plot title', 'RWA Rates', 'figure title', 'RWA Rates');

yL     = {'T_x (Nm)', 'T_y (Nm)', 'T_z (Nm)'};
PlotSet( t, xP(11:13,:), 'x label', tL, 'y label', yL,...
  'plot title', 'Control Torque', 'figure title', 'Control Torque');

yL     = {'\Delta H (Nms)'};
PlotSet( t, xP(14,:), 'x label', tL, 'y label', yL,...
  'plot title', 'Inertial Angular Momentum', 'figure title', 'Inertial Angular Momentum');

yL     = {'\theta_x (rad)', '\theta_y (rad)', '\theta_z (rad)'};
PlotSet( t, xP(15:17,:), 'x label', tL, 'y label', yL,...
  'plot title', 'Angular Errors', 'figure title', 'Angular Errors');
