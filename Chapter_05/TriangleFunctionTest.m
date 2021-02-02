%% TRIANGLEFUNCTIONTEST Provide test cases for CompleteTriangle
% This function returns a list of tests contained within. To run the tests, at
% the command line use runtests(): 
% >> runtests('TriangleFunctionTest')
%% Form
%   tests = TriangleFunctionTest
%% Inputs
% None.
%% Outputs
%   tests  (:)  Array of test functions

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved

function tests = TriangleFunctionTest
% Create an array of local functions
tests = functiontests(localfunctions);
end

%%% Test Functions
function testAngleSum(testCase) 
C      = 30;
[A,B]  = CompleteTriangle(1,2,C);
theSum = A+B+C;
testCase.verifyEqual(theSum,180)
end

function testIsosceles(testCase)
C     = 90;
[A,B] = CompleteTriangle(2,2,C);
testCase.verifyEqual(A,B)
end

function test345(testCase)
C       = 90;
[~,~,c] = CompleteTriangle(3,4,C);
testCase.verifyEqual(c,5)
end

function testEquilateral(testCase)
[A,B,c] = CompleteTriangle(1,1,60);
assert(abs(A-60)<testCase.TestData.tol)
testCase.verifyEqual(B,60,'absTol',1e-10)
testCase.verifyEqual(c,1)
end

%%% Optional file fixtures
function setupOnce(testCase)  % do not change function name
% set a tolerance that can be used by all tests
testCase.TestData.tol = 1e-10;
end

function teardownOnce(testCase)  % do not change function name
% change back to original path, for example
end

%%% Optional fresh fixtures
function setup(testCase)  % do not change function name
% open a figure, for example
end

function teardown(testCase)  % do not change function name
% close figure, for example
end
