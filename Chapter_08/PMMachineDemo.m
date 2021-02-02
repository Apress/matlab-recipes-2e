%% Simulation of a permanent magnet AC motor
% Simulates a permanent magnet AC motor with torque control. The simulation has
% two options. The first is torqueControlOn. This turns torque control on and
% off. If it is off the phase voltages are a balanced three phase voltage set.
%
% bypassPWM allows you to feed the phase voltages directly to the motor
% bypassing the pulsewidth modulation switching function. This is useful for
% debugging your control system and other testing.
%
% There are two time constants for this simulation. One is the control period
% and the second is the simulation period. The latter is much shorter because it
% needs to simulate the pulsewidth modulation.
%
% For control testing the load torque and setpoint torque should be the same.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Initialize all data structures
dS      = SVPWM;
dC      = TorqueControl;
d       = RHSPMMachine;
dC.psiM = d.psiM;
dC.p    = d.p;
d.tL    = 1.0; % Load torque (Nm)

%% User inputs
tEnd            = 0.05;      % sec
torqueControlOn	= false;
bypassPWM       = false;
torqueSet       = 1.0;       % Set point (Nm)
dC.dT           = 100*dS.dT; % 100x larger than simulation dT
dS.uM           = 1.0;       % DC Voltage at the input to the switches
magUABC         = 0.1;       % Voltage for the balanced 3 phase voltages

if (torqueControlOn && bypassPWM)
  error('The control requires PWM to be on.');
end

%% Run the simulation
nSim = ceil(tEnd/dS.dT);
xP   = zeros(10,nSim);
x    = zeros(5,1);

% We require two timers as the control period is larger than the simulation
% period
t    = 0.0; % simulation timer
tC   = 0.0; % control timer

for k = 1:nSim
  % Electrical degrees
  thetaE = x(5);
  park   = ParkTransformationMatrix( thetaE );
  clarke = ClarkeTransformationMatrix;
  
  % Compute the voltage control
  if( torqueControlOn && t >= tC )
    tC         = tC + dC.dT;
    [dS.u, dC] = TorqueControl( torqueSet, x, dC );
  elseif( ~torqueControlOn )
    tP3  = 2*pi/3;
    uABC = magUABC*dS.uM*[cos(thetaE);cos(thetaE-tP3);cos(thetaE+tP3)];
    if( bypassPWM )
      d.u = uABC;
    elseif( t >= tC ) 
      tC   = tC + dC.dT;
      dS.u = park*clarke*uABC(1:2,:);
    end
  end
  
  % Space Vector Pulsewidth Modulation
  if( ~bypassPWM )
    dS.u   = park'*dS.u;
    [s,dS] = SVPWM( t, dS );
    d.u    = SwitchToVoltage(s,dS.uM);
  end
  
  % Get the torque output for plotting
  [~,tE]  = RHSPMMachine( 0, x, d );
  xP(:,k) = [x;d.u;torqueSet;tE];
  
  % Propagate one simulation step
  x = RungeKutta( @RHSPMMachine, 0, x, dS.dT, d );
  t = t + dS.dT;
end

%% Generate the time history plots
[t, tL]   = TimeLabel( (0:(nSim-1))*dS.dT );

figure('name','3 Phase Currents');
plot(t, xP(1:3,:));
grid on;
ylabel('Currents');
xlabel(tL);
legend('i_a','i_b','i_c')

PlotSet( t, xP([4 10],:), 'x label', tL, 'y label', {'\omega_e' 'T_e (Nm)'}, ...
  'plot title','Electrical', 'figure title','Electrical');

thisTitle = 'Phase Voltages';
if ~bypassPWM
  thisTitle = [thisTitle ' - PWM'];
end
  
PlotSet( t, xP(6:8,:), 'x label', tL, 'y label', {'u_a' 'u_b' 'u_c'}, ...
  'plot title',thisTitle, 'figure title',thisTitle);

thisTitle = 'Torque/Speed';
if ~bypassPWM
  thisTitle = [thisTitle ' - PWM'];
end

PlotSet( xP(4,:), xP(10,:), 'x label', '\Omega_e (rad/s)', 'y label', ...
  'T_e (Nm)','plot title',thisTitle, 'figure title',thisTitle);

% Plot only if the control system is on
if( torqueControlOn )
  PlotSet( t, xP(9:10,:), 'x label', tL, 'y label', {'T_{set} (Nm)' 'T (Nm)'}, ...
  'plot title','Torque', 'figure title','Torque'); 
end

