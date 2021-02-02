
%% Draws angle of attack and sideslip
%
% If your figure does not use axis image the arrows may look strange.
% 
% Type DrawAlphaBeta for a demo.
%
%--------------------------------------------------------------------------
%% Form:
%   DrawAlphaBeta( p0, q, vB, l )
%--------------------------------------------------------------------------
%
%% Inputs
%   p0    (3,1) Origin 
%   q     (4,1) XYZ to body
%   vB    (3,1) Body frame velocity
%   l     (1,1) Vector length
%
%% Outputs 
%   h     (1,:) Handles to objects
%

function h = DrawAlphaBeta( p0, q, vB, l )

% Demo
if( nargin < 1 )
  NewFigure('Angles')
  DrawAlphaBeta( [30;20;10], [1;0;0;0], Unit([1;0.7;0.8]) );
  rotate3d on
  axis image
  view(117,15)
  grid on
  return
end

if( nargin < 4  )
  l = 1;
end

xYZ = QForm(q,eye(3));

p   = zeros(3,4);

for k = 1:3
  p(:,k) = l*xYZ(:,k) + p0;
end

p(:,4) = l*Unit(vB) + p0;

% Lines
n   = size(p,2);
l   = zeros(3,n);
lW  = [1 1 1 3];
c   = [eye(3);0 0 0];
aL  = {'X' 'Y' 'Z' ''};
j   = 1;
h   = zeros(1,20);
for k = 1:n
  h(j)    = line([p0(1);p(1,k)],[p0(2);p(2,k)],[p0(3);p(3,k)],'linewidth',lW(k),'color',c(k,:)); j = j + 1;
  l(:,k)  = p(:,k) - p0;
  h(j)    = text(p(1,k),p(2,k),p(3,k),aL{k},'color',c(k,:)); j = j + 1;
end

% Projections
pJ = [p(1,4) p(1,4);p0(2,1) p(2,4);p(3,4) p0(3,1)];
lJ = zeros(3,2);
for k = 1:2
  h(j)    = line([p0(1);pJ(1,k)],[p0(2);pJ(2,k)],[p0(3);pJ(3,k)],'linestyle','-.'); j = j + 1;
  lJ(:,k) = Unit(pJ(:,k) - p0);
end

% Arc lines
for k = 1:2
  h(j) = line([p(1,4);pJ(1,k)],[p(2,4);pJ(2,k)],[p(3,4);pJ(3,k)],'linestyle','-.'); j = j + 1;
end

% Arrows
lMag    = max(Mag(l));
[v, f]  = Frustrum( 0, 0.01*lMag, 0.05*lMag, 20 );

for k = 1:n
  m   = Q2Mat(U2Q([0;0;1],Unit(l(:,k))));
  vK  = (m*v')';
  for i = 1:size(v,1)
    vK(i,:) = vK(i,:) + l(:,k)' + p0';
  end
  h(j) = patch('vertices',vK,'faces',f,'edgecolor',c(k,:),'facecolor',c(k,:) ); j = j + 1;
end

% Arcs
lKM   = [1;0;0];
blue  = [0 0 1];
name  = {'\alpha', '\beta'};
sN    = [1 -1];
for k = 1:2
  lK  = lJ(:,k);
  u   = Unit(Cross(lK,lKM));
  a   = acos(lK'*lKM);
  r   = lMag/2;
  a   = linspace(0,a);
  c   = cos(a);
  s   = sin(a);
  m   = length(a);  
  b   = Q2Mat(U2Q([0;0;1],u));
  v   = b*r*[c;s;zeros(1,m)];
  aR  = acos(Unit(v(:,1))'*lK);
  b   = Q2Mat(AU2Q(aR,sN(k)*u));
  v   = b*v + p0.*ones(1,size(v,2));
  q   = floor(m/2);
  lT  = v(:,q);
	h(j) = text(lT(1),lT(2),lT(3),sprintf('%s %4.1f deg',name{k}, a(end)*180/pi)); j = j + 1;
  h(j) = patch('vertices',v','faces',[1:m-1; 2:m]','edgecolor',blue); j = j + 1;
end


%--------------------------------------------------------------------------
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All Rights Reserved

