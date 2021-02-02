%% RHSPMMACHINE Permanent magnet machine model in ABC coordinates.
% Assumes a 3 phase machine in a Y connection. The permanent magnet flux
% distribution is assumed sinusoidal.
%% Forms
%   d = RHSPMMachine
%   [xDot,tE] = RHSPMMachine( ~, x, d )
%
%% Inputs
%   t	(1,1)    Time, unused
%   x	(5,1)    The state vector [iA;iB;iC;omegaE;thetaE]
%   d	 (.)     Data structure
%                    .lM   (1,1) Mutual inductance
%                    .psiM (1,1) Permanent magnet flux
%                    .lSS  (1,1) Stator self inductance
%                    .rS   (1,1) Stator resistance
%                    .p    (1,1) Number of poles (1/2 pole pairs)
%                    .u    (3,1) [uA;uB;uC]
%                    .tL   (1,1) Load torque
%                    .bM   (1,1) Viscous damping (Nm/rad/s)
%                    .j    (1,1) Inertia
%                    .u    (3,1) Phase voltages [uA;uB;uC]
%
%% Outputs
%   x   (5,1)    The state vector derivative
%   tE  (1,1)    Electrical torque
%
%% Reference
% Lyshevski, S. E., "Electromechanical Systems, Electric Machines, and
% Applied Mechatronics," CRC Press, 2000.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function [xDot, tE] = RHSPMMachine( ~, x, d )

if( nargin == 0 ) 
  xDot = struct('lM',0.0009,'psiM',0.069, 'lSS',0.0011,'rS',0.5,'p',2,...
                'bM',0.000015,'j',0.000017,'tL',0,'u',[0;0;0]);
  return
end

% Pole pairs
pP = d.p/2;

% States
i      = x(1:3);
omegaE = x(4);
thetaE = x(5);

% Inductance matrix
denom = 2*d.lSS^2 - d.lSS*d.lM - d.lM^2;
l2    = d.lM;
l1    = 2*d.lSS - l2;
l     = [l1 l2 l2;l2 l1 l2;l2 l2 l1]/denom;

% Right hand side
tP3      = 2*pi/3;
c        = cos(thetaE + [0;-tP3;tP3]);
iDot     = l*(d.u - d.psiM*omegaE*c - d.rS*i);
tE       = pP^2*d.psiM*i'*c;
omegaDot = (tE - d.bM*omegaE - 0.5*pP*d.tL)/d.j;
xDot     = [iDot;omegaDot;omegaE];
