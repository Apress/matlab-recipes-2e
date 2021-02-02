%% DEBUGLOG Logging function for debugging
% Use this function instead of adding disp() statements or leaving out
% semicolons. 
%% Form
%   DebugLog( msg, fullPath )
%% Decription
% Prints out the data in in msg using disp() and shows the path to the message.
% The full path option will print a complete backtrace.
%% Inputs
%   msg          (.)     Any message
%   fullPath     (1,1)   If entered, print the full backtrace
%% Outputs
%   None

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved

function DebugLog( msg, fullPath )

% Demo
if( nargin < 1 )
  DebugLog(rand(2,2));
  return;
end

% Get the function that calls this one
f = dbstack;

% The second path is only if called directly from the command line
if( length(f) > 1 )
  f1 = 2;
else
  f1 = 1;
end

if( nargin > 1 && fullPath )
  f2 = length(f);
else
  f2 = f1;
end

for k = f1:f2
  disp(['-> ' f(k).name]);
end

str = inputname(1);
if ~isempty(str)
  disp(['Variable: ' str]);
end

disp(msg);

