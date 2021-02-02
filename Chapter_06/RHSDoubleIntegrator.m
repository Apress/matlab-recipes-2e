%% RHSDOUBLEINTEGRATOR Right hand side of a double integrator.
%% Form
%  xDot = RHSDoubleIntegrator( ~, x, a )
%
%% Description
% A double integrator models linear or rotational motion plus many other
% systems. It has two states, position and velocity. The equations of
% motion are:
%
%  rDot = v
%  vDot = a
%
% This can be called by the MATLAB Recipes RungeKutta function or any MATLAB
% integrator. Time is not used.
%
%% Inputs
%  t       (1,1) Time (unused)
%  x       (2,1) State vector [r;v]
%  a       (1,1) Acceleration
%
%% Outputs
%  x       (2,1) State vector derivatie d[r;v]/dt
%
%% References
% None.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function xDot = RHSDoubleIntegrator( ~, x, a )

xDot = [x(2);a];
