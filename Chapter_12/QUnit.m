%% QUNIT Unitize a quaternion.
% The quaternion elements are divided by the quaternion magnitude.
%% Form
%   q = QUnit( q )
%
%% Inputs
%   q      (4,1)  Quaternion
%
%% Outputs
%   q      (4,1)  Quaternion unitized

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

%%
function q = QUnit( q )

q = q/sqrt(q'*q);