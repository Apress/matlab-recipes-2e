%% Script for debugging PHSensor algorithm

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

% Nominal operating conditions from the reference
x10 = -4.32e-4;
x20 = 5.28e-4;

x       = [];
x(1,:)  = linspace(2*x10,0); 
x(2,:)  = linspace(0,2*x20);  
d       = PHSensor('struct');

% Compute the pH starting from neutral
n   = size(x,2);
pH  = zeros(n,n);
fEvals = zeros(n,n);
pH0 = 7.0;
for k = 1:n
  for j = 1:n
    d.wA4   = x(1,k);
    d.wB4   = x(2,j);
    % Options: TolX, Display, FunValCheck
    % ('TolX',1e-10);
    % ('Display','iter')
    % ('FunValCheck','on') % no errors found for demo
    options = optimset('FunValCheck','on'); 
    [pH(k,j),fval,exitflag,output] = fzero( @Fun, pH0, options, d );  
    fEvals(k,j) = output.funcCount;
  end
end

figure('Name','PH Sensor');
surf(pH,'edgecolor','none')
xlabel('WB4');
ylabel('WA4');
zlabel('pH')
grid on
rotate3d on

figure('Name','Evaluations')
s = pcolor(x(2,:),x(1,:),fEvals);
set(s,'edgecolor','none')
xlabel('WB4');
ylabel('WA4');
colormap jet
title('Function Evaluations by fzero')

