%% Simulation of a pH neutralization process
% Simulates a model of a pH process. The process consists of an acid
% (HNO3) stream, buffer (NaHCO3) stream, and base (NaOH) stream that are 
% mixed in a stirred tank. The chemical equilibria is modeled by 
% introducing two reaction invariants for each inlet stream. Our control
% will be the flow rate of the base stream to maintain a neutral pH (of 7).

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

%% User inputs

% Time (sec)
tEnd = 60*60;
dT   = 1.0;

% States
wA4 = -4.32e-4; % Reaction invariant A for effluent stream (M)
wB4 =  5.28e-4; % Reaction invariant B for effluent stream (M)
h   = 14.0;     % liquid level (cm)

% Closed or open loop
controlIsOn = true;

% Disturbances
% The pulses will be applied according to the start and end times of tPulse:
%    q1 = q10 + deltaQ1;  and   q2 = q20 + deltaQ2;
% Small pulse: 0.65 ml/s in q2
% Large pulses: 2.0 ml/s
% Very large pulses: 8.0 ml/s
deltaQ1 = 8.0; % +/- 1.5 
deltaQ2 = 0.0; % 0.65 1.45 0.45 -0.55 % values from reference
tPulse1 = [5 15]*60;
tPulse2 = [5 35]*60;

%% Data format
dSensor = PHSensor('struct');
d       = RHSpH;

%% Control design
pHSet  = 7.0;
tau    = 60.0; % (sec)
kF     = 2.0;  % forward gain
q3Set  = 15.6; % (ml/s)
q10    = d.q1;
q20    = d.q2;

%% Run the simulation

% Number of sim steps
n = ceil(tEnd/dT);

% Plotting arrays
xP = zeros(7,n);
t  = (0:n-1)*dT;

% Initial states
x      = [wA4;wB4;h];
intErr = 0;

for k = 1:n
  % Measurement
  dSensor.wA4 = x(1);
  dSensor.wB4 = x(2);
  pH          = PHSensor( x, dSensor );
  
  % Proportional-integral Control
  err = pH - pHSet;
  if controlIsOn
    d.q3   = q3Set - kF*(err + intErr/tau);
    intErr = intErr + dT*err;
  else
    d.q3 = q3Set;
  end
  
  % Disturbance
  if( t(k) > tPulse1(1) && t(k) < tPulse1(2) )
    d.q1 = q10 + deltaQ1;
  else
    d.q1 = q10;
  end
  
  if( t(k) > tPulse2(1) && t(k) < tPulse2(2) )
    d.q2 = q20 + deltaQ2;
  else
    d.q2 = q20;
  end
  
  % Store data for plotting
  xP(:,k) = [x;pH;d.q1;d.q2;d.q3];
  
  % Integrate one step
  x = RungeKutta( @RHSpH, 0, x, dT, d );
end

%% Plot
[t,tL]	= TimeLabel(t);
yL      = {'W_{a4}' 'W_{b4}' 'h' 'pH' 'q_1' 'q_2' 'q_3'};
tTL     = 'PH Process Control';
if ~controlIsOn
  tTL = [tTL ' - Open Loop'];
end
PlotSet( t, xP,'x label',tL,'y label',yL,'plot title',tTL,'figure title',tTL)
PlotSet( t, xP([4 7],:),'x label',tL,'y label',yL([4 7]),'plot title',tTL,'figure title',tTL)
