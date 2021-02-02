%% WARNINGSTEST Test generation of warnings.
%% Form
%   tests = WarningsTest
%% Output
%   tests   (:)   Array of Tests.

function tests = WarningsTest
% Create an array of local functions
tests = functiontests(localfunctions);
end

%% Test Functions
function passTest(testCase)
warnFun = @() warning('PSS:Book:id','Warning!');
testCase.verifyWarning(warnFun, 'PSS:Book:id');
end

function failTest(testCase)
warnFun = @() warning('Wrong:id','Warning!');
testCase.verifyWarning(warnFun, 'PSS:id', 'Wrong id');
end