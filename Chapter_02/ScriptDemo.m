%% This is a template for a script layout.
% A detailed description of the script includes any files loaded or generated
% and an idea of what data and plots will be created. We will calculate a sine
% or cosine with or without scaling of the input. The script creates one plot
% and saves the workspace to a file called Demo.mat.
%% See also
% sin, cos

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All Rights Reserved.

%% User parameters
param1  = 0.5;
nPoints = 50;
useSine = false;

%% Constants
MY_CONSTANT = 0.25;

%% Calculation loop 
yPlot = zeros(2,nPoints);
x     = linspace(0,4*pi,nPoints);
for k = 1:nPoints
  if (useSine)
    y = sin( [1.0;param1]*x(k) + MY_CONSTANT );
  else
    y = cos( [1.0;param1]*x(k) + MY_CONSTANT );
  end
  yPlot(:,k) = y;
end

%% Plotting
figure('Name','DEMO');
plot(x,yPlot);

%% Save workspace to a file
saveDir = fileparts(mfilename('fullpath'));
save(fullfile(saveDir,'Demo'))
