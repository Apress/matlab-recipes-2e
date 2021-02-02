%% PHSENSOR Model pH measurement of a mixing process
% Compute pH as a function of wA4 and wB4 and also the slope of pH with
% respect to those states. Requires the use of fzero.
%
%% Forms
%   pH = PHSensor( x, d )
%   d = PHSensor('struct')
%
%% Inputs
%   x   (2,:) State [wA4;wB4]
%   d    (.)  Data structure
%              .pK1	(1,1) Base 10 log of a disassociation constant (H2CO3)
%              .pK2	(1,1) Base 10 log of a disassociation constant (HCO3-)
% 
%% Outputs
%   pH	(:,:) pH of the solution
%
%% Reference
% Henson, M. A. and D. E. Seborg. Nonlinear Process control, Prentice-Hall,
% 1997. pp. 207-210.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function pH = PHSensor( x, d )

% Demo
if( nargin < 1 )
  disp('Demo of PHSensor...');
  x(1,:)  = linspace(-9e-4,0); 
  x(2,:)  = linspace(0,1e-3);  
  d       = PHSensor('struct');
  PHSensor( x, d );
  return
end

% Default data structure
if( ischar(x) )
  pH = struct('pK1',-log10(4.47e-7),'pK2',-log10(5.62e-11));
  return
end

% Compute the pH starting from neutral
n   = size(x,2);
pH  = zeros(n,n);
pH0 = 7.0;
for k = 1:n
  for j = 1:n
    d.wA4   = x(1,k);
    d.wB4   = x(2,j);
    pH(k,j) = fzero( @Fun, pH0, [], d );  
  end
end

% If no outputs, plot pH
if( nargout == 0 )
  h = figure;
  set(h,'Name','PH Sensor');
  mesh(pH)
  xlabel('WB4');
  ylabel('WA4');
  zlabel('pH')
  grid on
  rotate3d on
  
  clear pH
end
 

function y = Fun( pH, d )
%%% PHSensor>Fun Function to be zeroed via fzero
%  y = Fun( pH, d )

y   = d.wA4 + 10^(pH-14) - 10^(-pH) ...
          + d.wB4*(1 + 2*10^(pH-d.pK2))/(1 + 10^(d.pK1-pH) + 10^(pH-d.pK2));
        
