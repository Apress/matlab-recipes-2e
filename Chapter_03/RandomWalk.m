%% Demonstrate a digraph and graph

% Generate a transition matrix
% x ranges from -5 to 5
p = zeros(11,11);
for k = 2:10
  p(k,k-1) = 0.5;
  p(k,k+1) = 0.5;
end

p(1,2)    = 1;
p(11,10)  = 1;

fprintf('%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f%4.1f\n',p);

g = digraph(p);

NewFigure('Digraph');
plot(g)
grid on

g = graph(p,'upper');

NewFigure('Graph');
plot(g)
grid on

n = 100;
m = 50;

NewFigure('Random Walk');
for k = 1:m
  x = zeros(1,n);
  for j = 2:n
    if(x(j-1) == -5)
      x(j) = -4;
    elseif( x(j-1) == 5 )
      x(j) = 4;
    else
      x(j) = x(j-1) + sign(randn);
    end
  end
  plot(x(1:n-1),x(2:n))
  hold on
end
grid on
    



%--------------------------------------------------------------------------
%    Copyright (c) 2020 Princeton Satellite Systems, Inc.
%    All rights reserved.
