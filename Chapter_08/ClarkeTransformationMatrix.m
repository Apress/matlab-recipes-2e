%% CLARKETRANSFORMATIONMATRIX Compute the Clarke transformation.
% Transforms quantities from [a;b] coordinates to [alpha;beta] coordinates.
% This is the forward Clarke transformation for a Y connected motor.
%
%% Form
%   m = ClarkeTransformationMatrix
%
%% Input
% None.
%
%% Output
%   m  (2,2)  Transformation matrix from [a;b] to [alpha;beta]

%% Copyright
%   Copyright (c) 2015 Princeton Satellite Systems, Inc. 
%   All rights reserved.

function m = ClarkeTransformationMatrix

s3	= sqrt(3);
m   = [1 0;1/s3 2/s3];
