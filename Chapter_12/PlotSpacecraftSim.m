%% PLOTSPACECRAFTSIM Plot the spacecraft simulation output
%% Form
%  PlotSpacecraftSim( d )
%% Inputs
%  d  (.)   Simulation data structure
%% Outputs
% None.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function PlotSpacecraftSim( d )

t  = d.tPlot;

yL = d.yLabel(1:4);
PlotSet( d.tPlot, d.xPlot(1:4,:), 'x label', d.tLabel, 'y label', yL,...
  'plot title', 'Attitude', 'figure title', 'Attitude');

yL = d.yLabel(5:7);
PlotSet(d.tPlot, d.xPlot(5:7,:), 'x label', d.tLabel, 'y label', yL,...
  'plot title', 'Body Rates', 'figure title', 'Body Rates');

yL = d.yLabel(8:end);
PlotSet( t, d.xPlot(8:end,:), 'x label', d.tLabel, 'y label', yL,...
  'plot title', 'RWA Rates', 'figure title', 'RWA Rates');

yL = d.dLabel(1);
PlotSet( d.tPlot, d.dPlot(1,:), 'x label', d.tLabel, 'y label', yL,...
  'plot title', 'Inertial Angular Momentum',...
  'figure title', 'Inertial Angular Momentum');

if any(d.dPlot(5:end,:)~=0)
  yL = d.dLabel(2:4);
  PlotSet( d.tPlot, d.dPlot(2:4,:), 'x label', d.tLabel, 'y label', yL,...
    'plot title', 'Control Torque', 'figure title', 'Control Torque');
  yL = d.dLabel(5:end);
  PlotSet( d.tPlot, d.dPlot(5:end,:), 'x label', d.tLabel, 'y label', yL,...
    'plot title', 'Angular Errors', 'figure title', 'Angular Errors');
end
