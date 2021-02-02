classdef StateSpaceDiscrete<StateSpace
  %StateSpaceDiscrete Propagates a discrete time system
  %   StateSpace is the base class
  
  methods
    function obj = StateSpaceDiscrete(a,b,c,d,xN,uN,yN)
      if( nargin == 0 )
       a  = [];
       b  = [];
       c  = [];
       d  = [];
       xN = {};
       yN = {};
       uN = {};
      end
      obj@StateSpace(a,b,c,d,xN,uN,yN);
    end
    
    function y = Propagate(obj) 
      %Propagate Propagates the state space system
      %   Propagates the state space system
      n     = size(obj.u,2);
      y     = zeros(size(obj.x,n));
      y(1)  = obj.c*obj.x;
      for k = 2:n
        y(k)  = obj.c*obj.x + obj.d*obj.u(:,k-1);
        obj.x = obj.a*obj.x + obj.b*obj.u(:,k-1);
      end
    end
    
    function y = Step(obj,n) 
      %Step Applies a step to the state space system
      %   Generates the step response. Only the first value of u is used.
      y     = zeros(obj.p,n);
      y(1)  = obj.c*obj.x + obj.d*obj.u(:,1);
      for k = 2:n
        y(k)  = obj.c*obj.x + obj.d*obj.u(:,1);
        obj.x = obj.a*obj.x + obj.b*obj.u(:,1);
      end
    end
  end
end

