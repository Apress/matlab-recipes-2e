%% AIRCRAFTCONTROL Control function for a 3D point mass aircraft.
% Computes the angle of attack and thrust for a 3D point mass aircraft.
%% Form
%   [T, alpha] = AircraftControl( s, d )
%
%% Inputs
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
%
%% Outputs
%   T     (1,1)   Thrust
%   alpha (1,1)   Angle of attack
%% See also
% EquilibriumControl

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function [T, alpha] = AircraftControl( s, d, tauGamma, tauV, vSet, gammaSet )

u       = EquilibriumControl( s, d );
v       = s(1);
gamma   = s(2);
h       = s(6);

rho     = feval(d.density,h);
qS      = 0.5*d.s*rho*v^2;
kV      = d.m/tauV;
kGamma  = (d.m*v)/(qS*cos(d.phi)*d.cLAlpha*tauGamma);
T       = u(1) + kV    *(vSet     - v);
alpha   = u(2) + kGamma*(gammaSet - gamma);
