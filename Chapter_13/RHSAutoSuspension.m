
%% Model of a quarter automobile for the suspension with a hydraulic actuator
%--------------------------------------------------------------------------
%   Form:
%   xDot = RHSAutoSuspension( x, t, d )
%--------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   x           (6,1) State
%                     [car body displacement;...
%                      car body rate;...
%                      wheel displacement;...
%                      wheel rate;...
%                      pressure drop across the piston;...
%                      spool valve displacement]
%   t           (1,1) Time
%   d           (.)   Data structure
%                     .mB    (1,1)  Body mass (kg)
%                     .mUS   (1,1)  Wheel mass (kg)
%                     .kA    (1,1)  Spring constant (N/m)
%                     .cA    (1,1)  Damping constant (N/(m/sec))
%                     .kT    (1,1)  Tire spring constant (N/m)
%                     .alpha (1,1)  (N/m^5)
%                     .beta  (1,1)  alpha*piston leakage coefficient (1/s)
%                     .gamma (1,1)  (N/(m^5/2 kg^1/2)
%                     .tau   (1,1)  Spool valve time constant (s)
%                     .pS    (1,1)  Supply pressure (Pa)
%                     .a     (1,1)  Piston area (m^2)
%                     .aBump (1,1)  Bump amplitude (m)
%                     .wBump (1,1)  Bump frequency (rad/sec)

%   -------
%   Outputs
%   -------
%   xDot        (6,1) State derivative
%
%--------------------------------------------------------------------------
%   Reference: Lin, J. and I. Kanellakopoulos (1997.) Nonlinear Design 
%              of Active Suspensions. IEEE Control Systems Magazine,
%              June 1997. pp. 45-59.
%--------------------------------------------------------------------------
function xDot = RHSAutoSuspension( x, t, d )

if( nargin < 1 )
  xDot = DefaultDataStructure;
  return
end

f    = d.pS - sign(x(6))*x(5);
w3   = sign(f)*sqrt(abs(f));
r    = DBump( t, d );
mu   = 1e7;

x24  = x(2) - x(4);
x13  = x(1) - x(3);
aX5  = d.a*mu*x(5);

xDot = [ x(2);...
        -(d.kA*x13 + d.cA*x24 - aX5)/d.mB;...
          x(4);...
         (d.kA*x13 + d.cA*x24 - d.kT*(x(3) - r) - aX5)/d.mUS;...
         -d.beta*x(5) - d.alpha*d.a*x24/mu + d.gamma*x(6)*w3/mu;...
        (d.u - x(6))/d.tau];
		
function d = DefaultDataStructure
  
  %% Automobile parameters
d.mB    =    290; % Body mass (kg)
d.mUS   =     59; % Wheel mass (kg)
d.kA    =  16812; % Spring constant (N/m)
d.cA    =   1000; % Damping constant (N/(m/sec))
d.kT    = 190000; % Tire spring constant (N/m)

%% Hydraulic actuator parameters
d.alpha = 4.515e13; % N/m^5
d.beta  = 1; % alpha times piston leakage coefficient (1/s)
d.gamma = 1.545e9; % N/(m^5/2 kg^1/2)
d.tau   = 1/30; % Spool valve time constant (s)
d.pS    = 10342500; % Supply pressure (Pa)
d.a     = 3.35e-4; % Piston area (m^2)
d.u     = 0;

%% Bump disturbance
d.aBump = 0.025; % Bump amplitude (m)
d.wBump = 8*pi;  % Bump frequency (rad/sec)

d.states = { 'body disp' 'body rate' 'wheel disp' 'wheel rate' ...
            'pressure drop' 'spool valve'};

