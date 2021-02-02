%% Double Integrator Demo
% Demonstrate control of a double integrator.
%% See also
% PDControl, RungeKutta, RHSDoubleIntegrator, TimeLabel

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

%% Initialize
tEnd        = 100; % Simulation end time (sec)
dT          = 0.1; % Time step (sec)
aD          = 1.0; % Disturbance acceleration (m/s^2)
controlIsOn = false;  % True if the controller is to be used
x           = [0;0]; % [position;velocity]

% Controller parameters
d       = PDControl( 'struct' );
d.zeta  = 1.0;
d.wN    = 0.1;
d.wD    = 1.0;
d.tSamp = dT;
d       = PDControl( 'initialize', d );

%% Simulation
nSim  = tEnd/dT+1;
xPlot = zeros(3,nSim);

for k = 1:nSim
  if( controlIsOn )
    [u, d] = PDControl('update',x(1),d);
  else
    u = 0;
  end
  xPlot(:,k)  = [x;u];
  x           = RungeKutta( @RHSDoubleIntegrator, 0, x, dT, aD+u );   
end

%% Plot the results
yL     = {'r (m)' 'v (m/s)' 'u (m/s^2)'};
[t,tL] = TimeLabel(dT*(0:(nSim-1)));

PlotSet( t, xPlot, 'x label', tL, 'y label', yL );
