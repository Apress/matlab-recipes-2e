%% Use memoize to store the results

x = rand(2000,2000);

% Create the memorized function
memY = memoize(@schur);

% Evaluate it
tic
y = memY(x);
toc

% Now evaluate the memorized version
tic
y2 = memY(x);
toc