function q = U2Q( u, v )

%% Finds the quaternion that aligns a unit vector with a second vector.
%
% Type U2Q for a demo.
%
%--------------------------------------------------------------------------
%   Form:
%   q = U2Q( u, v )
%--------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   u                   (3,:)    Vector
%   v                   (3,:)    Where vector is after rotation
%
%   -------
%   Outputs
%   -------
%   Q                   (4,:)    Quaternion that rotates u into v
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   Copyright (c) 1994-2001 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------
%   Since version 1.
%--------------------------------------------------------------------------

if( nargin == 0 )
  nTests = 100;
  u      = [  eye(3) rand(3,nTests)];
  v      = [ -eye(3) rand(3,nTests)];
  U2Q(u,v);
  return
end

cU  = size(u,2);
cV  = size(v,2);

if( cU == 1 && cV > 1 )
  u  = DupVect(u,cV);
elseif( cV == 1 && cU > 1 )
  v  = DupVect(v,cU);
elseif( cV ~= cU )
  error('Number of columns of u must equal the number of columns of v or 1')
end

u        = Unit( u );
v        = Unit( v );

c        = Cross( u, v ); 
d        = Dot( u, v );

j        = find( d ~= -1 );
s        = sqrt( 2*(1 + d(j)) );

if( ~isempty(j) )
  q(:,j)    = [ 0.5*s;...
                c(1,j)./s;...
                c(2,j)./s;...
                c(3,j)./s];
end

j        = find( d == -1 );

p        = Unit(Perpendicular( u(:,j) ));
q(:,j)   = [zeros(1,length(j));p];

if( nargout == 0 )
  err = norm(u - QTForm(q,v));
  fprintf('The norm error  (including aligned vectors) is %12.4e\n',err);
  clear q
end

%--------------------------------------
% $Date: 2020-05-19 17:09:52 -0400 (Tue, 19 May 2020) $
% $Revision: 52325 $
