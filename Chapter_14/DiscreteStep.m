%% Demonstrate a subclass

% Step response
s   = StateSpaceDiscrete([0 1;0 0],[0;1],[1 0],1,{'r' 'v'},{'u'},{'y'});
s.u = 1;
y   = s.Step(100);

PlotSet(1:length(y),y,'x label','Step','y label','y','figure title','Sub Class Demo')

% Pulse Response
s.u = [zeros(1,20) ones(1,30) zeros(1,50)];

y   = s.Propagate;

PlotSet(1:length(y),y,'x label','Step','y label','y','figure title','Sub Class Demo')

