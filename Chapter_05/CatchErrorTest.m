%% Test that we get the expected error, and pass
errFun = @() error('PSS:Book:id','Error!');
try
  feval(errFun);
catch ME
  assert(strcmp(ME.identifier,'PSS:Book:id'));
end
  
%% This time we don't get any error at all
wrongFun = @() disp('Some error-free code.');
tf = false;
try
  feval(wrongFun);
  tf = true;
catch ME
  assert(strcmp(ME.identifier,'PSS:Book:id'));
end
if (tf)
  assert(false,'CatchErrorTest: No error thrown');
end

%% Do the same thing but using lasterr
lasterr(''); % reset the lasterr function
errFun = @() error('PSS:Book:id','Use lasterr!');
try
  feval(errFun);
end
[anyerr,anyid] = lasterr;
assert(strcmp(anyid,'PSS:Book:id'));

%% We get an error but the wrong one
errFun = @() error('PSS:Book:wrongid','Error!');
try
  feval(errFun);
catch ME
  assert(strcmp(ME.identifier,'PSS:Book:id'),'CatchErrorTest: Wrong error');
end


