%% PLOTSET Create two-dimensional plots from a data set.
%% Form
%  h = PlotSet( x, y, varargin )
%
%% Decription
% Plot y vs x in one figure.
% If x has the same number of rows as y then each row of y is plotted
% against the corresponding row of x. If x has one row then all of the
% y vectors are plotted against those x variables.
%
% Accepts optional arguments that modify the plot parameters.
%
% Type PlotSet for a demo.
%
%% Inputs
%  x         (:,:)  Independent variables
%  y         (:,:)  Dependent variables
%  varargin   {}    Optional arguments with values
%                     'x label', 'y label', 'plot title', 'plot type'
%
%% Outputs
%  h         (1,1)  Figure handle

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function PlotSet( x, y, varargin )

% Demo
%-----
if( nargin < 1 )
  x = linspace(1,1000);
  y = [sin(0.01*x);cos(0.01*x)];
  disp('PlotSet: One x and two y rows')
  PlotSet( x, y, 'figure title', 'PlotSet Demo' )
	disp('PlotSet: Two x and two y rows')
  PlotSet( [x;y(1,:)], y )

  return;
end
      
% Defaults
nCol      = 1;
n         = size(x,1);
m         = size(y,1);

yLabel    = cell(1,m);
xLabel    = cell(1,n);
plotTitle = cell(1,n);
for k = 1:m
  yLabel{k} = 'y';
end
for k = 1:n
  xLabel{k}     = 'x';
  plotTitle{k}  = 'y vs. x';
end
figTitle = 'PlotSet';
plotType = 'plot';

% Handle input parameters
for k = 1:2:length(varargin)
  switch lower(varargin{k} )
    case 'x label'
      for j = 1:n
        xLabel{j} = varargin{k+1};
      end
    case 'y label'
      temp = varargin{k+1};
      if( ischar(temp) )
        yLabel{1} = temp;
      else
        yLabel    = temp;
      end
    case 'plot title'
      plotTitle{1}  = varargin{k+1};
    case 'figure title'
      figTitle      = varargin{k+1};
    case 'plot type'
      plotType      = varargin{k+1};
    otherwise
      fprintf(1,'%s is not an allowable parameter\n',varargin{k});
  end
end

h = figure;
set(h,'Name',figTitle);

% First path is for just one row in x
if( n == 1 )
  for k = 1:m
    subplot(m,nCol,k);
    plotXY(x,y(k,:),plotType);
    xlabel(xLabel{1});    
    ylabel(yLabel{k});
    if( k == 1 )
      title(plotTitle{1})
    end
    grid on
  end
else
  for k = 1:n
    subplot(n,nCol,k);
    plotXY(x(k,:),y(k,:),plotType);
    xlabel(xLabel{k});
    ylabel(yLabel{k});
    title(plotTitle{k})
    grid on
  end
end


%%% PlotSet>plotXY Implement different plot types
% log and semilog types are supported.
%
%   plotXY(x,y,type)
function plotXY(x,y,type)

switch type
  case 'plot'
    plot(x,y);
  case {'log' 'loglog' 'log log'}
    loglog(x,y);
  case {'xlog' 'semilogx' 'x log'}
    semilogx(x,y);
  case {'ylog' 'semilogy' 'y log'}
    semilogy(x,y);
  otherwise
    error('%s is not an available plot type',type);
end

