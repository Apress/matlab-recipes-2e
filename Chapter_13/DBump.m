
%% Model of a quarter automobile model for the suspension with a hydraulic actuator
%% Form:
%   r = DBump( t, d )
%
%% Inputs
%   t           (1,1) Time
%   d           (.)   data structure
%                     .aBump   (1,1) Bump amplitude (m)
%                     .wBump   (1,1) Bump frequency (rad/sec)
%% Outputs
%   r           (1,1) Bump
%
%--------------------------------------------------------------------------
%   Reference: Lin, J. and I. Kanellakopoulos (1997.) Nonlinear Design of 
%              Active Suspensions. IEEE Control Systems Magazine, 
%              June 1997. pp. 45-59.
%--------------------------------------------------------------------------
function r = DBump( t, d )

if( d.wBump*t < 2*pi )
  r = d.aBump*(1 - cos(d.wBump*t));
end

