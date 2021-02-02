%% Demonstrate a GUI that shows the time to go in a process
%% See also 
% TimeDisplayGUI

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Script constants
n   = 10000;
dT  = 0.1;
a   = rand(10,10);

%% Initialize the time display
TimeDisplayGUI( 'initialize', 'SVD', n )

%% Loop
for j = 1:n
  
  % Do something time consuming 
  for k = 1:100
    svd(a);
  end
   
  % Display the status message
  TimeDisplayGUI( 'update' );
   
end

%% Finish
TimeDisplayGUI( 'close' );
