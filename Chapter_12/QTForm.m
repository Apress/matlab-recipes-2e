%% QTFORM Transform a vector with the transpose of a quaternion
% Transform a vector opposite the direction of the quaternion.
% The function can transform multiple columns of uA.
%% Form
%   uB = QTForm( q, uA )
%% Inputs
%   q              (4,1)  Quaternion from a to b
%   uA             (3,:)  Vectors in a
%
%% Outputs
%   uB             (3,:)	Vectors in b

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function uB = QTForm( q, uA )

x(1,:)  = q(4)*uA(2,:) - q(3)*uA(3,:);
x(2,:)  = q(2)*uA(3,:) - q(4)*uA(1,:);
x(3,:)  = q(3)*uA(1,:) - q(2)*uA(2,:);

uB      = zeros(size(uA));

uB(1,:) = uA(1,:) + 2*( q(1)*x(1,:) - q(3)*x(3,:) + q(4)*x(2,:) );
uB(2,:) = uA(2,:) + 2*( q(1)*x(2,:) - q(4)*x(1,:) + q(2)*x(3,:) );
uB(3,:) = uA(3,:) + 2*( q(1)*x(3,:) - q(2)*x(2,:) + q(3)*x(1,:) );
