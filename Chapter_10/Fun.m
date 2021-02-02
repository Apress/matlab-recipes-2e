%% FUN Function to be zeroed by SensorTest
%% Form
%  y = Fun( pH, d )
%% Input
%  pH  (1,1)  PH
%  d    (.)   Data structure
%% Output
%  y   (1,1)  Value
%% See also
% SensorTest

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function y = Fun( pH, d )

y   = d.wA4 + 10^(pH-14) - 10^(-pH) ...
          + d.wB4*(1 + 2*10^(pH-d.pK2))/(1 + 10^(d.pK1-pH) + 10^(pH-d.pK2));
        
