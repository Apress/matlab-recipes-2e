function q = Mat2Q ( m )	
	
%% Converts a transformation matrix to a quaternion.
% Does not check to see that m is orthonormal.
%
%--------------------------------------------------------------------------
%   Form:
%   q = Mat2Q ( m )		
%--------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   m		(3,3)  Orthonormal transformation matrix
%
%   -------
%   Outputs
%   -------
%   q		(4,1)  Equivalent quaternion
%
%--------------------------------------------------------------------------
%  References: Shepperd, S. W., Quaternion from Rotation Matrix,
%              J. Guidance, Vol. 1, No. 3, May-June, 1978, pp. 223-224.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   Copyright (c) 1994 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------
%   Since version 1.
%--------------------------------------------------------------------------

% Find the maximum value among trace(m), m(1,1), m(2,2), m(3,3)
q     = zeros(4,1);

v     = [ trace(m), m(1,1), m(2,2), m(3,3) ];

[~,i] = max(v);

if ( i == 1 )
  q(1) = sqrt( 1 + v(1) );
  q(2) = (m(3,2) - m(2,3)) / q(1);
  q(3) = (m(1,3) - m(3,1)) / q(1);
  q(4) = (m(2,1) - m(1,2)) / q(1);
	
elseif ( i == 2 )
  q(2) = sqrt( 1 + 2*m(1,1) - v(1) );
  q(1) = (m(3,2) - m(2,3)) / q(2);
  q(3) = (m(1,2) + m(2,1)) / q(2); 
  q(4) = (m(1,3) + m(3,1)) / q(2);
	
elseif ( i == 3 )
  q(3) = sqrt( 1 + 2*m(2,2) - v(1) );
  q(1) = (m(1,3) - m(3,1)) / q(3);
  q(2) = (m(1,2) + m(2,1)) / q(3); 
  q(4) = (m(2,3) + m(3,2)) / q(3);
	
elseif ( i == 4 )
  q(4) = sqrt( 1 + 2*m(3,3) - v(1) );
  q(1) = (m(2,1) - m(1,2)) / q(4);
  q(2) = (m(1,3) + m(3,1)) / q(4);
  q(3) = (m(2,3) + m(3,2)) / q(4);
end	
	
% Halve to get q and make sure that q(1) is positive
if( q(1) < 0 )
  q = - 0.5 * q;
else
  q =   0.5 * q;
end

%--------------------------------------
% $Date: 2020-05-19 17:09:52 -0400 (Tue, 19 May 2020) $
% $Revision: 52325 $
