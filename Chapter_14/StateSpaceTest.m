classdef StateSpaceTest
  %Tests StateSpace using a Mocking Framework
  %   Tests the StateSpace class using a mocking framework
   
	methods(Abstract,Static)
 
    function DimensionsTest(testCase)
      s = StateSpace([0 1;0 0],[0;1],[2 0],1);
      [nA,mA] = size(s.a);
      [nB,mB] = size(s.b);
      [nC,mC] = size(s.c);
      [nD,mD] = size(s.d);
      testCase.verifyEqual([nA;mB;mC;nA;nD],[nB;mD;nA;mA;nC]);
 
    end
  end

end

