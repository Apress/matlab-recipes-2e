function foo(x,y,z)
%% FOO Example of extended help in subfunctions.
%
% foo(x,y,z)
%
% Your main description of the function and its usage go here. You may
% prefer to limit this to a single screen of output.
%
% More detailed help is in the <a href="matlab: help foo>extended_help">extended help</a>.
%
%% Examples:
% foo(1,2,3)
%
%% See also:
% PARENTFUNCTION
% VARARGFUNCTION

disp(x+y+z);

function extended_help
%EXTENDED_HELP Additional help or description of a subfunction.
%
% Describe additional details of your algorithms or provide examples.

error('This is a placeholder function just for helptext');
