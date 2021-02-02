%% DOT Dot product of two arrays.
%% Forms
%  d = Dot( w, y )
%  d = Dot( w )
%
%% Description
% Dot product with support for arrays. The number of columns of w and y can be:
%
% * Both > 1 and equal
% * One can have one column and the other any number of columns
%
% If there is only one input the dot product will be taken with itself.
%
%% Inputs
%  w  (:,:)  Array of vectors
%  y  (:,:)  Array of vectors
%
%% Outputs
%  d  (1,:)  Dot product of vectors in w and y
%
%% See also
% Cross

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Definition
function d = Dot( w, y )

if( nargin < 2 )
  y = w;
end

cW = size(w,2);
cY = size(y,2);

if( cW == cY )
  d = sum(w.*y); 
		 
elseif( cW == 1)
  d = w'*y; 
		 
elseif( cY == 1)
  d = y'*w;
   
else
  error('PSS:Book:Dot',['w and y cannot have different numbers of columns'...
         ' unless one has only one column']);
end
