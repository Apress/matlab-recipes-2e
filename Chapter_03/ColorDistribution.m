%% Demonstrate a color distribution for an array of lines.
% Colors are calculated around the color wheel using hsv2rgb.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

val     = 1;
sat     = 1;
n       = 100;
dTheta  = 360/n;
thetaV  = linspace(0,360-dTheta,n);

h       = linspace(0,1-1/n,n);
s       = sat*ones(1,n);
v       = val*ones(1,n);
colors  = hsv2rgb([h;s;v]');
y       = sin(thetaV*pi/180);
hF      = figure;
hold on;
set(hF,'name','Color Wheel')
l = gobjects(n);
for k = 1:n
	l(k) = plot(thetaV,k*y);
end
set(gca,'xlim',[0 360]);
grid on
pause

for k = 1:n
  set(l(k),'color',colors(k,:)*val);
end
