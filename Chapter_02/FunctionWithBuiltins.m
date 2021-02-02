%% FUNCTIONWITHBUILTINS Function with built-in inputs and outputs
% This function will run a demo if there are no inputs. If there are also no
% outputs it will generate a figure. This is called having "built-in" inputs and
% outputs.
%% Form
%   output = FunctionWithBuiltins( variable, constant )
%% Inputs
%   variable  (1,:)   A variable
%   constant  (1,1)   A constant
%% Output
%   output    (1,:)   Some output

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.


function output = FunctionWithBuiltins( variable, constant )

if (nargin == 0)
  % perform demo
  disp('Perform a demo of FunctionWithBuiltins');
  variable = linspace(0,100);
  FunctionWithBuiltins( variable );
  return;
end

if (nargin < 2 || isempty(constant))
  % default value of constant
  constant = 0.00986;
end

% Body of function with calculations 
output = constant*variable;

if (nargout==0)
  % Default output is a plot
  figure('Name','Demo of MyFunction')
  plot(variable, output)
  clear output
end
