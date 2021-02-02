%% SWITCHTOVOLTAGE Convert switch state to voltage
% Converts the switch state for a six switch inverter to a, b and c
% voltages. The switches are numbered 
%
%   a  b  c
%   a' b' c'
%
%% Form
%   u = SwitchToVoltage( s, uDC )
%
%% Inputs
%   s         (3,1)    Switches
%   uDC       (1.1)    DC voltage
%
%% Outputs
%   u         (3,1)    Three phase voltages [uA;uB;uC]
%

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function u = SwitchToVoltage( s, uDC )

% Switch states [a;b;c]
sA    = [1  1  0  0  0  1;...
         0  1  1  1  0  0;...
         0  0  0  1  1  1];

% Array of voltages
uA   = [ 2  1 -1 -2 -1  1;...
        -1  1  2  1 -1 -2;...
        -1 -2 -1  1  2  1];    

% Find the correct switch state
u   = [0;0;0];
for k = 1:6
  if( sum(sA(:,k) - s) == 0 )
    u = uA(:,k)*uDC/3;
    break;
  end
end
