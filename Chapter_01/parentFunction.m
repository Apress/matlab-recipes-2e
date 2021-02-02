%% PARENTFUNCTION Example of a parent function with a nested function.
% The constant defined in the parent is in scope for the nested function due to
% the placement of the end keywords.
function y = parentFunction( x )

constant = 3.0;
y = nestedFunction( x );

  function z = nestedFunction( x )

  z = constant*x;
  
  end

end

