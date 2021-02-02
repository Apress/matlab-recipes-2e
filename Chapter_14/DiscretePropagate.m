%% Demonstrate using methods of a subclass.

a     = [0 1;0 0];
b     = [0;1];
dT    = 0.03;

% Convert to discrete time
[a,b] = C2DZOH(a,b,dT);

% Step response
s   = StateSpaceDiscrete(a,b,[1 0],0,{'r' 'v'},{'u'},{'y'});
s.u = 1;
y   = s.Step(100);

PlotSet(1:length(y),y,'x label','Step','y label','y',...
        'figure title','Sub Class Step');

% Pulse Response
s.u = [zeros(1,20) ones(1,30) zeros(1,50)];

y   = s.Propagate;

PlotSet(1:length(y),y,'x label','Step','y label','y',...
      'figure title','Sub Class Pulse');

