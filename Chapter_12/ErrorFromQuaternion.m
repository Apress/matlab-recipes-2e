%% ERRORFROMQUATERNION Compute small angle error between two quaternions.
%% Form
%  deltaAngle = ErrorFromQuaternion( q, qTarget )
%% Description
% Computes the small angle error between two nearby quaternions.
% This algorithm is not valid for large differences.
%
%% Inputs
%   q           (4,1) Current quaternion
%   qTarget     (4,1) Target quaternion
%
%% Outputs
%   deltaAngle  (3,1) Small angles between q and qTarget

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function deltaAngle = ErrorFromQuaternion( q, qTarget )

deltaQ      = QMult( QPose(q), qTarget );
deltaAngle  = -2.0*deltaQ(2:4);


%% ErrorFromQuaternion>QMult Multiply two quaternions
% Q2 transforms from A to B and Q1 transforms from B to C
% so Q3 transforms from A to C. 
%
%   Q3 = QMult( Q2 ,Q1 )
function Q3 = QMult( Q2 ,Q1 )

Q3 = [Q1(1,:).*Q2(1,:) - Q1(2,:).*Q2(2,:) - Q1(3,:).*Q2(3,:) - Q1(4,:).*Q2(4,:);...
      Q1(2,:).*Q2(1,:) + Q1(1,:).*Q2(2,:) - Q1(4,:).*Q2(3,:) + Q1(3,:).*Q2(4,:);...
      Q1(3,:).*Q2(1,:) + Q1(4,:).*Q2(2,:) + Q1(1,:).*Q2(3,:) - Q1(2,:).*Q2(4,:);...
      Q1(4,:).*Q2(1,:) - Q1(3,:).*Q2(2,:) + Q1(2,:).*Q2(3,:) + Q1(1,:).*Q2(4,:)];
    

%% ErrorFromQuaternion>QPose Transpose of a quaternion
% The transpose requires changing the sign of the angle terms. 
%
%   q = QPose(q)
function q = QPose(q)

q(2:4,:) = -q(2:4,:);

