%% VERBOSEEIGTEST Demonstrate verbosity levels in tests
% Run a test of the eig function using log messages. Demonstrates
% all four levels of verbosity. To run the tests, at the command line use
% a TestRunner configured with the LoggingPlugIn: 
%
%   import matlab.unittest.TestRunner;
%   import matlab.unittest.plugins.LoggingPlugin;
%   runner = TestRunner.withNoPlugins;
%   runner.addPlugin(LoggingPlugin.withVerbosity(4));
%   results = runner.run(VerboseEigTest);
%% Form
%   tests = VerboseEigTest
%% Inputs
% None.
%% Outputs
%   tests  (:)  Array of test functions

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved

function tests = VerboseEigTest
% Create an array of local functions
tests = functiontests(localfunctions);
end

%% Test Functions
function eigTest(testCase)
log(testCase,'Generating test data'); % default is level 2
m = rand(2000);
A = m'*m;
log(testCase, 1, 'About to call eig.');
[V,D,W] = eig(A);
log(testCase, 4, 'Eig finished.');
assert(norm(W'*A-D*W')<1e-6)
log(testCase, 3, 'Test of eig completed.');
end

% If you want to use the Verbose enumeration in your code instead of numbers,
% import the class matlab.unittest.Verbosity
function eigWithEnumTest(testCase)
import matlab.unittest.Verbosity
m = rand(1000);
A = m'*m;
log(testCase, Verbosity.Detailed, 'About to call eig (with enum).');
[V,D,W] = eig(A);
assert(norm(W'*A-D*W')<1e-6)
log(testCase, Verbosity.Terse, 'Test of eig (with enum) completed.');
end
