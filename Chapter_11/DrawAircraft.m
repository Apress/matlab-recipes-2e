
%% Draws an aircraft
% 
% Draws an aircraft consisting of multiple components.
%
%% Form
%   h = DrawAircraft( 'initialize', g )
%   DrawAircraft( 'update', g, h, x, t, tU )

%% Inputs
%   action    (1,:) 'initialize', 'update', 'movie'
%   g         (.)
%                   .name       (1,:) Name of object
%                   .radius     (1,1) Radius of the entire object
%                   .component  (.)   Component data structure
%                                     .v        (:,3)   Vertices
%                                     .f        (:,3)   Faces
%                                     .color    (1,3    Color
%                                     .name     (1,:)   Name of the component
%                   .offset     (3,1) Offset of image center
%   h        (1,:) Handles to the patches
%   x        (3,:) [r;v;q;omega]
%   t        (1,:) Time vector
%   tU       (1,:) Time units
%
%% Outputs 
%   h        (.) 
%                 .fig  (1,1) Handles to the figure
%                 .h    (1,k) Handles to the patches
%   mV       (1,:) Movie frames
%

function [h,mV] = DrawAircraft( action, g, h, x, t, tU )

if( nargin < 1 )
  Demo
  return
end

switch( lower(action) )
  case 'initialize'
    
    h.fig = NewFigure( g.name );
    axes('DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1] );

    xlabel('X (m)')
    ylabel('Y (m)')
    zlabel('Z (m)')

    grid on
    view(3)
    rotate3d on
    hold off
    drawnow
    
    n = length(g.component);
    h.h = zeros(1,n);

    for k = 1:n
      h.h(k) = DrawMesh(g.component(k));
    end
     
  case 'update'
    UpdateMesh(h,g.component,x, t, tU);
  
  case 'movie'
    mV = UpdateMesh(h,g.component,x,  t, tU, 1 );

  case 'close'
    close(h.fig);
    
  otherwise
    warning('%s not available',action);
end

%% DrawAircraft>DrawMesh
function h = DrawMesh( m )


h = patch(  'Vertices', m.v, 'Faces',   m.f, 'FaceColor', [0.8 0.8 0.8],...
            'EdgeColor','none','EdgeLighting', 'phong',...
            'FaceLighting', 'phong');
          
 
%% DrawAircraft>UpdateMesh
function mV = UpdateMesh( h, c, x, t, tU, ~ )

hL = [];
hAB = [];

if( nargin > 3 )
  mV(1:size(x,2)) = getframe(h.fig);
else
  mV = [];
end

s  = sprintf('%6.2f %s',t(1),tU);
hT = uicontrol( h.fig,'style','edit','string',s,'position',[10 10 100 20]);   

qY = Mat2Q([1 0 0;0 -1 0;0 0 -1]);

for j = 1:size(x,2)
  m = Q2Mat(x(7:10,j));
  r = x(1:3,j);
  for k = 1:length(c)
    v       = (m*c(k).v')';
    v(:,1)  = v(:,1) + r(1);
    v(:,2)  = v(:,2) + r(2);
    v(:,3)  = v(:,3) + r(3);
    set(h.h(k),'vertices',v);
  end
  xL = get(gca,'xlim');
  yL = get(gca,'ylim');
  zL = get(gca,'zlim');
 
  if(~isempty(hL) )
    delete(hL);
  end
  hL = light('position',10*[xL(2) yL(2) zL(2)]);
  
  r = x(1:3,j);
  v = x(4:6,j);
  q = QMult(qY,x(7:10,j));
  
  if( ~isempty(hAB) )
    delete(hAB);
  end
  
  set(hT,'string',sprintf('%6.2f %s',t(j),tU));
  hAB = DrawAlphaBeta( r, q, Unit(v), 14 );
  if( nargin > 3 )
    mV(j) = getframe(h.fig);
  end
  pause(0.1);
  drawnow
end

%% DrawaAircraft>Demo
function Demo

g       = LoadOBJ('Gulfstream.obj');

h   = DrawAircraft( 'initialize', g );

dToR = pi/180;
n   = 100;
z   = linspace(100,400,n);
x   = linspace(0,40000,n);
a   = linspace(0,pi/4,n);
c   = cos(a);
s   = sin(a);
q   = zeros(4,n);
cY  = cos(15*dToR);
sY  = sin(15*dToR);
mY  = [cY 0 -sY;0 1 0;sY 0 cY];

for k = 1:n
  q(:,k) = Mat2Q([1 0 0;0 c(k) s(k);0 -s(k) c(k)]*mY);
end
v   = 100*[1;0;-0.2].*ones(1,100);
s   = [x;zeros(1,n);z;v;q];
t   = linspace(0,1000,n);
[~,mV] = DrawAircraft( 'movie', g, h, s, t, 'sec' );

SaveMovie( mV, 'Gulfstream' )

%--------------------------------------------------------------------------
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All Rights Reserved

