%% Script with tests for CompleteTriangle
% Run the tests at the command line using runtests():
% >> runtests('TriangleTest')
%% See also
% CompleteTriangle

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved

%% Test 1: sum of angles
% Test that the angles add up to 180 degrees.
C = 30;
[A,B] = CompleteTriangle(1,2,C);
theSum = A+B+C;
assert(theSum == 180,'PSS:Book:triangle','Sum of angles: %f',theSum)

%% Test 2: isosceles right triangles
% Test that if sides a and b are equal, angles A and B are equal.
C = 90;
[A,B] = CompleteTriangle(2,2,C);
assert(A == B,'PSS:Book:triangle','Isoceles Triangle')

%% Test 3: 3-4-5 right triangle
% Test that if side a is 3 and side b is 4, side c (hypotenuse) is 5.
C = 90;
[~,~,c] = CompleteTriangle(3,4,C);
assert(c == 5,'PSS:Book:triangle','3-4-5 Triangle')

%% Test 4: equilateral triangle
% Test that if sides a and b are equal, all angles are 60.
[A,B,c] = CompleteTriangle(1,1,60);
assert(A == 60,'PSS:Book:triangle','Equilateral Triangle %d',1)
assert(B == 60,'PSS:Book:triangle','Equilateral Triangle %d',2)
assert(c == 1,'PSS:Book:triangle','Equilateral Triangle %d',3)

% with tolerance
% assert(abs(A-60)<1e-10,'PSS:Book:triangle','Equilateral Triangle %d',1) 
% assert(abs(B-60)<1e-10,'PSS:Book:triangle','Equilateral Triangle %d',2)
