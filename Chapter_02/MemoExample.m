%% Technical Memo Example
% Summary of example objective.
% Evaluate a function, in this case $\sin(x)$, in a loop. Show how the
% equation looks on its own line:
%
% $$ y = sin(x) $$

%% Section 1 Title
% Description of first code block.
% Define a customizable scale factor that is treated as a constant.
SCALE_FACTOR = 1.0;

%% Section 2 Title
% Description of second code block.
% Perform a for loop that updates a figure.
% 
h = figure('Name','Example Memo Figure');
hold on;
y = zeros(1,100);
x = linspace(0,2*pi);
for k = 1:100
	%%% Evaluate the function. Comments not in a block after the title will
	%%% not be included in the main text.
	y(k) = sin(SCALE_FACTOR*x(k));
	plot(x(k),y(k),'.')
end

%% Conclusions
% You can add additional text throughout your script. You can insert lists,
% HTML, links, images, etc.
