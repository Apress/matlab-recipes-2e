%% PARKTRANSFORMATIONMATRIX Compute the reverse Park transformation.
% Transforms quantities from rotating alpha-beta coordinates to stationary
% d-q coordinates. This is the reverse Park transformation, which is just the
% transpose of the forward transformation.
%
%% Form
%   m = ParkTransformationMatrix( thetaE )
%
%% Inputs
%  thetaE (1,1)  Electrical angle (rad)
%
%% Outputs
%   m     (2,2)  Transformation matrix from [alpha;beta] to [d;q]

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function m = ParkTransformationMatrix( thetaE )

c = cos(thetaE);
s = sin(thetaE);

m = [c s;-s c];
