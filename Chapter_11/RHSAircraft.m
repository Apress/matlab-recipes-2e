%% RHSAIRCRAFT Dynamics for a six DOF point mass aircraft model.
%% Form
%   d                = RHSAircraft;
%   [sDot, D, LStar] = RHSAircraft( t, s, d )
%% Description
% Computes the right hand side for a point mass aircraft. If you call it
% without any arguments, it will return the default data structure.
% sDot(2) and sDot(3) will be infinite when v = 0. The default atmosphere
% model is AtmosphericDensity which uses an exponential atmosphere.
%
%% Inputs
%   t     (1,1)     Time (unused)
%   s     (6,1)     State vector [v;gamma;psi;x;y;h]
%   d      (.)      Data structure 
%                   .m                  (1,1) Aircraft mass
%                   .g                  (1,1) Gravitational acceleration
%                   .thrust             (1,1) Thrust
%                   .alpha              (1,1) Angle of attack
%                   .phi                (1,1) Roll angle
%                   .s                  (1,1) Surface area
%                   .cD0                (1,1) Zero lift drag
%                   .k                  (1,1) Lift drag coupling term
%                   .cLAlpha            (1,1) Lift coefficient
%                   .density            (1,1) Pointer to the atmospheric
%                                             density function
%
%% Outputs
%   sDot  (6,1)   State vector derivative d[v;gamma;psi;x;y;h]/dt
%   D     (1,1)   Drag
%   LStar (1,1)   Lift/angle of attack

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function [sDot, D, LStar] = RHSAircraft( ~, s, d )

% Default data structure
if( nargin == 0 )
  sDot = struct('m',5000, 'g', 9.806, 'thrust',0,'alpha',0, 'phi',0,...
                'cLAlpha',2*pi,'cD0',0.006,'k',0.06,'s',20,'density',@AtmosphericDensity);
  if( nargout == 0 )
    disp('RHSAircraft struct:')
  end
  return
end

% Save as local variables
v     = s(1);
gamma = s(2);
psi   = s(3);
h     = s(6);

% Trig functions
cG    = cos(gamma);
sG    = sin(gamma);
cPsi  = cos(psi);
sPsi  = sin(psi);
cB    = cos(d.phi);
sB    = sin(d.phi);

% Exponential atmosphere
rho   = feval(d.density,h);

% Lift and Drag
qS    = 0.5*rho*d.s*v^2;   % dynamic pressure
cL    = d.cLAlpha*d.alpha;
cD    = d.cD0 + d.k*cL^2;
LStar = qS*d.cLAlpha;
L     = qS*cL;
D     = qS*cD;

% Velocity derivative
% sDot is d[v;gamma;psi;x;y;h]/dt
lT   = L + d.thrust*sin(d.alpha);
sDot = [ (d.thrust*cos(d.alpha) - D)/d.m - d.g*sG;...
         (lT*cB - d.m*d.g*cG)/(d.m*v);...
         lT*sB/(d.m*v*cG);...
         v*cPsi*cG;...
         v*sPsi*cG;...
         v*sG];
