%% RHSSPACECRAFTWITHRWA Compute the dynamics for a spacecraft with reaction wheels.
%% Forms
%   d    = RHSSpacecraftWithRWA
%   xDot = RHSSpacecraftWithRWA( x, t, d )
%% Decription
% RWA stands for reaction wheel assembly. The wheels can have damping. If
% you call it without any arguments it will return the default data
% structure. The default data structure is for 3 orthogonal reaction wheels. 
%
% The gravity model is a point mass planet. The inertia of the body
% does not include the RWA polar inertia.
%
%% Inputs
%   t     (1,1)     Time (unused)
%   x     (7+n,1)   State vector [q;omega;omegaRWA]
%   d      (.)      Data structure 
%                   .inr                (3,3) Body inertia matrix
%                   .torque             (3,1) External torque in the body frame
%                   .inrRWA             (n,1) Polar inertia of each wheel
%                   .torqueRWA          (n,1) Torques on each wheel
%                   .uRWA               (3,n) Unit vectors for the RWA
%                   .damping            (n,1) Damping
%
%% Outputs
%   xDot	(7+n,1)   State vector derivative d[q;omega;omegaRWA]/dt
%   hECI	(3,1)     Inertial angular momentum
%

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function [xDot, hECI] = RHSSpacecraftWithRWA( ~, x, d )

% Default data structure
if( nargin == 0 )
  xDot = struct('inr',eye(3), 'torque',[0;0;0],'inrRWA', 0.001*[1;1;1],...
                'torqueRWA',[0;0;0],'uRWA',eye(3), 'damping',[0;0;0]);
  if( nargout == 0 )
    disp('RHSSpacecraftWithRWA struct:')
  end
  return
end

% Save as local variables
q        = x(1:4);
omega    = x(5:7);
omegaRWA = x(8:end);

% Total body fixed angular momentum
h = d.inr*omega + d.uRWA*(d.inrRWA.*(omegaRWA + d.uRWA'*omega));

% Total wheel torque
tRWA = d.torqueRWA - d.damping.*omegaRWA;

% Core angular acceleration
omegaDotCore = d.inr\(d.torque - d.uRWA*tRWA - cross(omega,h));     

% Wheel angular acceleration
omegaDotWheel	= tRWA./d.inrRWA - d.uRWA'*omegaDotCore;
 
% State derivative
sW   = [       0 -omega(3) omega(2);...
         omega(3)       0 -omega(1);...
        -omega(2) omega(1)       0]; % skew symmetric matrix
qD   = 0.5*[0, omega';-omega,-sW];
xDot = [qD*q;omegaDotCore;omegaDotWheel];

% Output the inertial angular momentum
if( nargout > 1 )
  hECI = QTForm( q, h );
end
