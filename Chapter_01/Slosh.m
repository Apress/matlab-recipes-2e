%% Slosh Model
% A slosh model. This also demonstrates a script with a sub function.
% You can run this with a step input or a doublet

n         = 1000; % Number of steps
dT        = 0.1; % Time step
doublet 	= true; % Logical

% Create the data structure for the right hand side
d.i0      = 100; % Inertia of the spacecraft
m0        = 1000; % Mass of the spacecraft used only for the acceleration

% Control system
zeta      = 0.7071; % Damping ratio of the controller
omega     = 0.01; % Undamped natural frequency of the controller
d.pD    	= d.i0*omega*[2*zeta omega];

% Set up the pendulum model
thrust    = 100; % Thrust that produces the slosh pendulum
l         = 0.5; % Length of the slosh pendulum
m         = 10; % Mass of the fuel
a         = thrust/m0; % Acceleration
d.i1      = m*l^2; % Inertia of the fuel slosh disk
d.k       = a*m; % Spring stiffness
d.damp    = 0.05; % Damping

%% Simulate
torque    = 1;
xP        = zeros(4,n);
x         = [0;0;0;0];

for k = 1:n
  xP(:,k)   = x;
  if( doublet )
    if( k == 1 )
      d.torque = torque;
    elseif( k == 2)
      d.torque = -torque;
    else
      d.torque = 0;
    end
  else
    d.torque = torque;
  end
  x	= RK4(@RHSSlosh,x,dT,0,d); % We use a pointer
end

%% Plot the results
[t,tL]  = TimeLabel((0:n-1)*dT);
yL      = {'\phi (rad)' '\theta (rad)' '\omega_0 (rad/s)' '\omega_1 (rad/s)'};

PlotSet(t,xP,'x label',tL,'y label',yL,'figure title','Slosh');

%% Right-hand-side is a script sub function
function xDot = RHSSlosh(x,~,d)

phi         = x(1);
theta       = x(2);
omega0      = x(3);
omega1      = x(4);

torqueHinge = d.k*(theta-phi) + d.damp*(omega1 - omega0);

omega0Dot   = (d.torque - d.pD*x([3 1]) + torqueHinge)/d.i0;
omega1Dot   = -torqueHinge/d.i1;

xDot        = [omega0;omega1;omega0Dot;omega1Dot];

end

