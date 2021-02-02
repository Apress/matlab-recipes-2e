%% DRAWSCARA Draw a SCARA robot arm.
%
%% Forms
%      DrawSCARA( 'initialize', d )
%  m = DrawSCARA( 'update', x )
%
%% Description
% Draws a SCARA robot using patch objects. A persistent variable is used to
% store the graphics handles in between update calls.
%
% The SCARA acronym stands for Selective Compliance Assembly Robot Arm
% or Selective Compliance Articulated Robot Arm.
%
% Type DrawSCARA for a demo.
%
%% Inputs
%  action  (1,:) Action string
%  x       (3,:) [theta1;theta2;d3]
%    or
%  d        (.)  Data structure for dimensions
%                 .a1 (1,1) Link arm 1 joint to joint
%                 .a2 (1,1) Link arm 2 joint to joint
%                 .d1 (1,1) Height of link 1 and link2
%
%% Outputs
%  m       (1,:) If there is an output it makes a movie using getframe

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function m = DrawSCARA( action, x )

persistent p

% Demo
%-----
if( nargin < 1 )
  disp('Demo of DrawSCARA using the default data:');
  DrawSCARA( 'initialize' );
  t       = linspace(0,100);
  omega1  = 0.1;
  omega2  = 0.2;
  omega3  = 0.3;
  x       = [sin(omega1*t);sin(omega2*t);0.01*sin(omega3*t)];
  m       = DrawSCARA( 'update', x );
  snapnow;  % publishing
  if( nargout < 1 )
    clear m;
  end
  return
end

switch( lower(action) )
  case 'initialize'
    if( nargin < 2 )
      d	= SCARADataStructure;
    else
      d	= x;
    end
    
    p = Initialize( d );
    
  case 'update'
    if( nargout == 1 )
      m = Update( p, x );
    else
      Update( p, x );
    end
end


%%% DrawSCARA>Initialize
% Initialize the picture. The robot is defined using these parameters:
%
%       .b  (1,3) Box dimensions [x y z] See Box
%       .l1 (1,5) Link arm 1 dimensions [x y z t d] See UChannel
%       .l2 (1,3) Link arm 2 dimensions [x y z] See Box
%       .c1 (1,2) Cylinder 1 [r l]
%       .c2 (1,2) Cylinder 2 [r l]
%       .c3 (1,2) Cylinder 3 [r l]
%       .c4 (1,2) Cylinder 4 [r l]
%
% *Form*
%
%   p = Initialize( d )
function p = Initialize( d )

p.fig	= figure( 'name','SCARA' );

% Create parts
c = [0.5 0.5 0.5]; % Color
r = [1.0 0.0 0.0];

% Store for use in updating
p.a1 = d.a1;
p.a2 = d.a2;

% Physical parameters for drawing
d.b  = [1 1 1]*d.d1/2;
d.l1 = [0.12 0.02 0.02 0.005 0.03]*10*d.a1;
d.l2 = [0.12 0.02 0.01]*10*d.a2;
d.c1 = [0.1 0.4]*d.a1;
d.c2 = [0.06 0.3]*d.a1;
d.c3 = [0.06 0.5]*d.a2;
d.c4 = [0.05 0.6]*d.a2;

% Base
[vB, fB] = Box( d.b(1), d.b(2), d.b(3) );
[vC, fC] = Cylinder( d.c1(1), d.c1(2) );
f        = [fB;fC+size(vB,1)];
vB(:,3)  = vB(:,3) + d.b(3)/2;
vC(:,3)  = vC(:,3) + d.b(3);
v        = [vB;vC];
p.base   = patch('vertices', v, 'faces', f,...
                 'facecolor', c, 'edgecolor', c,...
                 'facelighting', 'phong' );

% Link 1

% Arm
[vA, fA]    = UChannel( d.l1(1), d.l1(2), d.l1(3), d.l1(4), d.l1(5) );
vA(:,3)     = vA(:,3) + d.d1;
vA(:,1)     = vA(:,1) - d.b(1)/2;

% Pin
[vC, fC]    = Cylinder(  d.c2(1), d.c2(2) );
vC(:,3)     = vC(:,3) + d.d1 - d.c2(2)/2;
vC(:,1)     = vC(:,1) + d.a1 - d.c2(1);
p.v1        = [vC;vA];
f           = [fC;fA+size(vC,1)];
p.link1     = patch('vertices', p.v1, 'faces', f,...
                    'facecolor', r, 'edgecolor', r,...
                    'facelighting', 'phong' );

% Find the limit for the axes
zLim        = max(vC(:,3));

% Link 2
[vB, fB]    = Box(d.l2(1), d.l2(2), d.l2(3) );
[vC, fC]    = Cylinder(  d.c3(1), d.c3(2) );
vC(:,1)     = vC(:,1) + d.l2(1)/2 - 2*d.c3(1);
vC(:,3)     = vC(:,3) - d.c3(2)/2;
p.v2        = [vC;vB];
p.v2(:,1)   = p.v2(:,1) + d.l2(1)/2 - 2*d.c3(1); 
p.v2(:,3)   = p.v2(:,3) + d.d1;
f           = [fC;fB+size(vC,1)];
v2          = p.v2;
v2(:,1)     = v2(:,1) + d.a1;
p.link2     = patch('vertices', v2, 'faces', f,...
                    'facecolor', r, 'edgecolor', r,...
                    'facelighting', 'phong' );

% Link 3
[vC, fC]    = Cylinder(  d.c4(1), d.c4(2) );
p.v3        = vC;
p.r3        = d.l2(1) - 4*d.c3(1);
p.v3(:,3)   = p.v3(:,3) + d.d1/4;
vC(:,1)     = vC(:,1) + p.r3  + d.a1;
f           = fC;
p.link3     = patch('vertices', vC, 'faces', f,...
                    'facecolor', c, 'edgecolor', c,...
                    'facelighting', 'phong' );

