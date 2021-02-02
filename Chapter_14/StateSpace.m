classdef StateSpace
  % StateSpace Dynamical state space class    
  %  This class contains the matrices and vectors for a state space
  %  system. 
  
  properties (Access = public)
    a(:,:) double
    b(:,:) double
    c(:,:) double
    d(:,:) double
    xN(1,:) cell
    uN(1,:) cell
    yN(1,:) cell
    x(:,:) double
    u(:,:) double
    y(:,:) double
  end
  
  properties (Access = protected)
    n(1,1) double
    m(1,1) double
    p(1,1) double
  end
  
  methods
    function obj = StateSpace(a,b,c,d,xN,uN,yN)
      % StateSpace Construct an instance of this class
      %   Checks all of the sizes
      obj.a   = a;
      obj.n   = size(a,1);
      obj.b   = b;
      [n,m]   = size(b);
      if(n ~= obj.n)
        error('b must have as many rows as a');
      end
      obj.m = m; 
      
      [p,n]	= size(c);
      if(n ~= obj.n)
        error('c must have as many columns as a');
      end
      obj.c   = c;
      obj.p   = p;
      
      [p,m]	= size(d);
      if(p ~= obj.p)
        error('d must have as many rows as c');
      end
      if(m ~= obj.m)
        error('d must have as many columns as b');
      end
      obj.d   = d;
      
      if( nargin > 4 )
        n = length(xN);
        if( n ~= obj.n )
          error('xN must have as many strings as the rows of a');
        end
        obj.xN  = xN;
      
        m = length(uN);
        if( m ~= obj.m )
          error('uN must have as many strings as the columns of b');
        end
        obj.uN  = uN;
      
        p = length(yN);
        if( n ~= obj.n )
          error('yN must have as many strings as the rows of c');
        end
        obj.yN  = yN;
      else
        for k = 1:obj.n
          obj.xN{k} = sprintf('%d',k);
        end
        for k = 1:obj.p
          obj.yN{k} = sprintf('%d',k);
        end
        for k = 1:obj.m
          obj.uN{k} = sprintf('%d',k);
        end
      end
      
      obj.x = zeros(n,1);
      obj.u = zeros(m,1);
      obj.y = zeros(p,1);
    end
     
    function e = Eig(obj)
    %Eig Get the eigenvalues
      e = eig(obj.a);
    end
  end
end

