%% EQUILIBRIUMCONTROL Find the equilibrium control for a point mass aircraft.
%% Form
%   [u, c] = EquilibriumControl( x, d, tol )
%
%% Description
% Find the equilibrium controls using fminsearch. It minimizes the right
% hand side of the first three state equations; dx/dt, dy/dt and dh/dt are
% not considered. It will handle multiple sets of state vectors but d
% will be constant.
%
% Type EquilibriumControl for an example with variable altitude.
%
%% Inputs
%   x   (6,:)    State vector [v;gamma;psi;x;y;h]
%   d    {:}     Data structure for RHSAircraft
%   tol (1,1)    Tolerance on search
%
%% Outputs
%   u   (3,:)    Control vector [T;alpha;phi] (Thrust, angle of attack, roll)
%   c   (1,:)    Cost

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function [u, c] = EquilibriumControl( x, d, tol )

% Demo
if( nargin < 1 )
  disp('Demo of EquilibriumControl with variable altitude:');
  x = [200*ones(1,101);...
       zeros(4,101);...
       linspace(0,10000,101)];
  d = RHSAircraft;
  EquilibriumControl( x, d )
  return;
end

% Default tolerance
if( nargin < 3 )
  tol = 1e-8;
end

n   = size(x,2);
u   = zeros(3,n);
c   = zeros(1,n);
p   = optimset('TolFun',tol);
% additional options during testing:
%'PlotFcns',{@optimplotfval,@PlotIteration},'Display','iter','MaxIter',50);
for k = 1:n
  [~,D,LStar] = RHSAircraft(0,x(:,k),d);
  alpha       = d.m*d.g/LStar;
  u0          = [D;alpha;0];
  [umin,cval,exitflag,output] = fminsearch( @Cost, u0, p, x(:,k), d );
  u(:,k)      = umin;
  c(k)        = Cost( u(:,k), x(:,k), d );
end
 
% Plot if no outputs are specified
if( nargout == 0 )
  yL = {'T (N)', '\alpha (rad)', '\phi (rad)' 'Cost'};
  s  = 'Equilibrium Control:Controls';
  PlotSet(1:n,[u;c],'x label','set','y label',yL, ...
          'plot title',s, 'figure title',s);
        
  yL = {'v' '\gamma' '\psi' 'h'};
  s  = 'Equilibrium Control:States';
  PlotSet(1:n,x([1:3 6],:),'x label','set','y label',yL, ...
          'plot title',s,'figure title',s);
  clear u
end


%%% EquilibriumControl>Cost
% Find the cost of a given control u.
%
%  c = Cost( u, x, d )
function c = Cost( u, x, d )

d.thrust	= u(1);
d.alpha   = u(2);
d.phi     = u(3);

xDot      = RHSAircraft(0,x,d);
y         = xDot(1:3);
c         = sqrt(y'*y);


%%% EquilibriumControl>PlotIteration
% Plot an iteration of the numerical search.
%
%   stop = PlotIteration(u0,optimValues,state,varargin)
function stop = PlotIteration(u0,optimValues,state,varargin)

stop = false;
x0 = varargin{1};
d  = varargin{2};
switch state
    case 'iter'
        if optimValues.iteration == 0
          a = PlotSurf( x0, u0, d );
        end
        plot3(u0(1),u0(2),optimValues.fval,'k*');
end


%%% EquilibriumControl>PlotSurf
% Plot a surface using the given initial state for a range of controls.
% MATLAB will already have an empty axis available for plotting.
%
%   a = PlotSurf( x0, u0, d )
function a = PlotSurf( x0, u0, d )

u1 = linspace(max(u0(1)-1000,0),u0(1)+1000);
u2 = linspace(0,max(2*u0(2),0.1));
u3 = u0(3);
cvals = zeros(100,100);

for m = 1:100
  for l = 1:100
    cvals(l,m) = Cost( [u1(m);u2(l);u3], x0, d );
  end
end

s = surf(u1,u2,cvals);
set(s,'edgecolor','none');
a = gca;
set(a,'Tag','equilibriumcontrol');
hold on;
xlabel('Thrust')
ylabel('Angle of Attack')


