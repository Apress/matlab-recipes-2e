%% OVERLOADEDFUNCTION An example of an internally overloaded function with actions.
% There are three actions defined. The function will throw an error if there are
% no inputs.
%% Forms
%       d = OverloadedFunction('default data');
%           OverloadedFunction('demo');
%   [y,d] = OverloadedFunction('update',x,d);

%% Copyright 
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.
%%

function varargout = OverloadedFunction( action, varargin )

switch action
  case 'default data'
    d = DefaultData;
    varargout{1} = d;
    
  case 'demo'
    d = DefaultData;
    x = linspace(0,1);
    y = OverloadedFunction('update',x,d);
    figure('name','OverloadedFunction Demo');
    plot(x,y);
    
  case 'update'
    x = varargin{1};
    d = varargin{2};
    y = Update(x,d);
    varargout{1} = y;
    varargout{2} = d;
    
end


function d = DefaultData

d = struct('a',3.0,'b',2.0,'c',1.0);


function y = Update(x,d)

p = [d.a d.b d.c];
y = polyval(p,x);
