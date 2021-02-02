%% TORQUECONTROL Compute torque control of an AC machine
% Determines the quadrature current needed to produce a torque and uses a
% proportional integral controller to control the motor. We control the
% direct current to zero since we want to use just the magnet flux to react
% with the quadrature current. We could control the direct current to
% another value to implement field-weakening control but this would result
% in a nonlinear control system.
%% Forms
%   d = TorqueControl
%   [u, d, iAB] = TorqueControl( torqueSet, x, d )
%
%% Inputs
%   torqueSet (1,1)    Set point torque
%   x         (5,1)    State [ia;ib;ic;omega;theta]
%   d         (.)    	 Control data structure
%                      .kF      (1,1) Forward gain
%                      .tauI    (1,1) Integral time constant
%                      .iDQInt  (2,1) Integral of current errors
%                      .dT      (1,1) Time step
%                      .psiM    (1,1) Magnetic flux
%                      .p       (1,1) Number of magnet poles
%
%%  Outputs
%   u         (2,1)    Control voltage [alpha;beta]
%   d         (.)      Control data structure
%   iAB       (2,1)    Steady state currents [alpha;beta]
%

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function [u, d, iAB] = TorqueControl( torqueSet, x, d )

% Default data structure
if( nargin == 0 )
  u = struct('kF',0.003,'tauI',0.001, 'iDQInt',[0;0], 'dT', 0.01,...
             'psiM',0.0690,'p',2);
  if( nargout == 0 )
    disp('TorqueControl struct:');
  end
  return
end

% Clarke and Park transforms
thetaE = 0.5*d.p*x(5);
park   = ParkTransformationMatrix( thetaE );
iPark  = park';
clarke = ClarkeTransformationMatrix;
iDQ    = iPark*clarke*x(1:2);

% Set point to produce the desired torque [iD;iQ]
iDQSet = [0;(2/3)*torqueSet/(d.psiM*d.p)];

% Error
iDQErr = iDQ - iDQSet;

% Integral term
d.iDQInt = d.iDQInt + d.dT*iDQErr;

% Control
uDQ = -d.kF*(iDQErr + d.iDQInt/d.tauI);
u   = park*uDQ;

% Steady state currents
if( nargout > 2 )
  iAB = park*iDQSet;
end

