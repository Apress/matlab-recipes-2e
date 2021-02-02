%% RHSSCARA Right hand side of the SCARA robot arm equations.
%
%% Form
%  [xDot, i] = RHSSCARA( t, x, d )
%
%% Description
% Generates an acceleration vector given the current state, time, and data
% structure describing the SCARA robot's configuration.
%
%% Inputs
%  t         (1,1)  Time (s)
%  x         (6,:)  State vector [theta1;theta2;d3;omega1;omega2;v3]
%  d          (.)   SCARA data structure
%
%% Outputs
%  xDot      (6,:)  State derivative
%  i         (3,3)  Generalized inertia matrix
%
%% See also
% SCARADataStructure

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function [xDot, i] = RHSSCARA( ~, x, d )

g   = 9.806; % The acceleration of gravity (m/s^2)

c2  = cos(x(2));
s2  = sin(x(2));

theta1Dot = x(4);
theta2Dot = x(5);

% Inertia matrix
i       = zeros(3,3);
a1Sq    = d.a1^2;
a2Sq    = d.a2^2;
a12     = d.a1*d.a2;
m23     = 0.5*d.m2 + d.m3;
i(1,1)  = (d.m1/3 + d.m2 + d.m3)*a1Sq  + 0.5*m23*a12*c2 + (d.m2/3 + d.m3)*a2Sq;
i(2,2)  = (d.m2/3 + d.m3)*a2Sq;         
i(3,3)  = d.m3;
i(1,2)  = m23*a12*c2 + (d.m2/3 + d.m3);
i(2,1)  = i(1,2);

% Right hand side
u = [d.t1;d.t2;d.f3];
f = [-(d.m2 + 2*d.m3)*a12*s2*(theta1Dot*theta2Dot + 0.5*theta2Dot^2);...
      0.5*m23*a12*s2*theta1Dot^2;...
      -d.m3*g];
  
xDot = [x(4:6);i\(f-u)];
