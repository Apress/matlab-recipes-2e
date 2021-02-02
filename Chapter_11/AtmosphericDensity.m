%% ATMOSPHERICDENSITY Compute atmospheric density from an exponential model.
% Computes the atmospheric density at the given altitude using an
% exponential model. Produces a demo plot up to an altitude of 100 km.
%% Form
%   rho = AtmosphericDensity( h )
%
%% Inputs
%   h     (1,:)    Altitude (m)
%
%% Outputs
%   rho   (1,:)   Density (kg/m^3)

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function rho = AtmosphericDensity( h )

% Demo
if( nargin < 1 )
  disp('Demo of AtmosphericDensity');
  h = linspace(0,100000);
  AtmosphericDensity( h );
  return
end

% Density
rho = 1.225*exp(-2.9e-05*h.^1.15);

% Plot if no outputs are requested
if( nargout < 1 )
  PlotSet(h,rho,'x label','h (m)','y label','Density (kg/m^3)',...
          'figure title','Exponential Atmosphere',...
          'plot title','Exponential Atmosphere',...
          'plot type','y log');
  clear rho
end

