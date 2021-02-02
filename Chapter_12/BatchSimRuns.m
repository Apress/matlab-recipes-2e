%% Script performing multiple runs of spacecraft simulation
% Perform runs of SpacecraftSimFunction in a loop with varying initial
% conditions. Find the max control torque applied for each case.
%% See also
% SpacecraftSimFunction

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

%% Initialization
sim = struct;
% Initialize duration, delta time states and inertia
sim.tEnd        = 600;
sim.dT          = 1;
sim.controlIsOn = true;

% Spacecraft state
qECIToBody  = [1;0;0;0];
omega       = [0;0;0]; % rad/sec
omegaRWA    = [0;0;0];  % rad/sec
x0 = [qECIToBody;omega;omegaRWA];

% Target quaternions
qTarget = QUnit([1;0.004;0.0;0]); % Normalize

%% Control design
% Design a PD controller
dC            = PDControl( 'struct' );
dC(1).zeta    = 1;
dC(1).wN      = 0.02;
dC(1).wD      = 5*dC(1).wN;
dC(1).tSamp   = sim.dT;
dC(1)         = PDControl( 'initialize', dC(1) );

% Make all 3 axis controllers identical
dC(2)         = dC(1);
dC(3)         = dC(1);

sim.pd = dC;

%% Spacecraft model
% Make the spacecraft nonspherical; no disturbances
rhs        = RHSSpacecraftWithRWA;
rhs.inr    = [3 0 0;0 10 0;0 0 5];  % kg-m^2
rhs.torque = [0;0;0]; % Disturbance torque
sim.rhs    = rhs;


%% Simulation loop
clear d;
for k = 1:10;
  % change something in your initial conditions and simulate
  x0(5) = 1e-3*k;
  thisD = SpacecraftSimFunction( x0, qTarget, sim );
  
  % save the run results as a mat-file
  thisDir = fileparts(mfilename('fullpath'));
  fileName = fullfile(thisDir,'Output',sprintf('Run%d',k));
  save(fileName,'-struct','thisD');
  
  % store the run output
  d(k) = thisD;
end

%% Perform statistical analysis on results
% ... as you wish
for k = 1:length(d)
  tMax(k) = max(max(d(k).dPlot(2:4,:)));
end
figure;
plot(1:length(d),tMax);
xlabel('Run')
ylabel('Torque (Nm)')
title('Maximum Control Torque');

% Plot a single case
kPlot = 4;
PlotSpacecraftSim( d(4) );
