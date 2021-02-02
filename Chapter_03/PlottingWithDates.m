%% Plot using months as the x label
% First we will set the labels manually. Then we will use MATLAB's serial date
% numbers to set the labels automatically.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Specify specific months as labels
kWh   = [  2500 2600 2900 1500 1300 1500 1600 1000 1400 1100 1200 2300];
month = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'};

figure('Name','Plotting With Manual Date Labels');
bar(1:12,kWh)
xlabel('Month');
ylabel('kWh')
title('Power Consumption');
grid on

set(gca,'xlim',[0 13],'xtick',1:12,'xticklabel',month);

%% Specify full dates and use serial dates to automatically produce labels
% Specifying only the month will use the current year by default. We will set
% the year to 2014 by using datevec.
N = datenum(month,'mmm');
V = datevec(N);
V(:,1) = 2014;
N = datenum(V);

figure('Name','Plotting With Serial Dates');
bar(N,kWh)
xlabel('Date');
title('Power Consumption with datetick');
datetick('x','mm/yy')
grid on