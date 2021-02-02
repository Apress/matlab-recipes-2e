%% COMPLETETRIANGLE Compute the angles and sides of a triangle
% Given two sides and the interior angle between them, compute the third side
% and remaining angles of the triangle. Follows the convention that the side A
% is opposite the angle a. All angles are in degrees. This requires the four
% quadrant inverse tangent function, atan2.
%% Form
%   [A,B,c] = CompleteTriangle(a,b,C)
%% Inputs
%   a     (1,1)   First side length
%   b     (1,1)   Second side length
%   C     (1,1)   Interior angle (degrees)
%
%% Outputs
%   A     (1,1)   First angle (degrees)
%   B     (1,1)   Second angle (degrees)
%   c     (1,1)   Third side length

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved

function [A,B,c] = CompleteTriangle(a,b,C)

c = sqrt(a^2 + b^2 - 2*a*b*cosd(C));
sinA = sind(C)/c*a;
sinB = sind(C)/c*b;
cosA = (c^2+b^2-a^2)/2/b/c;
cosB = (c^2+a^2-b^2)/2/a/c;
A = atan2(sinA,cosA)*180/pi; 
B = atan2(sinB,cosB)*180/pi; % insert typo: change a B to A

end