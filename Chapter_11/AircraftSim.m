%% A trajectory control simulation of an F-35 aircraft.
% The dynamics of a point mass aircraft is simulated.
%% See also
% RungeKutta, RHSAircraft, PDControl, EquilibriumControl

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

%% Data structure for the right hand side
d           = RHSAircraft;

%% User initialization
d.m         = 13300.00; % kg
d.s         = 204.00; % m^2
v           = 200; % m/sec
fPA         = pi/6;  % rad

% Initialize duration and delta time
tEnd        = 40;
dT          = 0.1;

% Controller
controlIsOn = true;
tauV        = 1;
tauGamma    = 1;
d.phi       = 0;
vSet        = 220;
gammaSet    = pi/8;

%% Simulation
% State vector
x           = [v;fPA;0;0;0;0];

% Plotting and number of steps
n           = ceil(tEnd/dT);
xP          = zeros(length(x)+2,n);

% Find non-feedback settings
[~,D,LStar] = RHSAircraft(0,x,d);
thrust0     = D;
alpha0      = d.m*d.g/LStar;

% Run the simulation
for k = 1:n
  
  if( controlIsOn )
    [d.thrust, d.alpha] = AircraftControl( x, d, tauGamma, tauV, vSet, gammaSet );
  else
    d.thrust	= thrust0;
    d.alpha   = alpha0;
  end
   
  % Plot storage
  xP(:,k)	= [x;d.thrust;d.alpha];
 
  % Right hand side
  x       = RungeKutta(@RHSAircraft,0,x,dT,d);
  
end

%% Plotting
[t,tL] = TimeLabel((0:(n-1))*dT);
        
yL = {'T (N)', '\alpha (rad)'};
s  = 'Aircraft Sim:Controls';
PlotSet(t,xP(7:8,:),'x label',tL,'y label',yL,'plot title',s, 'figure title',s);
        
yL = {'v' '\gamma' '\psi' 'x' 'y' 'h'};
s  = 'Aircraft Sim:States';
PlotSet(t,xP(1:6,:),'x label',tL,'y label',yL,'plot title',s,'figure title',s);

k = floor(linspace(2,n,8));
t = t(k);
Plot3DTrajectory( xP, 'time', t, 'time index', k, 'alpha', xP(8,:) );

