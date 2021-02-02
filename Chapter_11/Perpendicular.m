function b = Perpendicular( a )

%% Finds perpendicular vectors to a such that Dot(b,a) = 0.
%
%   Type Perpendicular for a demo.
%--------------------------------------------------------------------------
%   Form:
%   b = Perpendicular( a )
%--------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   a                   (3,:)    Input
%
%   -------
%   Outputs
%   -------
%   b                   (3,:)    Perpendicular
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%  Copyright (c) 2001, 2012 Princeton Satellite Systems, Inc. 
%  All rights reserved.
%--------------------------------------------------------------------------

% Demo
%------
if( nargin < 1 )
  a = 2*rand(3,1000)-1;
  Perpendicular( a )
  return
end

nA    = size(a,2);

[m,j] = max( abs(a), [], 1 );

aS    = sum( a, 1 );
b     = ones( 3, nA ); 

for k = 1:nA
  i        = j(k);
  delta    = -aS(k)./a(i,k);
  b(i,k)   = b(i,k) + delta;
end

if( nargout == 0 )
  disp('Dot product')
  disp(norm( Dot(b,a) ));
  clear b
end

% PSS internal file version information
%--------------------------------------
% $Date: 2020-05-19 17:09:52 -0400 (Tue, 19 May 2020) $
% $Revision: 52325 $
