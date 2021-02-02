%% Demonstrate DebugLog
% Log a variable to the command window using DebugLog.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved

function DebugLogDemo

y = linspace(0,10);
i = FindInY(y);

function i = FindInY(y)

i = find(y < 0.5);
DebugLog( i, true );
