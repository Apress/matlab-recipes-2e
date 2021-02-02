%% SVPWM Implement space vector pulsewidth modulation.
% Space vector pulsewidth modulation takes the alpha and beta voltage 
% components and enables the switches on a 6 switch inverter to drive a
% 3 phase AC motor. The data structure serves as the function memory.
% Memory variables are marked.
%
% The modulation has seven pulse subperiods each pulse period. These
% are arrange symmetrically about the center of the pulse. A zero
% pulse is at the beginning, middle and end. The order of the active
% pulses (for the two active space vectors) is ordered differently for
% even and odd sectors in the alpha-beta plane. This minimizes switches.
%
% Type SVPWM for a demo using a sine wave input. 
%
%% Forms
%   d = SVPWM
%   [s, d] = SVPWM( t, d )
%
%% Inputs
%   t	(1,1)  Time
%   d 	(.)  Data structure
%            .dT         (1,1) Simulation time step (input)
%            .tLast      (1,1) Time of last pulse (memory)
%            .tUpdate    (1,1) Update period for new pulses (input)
%            .u          (2,1) Voltage vector [alpha;beta] (input) (V)
%            .uM         (1,1) Maximum voltage (parameter) (V)
%            .tP         (1,7) Time for each pulse segment (output)
%            .sP         (3,7) [a;b;c] for each pulse segment (output)
%
%% Outputs
%   s	(3,1) Switch states (1 or 0)
%   d	(.)   Updated data structure
%
%% Reference
% Implementing Space Vector Modulation with the ADMCF32X, ANF32X-17,
% Analog Devices, January 2000.
%% See also 
% SVPWM>Demo

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function [s, d] = SVPWM( t, d )

% Default data structure
if( nargin < 1 && nargout == 1 )
  s = struct( 'dT',1e-6,'tLast',-0.0001,'tUpdate',0.001,'u',[0;0],...
              'uM',10,'tP',zeros(1,7),'sP',zeros(3,7));
  return;
end

% Run the demo
if( nargin < 1 )
  disp('Demo of SVPWM:');
  Demo;
  return; 
end

% Update the pulsewidths at update time
if( t >= d.tLast + d.tUpdate || t == 0 )
  [d.sP, d.tP] = SVPW( d.u, d.tUpdate, d.uM );
  d.tLast      = t;
end

% Time since initialization of the pulse period
dT = t - d.tLast;
s  = zeros(3,1);

for k = 1:7
  if( dT < d.tP(k) )
    s = d.sP(:,k);
    break;
  end
end


%%% SVPWM>SVPW Compute the space vector pulsewidths
%  [sP, tP] = SVPW( u, tS, uD )
%
%  Inputs:
%  u   (2,1)   Voltage vector 
%  tS  (1,1)   Update period 
%  uD  (1,1)   Maximum voltage
%
%  Outputs:
%  sP  (3,7)   Switch patterns
%  tP  (1,7)   Pulse times
function [sP, tP] = SVPW( u, tS, uD )

% Make u easier to interpret
alpha = 1;
beta  = 2;

% Determine the quadrant
if( u(alpha) >= 0 )
  if( u(beta) > 0 )
    q = 1;
  else
    q = 4;
  end
else
  if( u(beta) > 0 )
    q = 2;
  else
    q = 3;
  end
end

sqr3 = sqrt(3);

% Find the sector. k1 and k2 define the edge vectors
switch q
  case 1 % [+,+]
    if( u(beta) < sqr3*u(alpha) )
      k      = 1;
      kP1    = 2;
      oddS   = 1;
    else 
      k      = 2;
      kP1    = 3;
      oddS   = 0;
    end
  case 2  % [-,+]
    if( u(beta) < -sqr3*u(alpha) )
      k      = 3;
      kP1    = 4;
      oddS   = 1;
   else
      k      = 2;
      kP1    = 3;
      oddS   = 0;
    end
  case 3 % [-,-]
    if( u(beta) < sqr3*u(alpha) )
      k      = 5;
      kP1    = 6;
      oddS   = 1;
   else
      k      = 4;
      kP1    = 5;
      oddS   = 0;
    end
  case 4 % [+,-]
    if( u(beta) < -sqr3*u(alpha) )
      k      = 5;
      kP1    = 6;
      oddS   = 1;
    else
      k      = 6;
      kP1    = 1;
      oddS   = 0;
    end
end

% Switching sequence
piO3    = pi/3;
kPiO3   = k*pi/3;
kM1PiO3 = kPiO3-piO3;

% Space vector pulsewidths
t  = 0.5*sqr3*(tS/uD)*[ sin(kPiO3)     -cos(kPiO3);...
                       -sin(kM1PiO3)  cos(kM1PiO3)]*u;

% Total zero vector time
t0 = tS - sum(t);

t  = t/2;

% Different order for odd and even sectors
if( oddS )
  sS  = [0 k kP1 7 kP1 k 0];
  tPW = [t0/4 t(1) t(2) t0/2 t(2) t(1) t0/4];
else
  sS  = [0 kP1 k 7 k kP1 0];
  tPW = [t0/4 t(2) t(1) t0/2 t(1) t(2) t0/4];
end
tP  = [tPW(1) zeros(1,6)];

for k = 2:7
  tP(k) = tP(k-1) + tPW(k);
end
  
% The switches corresponding to each voltage vector
% From 0 to 7
%               a b c
s           = [ 0 0 0;...
                1 0 0;...
                1 1 0;...
                0 1 0;...
                0 1 1;...
                0 0 1;...
                1 0 1;
                1 1 1]';
              
 sP = zeros(3,7);
 for k = 1:7
   sP(:,k) = s(:,sS(k)+1);
 end

function Demo
%%% SVPWM>Demo Function demo
% Calls SVPWM with a sinusoidal input u.
% This demo will run through an array of times and create a plot of the
% resulting voltages.

d     = SVPWM;
tEnd  = 0.003;
n     = tEnd/d.dT;
a     = linspace(0,pi/4,n);
tP3   = 2*pi/3;
uABC  = 0.5*[cos(a);cos(a-tP3);cos(a+tP3)];
uAB   = ClarkeTransformationMatrix*uABC(1:2,:); % a-b to alpha-beta
tSamp = 0;
t     = 0;
tPP   = 1;
x     = zeros(4,n);
for k = 1:n
  if( t >= tSamp )
    tSamp = tSamp + d.tUpdate;
    tPP   = ~tPP;
  end
  d.u    = uAB(:,k);
  [s, d] = SVPWM( t, d );
  t      = t + d.dT;
  x(:,k) = [SwitchToVoltage(s,d.uM);tPP];
end

[t,tL] = TimeLabel( (0:(n-1))*d.dT);
  
PlotSet(t,[uABC;x],'x label',tL,'plot title','Voltages',...
    'y label', {'u_a' 'u_b' 'u_c' 'u_{ap}' 'u_{bp}' 'u_{cp}' 'Pulse' } );

