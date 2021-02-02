classdef DragTest < matlab.unittest.TestCase & matlab.mock.TestCase
    methods(Test)
        function NegativeDensity(testCase)
          [stubDensity,densityModelBehavior]=createMock(testCase,?DensityModel);
          testCase.assignOutputsWhen(densityModelBehavior.LookUpDensity(-1),-1);
          d = Drag(stubDensity,-1,1,2);
          testCase.verifyLessThan(d,0);
        end
    end
end
     
