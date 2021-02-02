%% Simulation of an automobile suspension 
% Simulates a quarter automobile model for the suspension with a hydraulic
% actuator. The automobile parameters and actuator parameters are defined
% and a bump disturbance is considered. The natural motion is simulated
% for three seconds (no control) and the results for the auto suspension 
% and hydraulic states are displayed.
%% Reference
% Lin, J. and I. Kanellakopoulos (1997.) Nonlinear Design of
%	Active Suspensions. IEEE Control Systems Magazine, June 1997. pp. 45-59

%% Automobile parameters
d = RHSAutoSuspension;

%% State 
% Form: [car body displacement; car body rate; wheel displacement;...
%        wheel rate; pressure drop across the piston;...
%        spool valve displacement]
x     = [0;0;0;0;0;0]; 
t     = 0;

%% Number of sim steps
tEnd	= 3;
nSim	= 2000;
dT    = tEnd/(nSim-1);

%% Plotting arrays
xP    = zeros(7,nSim);

%% Run the simulation
for k = 1:nSim     
  x     	= RK4( 'RHSAutoSuspension', x, dT, t, d );
  t     	= t + dT; 
  xP(:,k)	= [x;DBump( t, d )];
end

%% Plot results
xP      = xP(:,1:k);
[t,tL]  = TimeLabel((0:k-1)*dT);
k1      = [1:4 7];
k2      = 5:6;
yL      = [d.states(:)' {'bump'}];

PlotSet( t, xP(k1,:),'x label',tL,'y label',yL(k1),'figure title','Suspension States');
PlotSet( t, xP(k2,:),'x label',tL,'y label',yL(k2),'figure title','Hydraulic States');