xLim        = 1.3*(d.a1+d.a2);
xlabel('x');
ylabel('y');
zlabel('z');
grid on
rotate3d on
axis([-xLim xLim -xLim xLim 0 zLim])
set(gca,'DataAspectRatio',[1 1 1],'DataAspectRatioMode','manual')
s = 10*max(sqrt(sum(v'.^2,1)));
light('position',s*[1 1 1])
view([1 1 1])

%%% DrawSCARA>Update
% Update the picture and get the frame if requested.
%
%   m = Update( p, x )
function m = Update( p, x )

if( nargout > 0 )
  % Allocate movie frame array
  n = getframe(p.fig);
  m(1:size(x,2)) = n;
end
  
for k = 1:size(x,2)
  
  % Link 1
  c       = cos(x(1,k));
  s       = sin(x(1,k));
  b1      = [c -s 0;s c 0;0 0 1];
  v       = (b1*p.v1')';
  set(p.link1,'vertices',v);
  
  % Link 2
  r2      = b1*[p.a1;0;0];  
  c       = cos(x(2,k));
  s       = sin(x(2,k));  
  b2      = [c -s 0;s c 0;0 0 1];
  v       = (b2*b1*p.v2')';  
  v(:,1)  = v(:,1) + r2(1);
  v(:,2)  = v(:,2) + r2(2);  
  set(p.link2,'vertices',v);
  
  % Link 3
  r3      = b2*b1*[p.r3;0;0] + r2;
  v       = p.v3;  
  v(:,1)  = v(:,1) + r3(1);
  v(:,2)  = v(:,2) + r3(2);
  v(:,3)  = v(:,3) + x(3,k);  
  set(p.link3,'vertices',v);
  
  if( nargout > 0 )
    m(k) = getframe(p.fig);
  else
    drawnow;
  end
  
end


%%% DrawSCARA>Box
%
%   [v, f] = Box( x, y, z )
%
% *Inputs*
%
%   Box
%   x           (1,1)  x length
%   y           (1,1)  y length
%   z           (1,1)  z length
%
% *Outputs*
%
%   v           (:,3) Vertices
%   f           (:,3) Faces
function [v, f] = Box( x, y, z )

f   = [2 3 6;3 7 6;3 4 8;3 8 7;4 5 8;4 1 5;2 6 5;2 5 1;1 3 2;1 4 3;5 6 7;5 7 8];
x   = x/2;
y   = y/2;
z   = z/2;

v = [-x  x  x -x -x  x  x -x;...
     -y -y  y  y -y -y  y  y;...
     -z -z -z -z  z  z  z  z]'; 
   
 
%%% DrawSCARA>Cylinder
% Draw a cylinder with 10 segments.
%  
%   [v, f] = Cylinder( r, l )
%
% *Inputs*
%
%   r           (1,1) Radius
%   l           (1,1) Length
%
% *Outputs*
% 
%   v           (:,3) Vertices
%   f           (:,3) Faces
function [v, f] = Cylinder( r, l )

n = 10; % Number of segments

angle = linspace(0,2*pi,n+1)';
angle = angle(1:(end-1));
cS    = [cos(angle) sin(angle)];
v     = [ 0 0 0;...
          r*cS  zeros(n,1);...
          r*cS l*ones(n,1);...
          0 0 l];
		  

k1T = 2;
k2T = n+1;
k1B = n+2;
k2B = 2*n+1;
kBC = 2*n+2;

kT  = (k1T:k2T)';
kB  = (k1B:k2B)';
kBO = [((k1B+1):k2B)';k1B];
kTO = [((k1T+1):k2T)';k1T];

% Cone
f = [kT   kBO kB; kBO  kT  kTO ];

% Top cap
f = [fliplr([ones(n,1) kT kTO]);f];

% Bottom cap
f = [f;[kBC*ones(n,1) kB kBO]];


%%% DrawSCARA>UChannel
% Draw a box with a u cut at the +x end.
%
%   [v, f] = UChannel( x, y, z, t, d )
%
% *Inputs*
%
%   x           (1,1)  x length
%   y           (1,1)  y length
%   z           (1,1)  z length
%   t           (1,1)  Flange thickness
%   d           (1,1)  Depth of cut in x
%   
% *Outputs*
%
%   v           (16,3) Vertices
%   f           (12,3) Faces
%--------------------------------------------------------------------------
function [v, f] = UChannel( x, y, z, t, d )

% One side
%---------
z = z/2;
y = y/2;
v = [0   0  z;...     %1
     x   0  z;...     %2
     x   0  z-t;...   %3
     x-d 0  z-t;...   %4
     x-d 0 -z+t;...   %5
     x   0 -z+t;...   %6
     x   0 -z;...     %7
     0   0 -z];       %8
 
 
vN      = v;
vN(:,2)	= vN(:,2) - y;
vP      = v;
vP(:,2) = vP(:,2) + y;

v       = [vN;vP];

f       = [1 4 2;...
           4 3 2;...
           8 4 1;...
           8 5 4;...
           8 7 5;...
           5 7 6];
       
f       = [f;f+8];
f       = [f;...
             1  2  9;... % +Y
             9  2 10;...
             8 16  7;... % -Y
            16 15  7;...
             1  9  8;... % -X
             8  9 16;...
             4  5 12;... % +X
            12  5 13;...
             6  7 14;... % -Z Tip
             7 15 14;...
             3 10  2;... % +Z Tip
             3 11 10;...
             4 12  3;... % +Z Inside face
             3 12 11;...
             5  6 14;... % -Z Inside face
             5 14 13];

