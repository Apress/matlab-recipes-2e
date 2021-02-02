%% PDCONTROL Design and implement a PD Controller in sampled time.
%% Forms
%  d = PDControl( 'struct' )
%  d = PDControl( 'initialize', d )
%  [y, d] = PDControl( 'update', u, d )
%
%% Description
% Designs a PD controller and implements it in discrete form.
%
%  y = -c*x - d*u
%  x = a*x + b*u
%
% where u is the input and y is the output. This controller has a first
% order rate filter on the derivative term. 
%
% Set the mode to initialize to create the state space matrices for the
% controller. Set the mode to update to update the controller and get a
% new output.
%
% Utilizes the subfunction C2DZOH to discretize, see <a href="matlab: help PDControl>CToDZOH">CToDZOH help</a>
%
%% Inputs
%  mode    (1,1) 'initialize' or 'update'
%  u       (1,1) Measurement
%  d        (.)  Data structure
%                 .m      (1,1) Mass
%                 .zeta   (1,1) Damping ratio
%                 .wN     (1,1) Undamped natural frequency
%                 .wD     (1,1) Derivative term filter cutoff
%                 .tSamp  (1,1) Sampling period*
%                 .x      (1,1) Controller state
%
%% Outputs
%  y       (1,1) Control
%  d        (.)  Data structure additions
%                 .a      (1,1) State transition matrix
%                 .b      (1,1) Input matrix
%                 .c      (1,1) State output matrix
%                 .d      (1,1) Feedthrough matrix
%                 .x      (1,1) Updated controller state


function [y, d] = PDControl( mode, u, d )

% Demo
if( nargin < 1 )
  disp('Demo of PDControl using the default struct')
  d = PDControl('struct');
  d = PDControl('initialize',d);
  disp(d)
  return
end

switch lower(mode)
  case 'initialize'
    d           = u;
    w           = d.wD + 2*d.zeta*d.wN;
    k           = d.wD*d.wN^2*d.m/w;
    tau         = ((d.m/k)*d.wN*(d.wN + 2*d.zeta*d.wD) - 1 )/w;
    d.a         = -w;
    d.b         =  w;
    d.c         = -k*w*tau;
    d.d         =  k*(tau*w + 1);

    [d.a, d.b]  =  CToDZOH(d.a,d.b,d.tSamp);
    y           = d;
    
  case 'update'
    y   = -d.c*d.x - d.d*u;
    d.x = d.a*d.x + d.b*u;
    
  case 'struct'
    y = DefaultStruct;
    
  otherwise
    error('%s is not a valid mode',mode);
end
 

function [f, g] = CToDZOH( a, b, T )
%% PDControl>CToDZOH
% Continuous to discrete transformation using a zero order hold. Discretize

q  = expm([a*T b*T;zeros(1,2)]);

f  = q(1,1);
g  = q(1,2); 


function d = DefaultStruct
%% PDControl> DefaultStruct

d = struct('m',1,'zeta',0.7,'wN',0.1,'wD',0.5,'tSamp',1.0,'x',0,'a',[],...
           'b',[],'c',[],'d',[]);

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

