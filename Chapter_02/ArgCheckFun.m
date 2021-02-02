function [x,c] = ArgCheckFun(a,b,c)

arguments
  a (2,1) double
  b (2,1) double
  c (1,:) char
end

x = a'*b;

