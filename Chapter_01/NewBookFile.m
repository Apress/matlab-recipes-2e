%% NEWBOOKFILE Create a new function with the default header style. 
% Pass in a file name and the header template will be printed to that file
% in the current directory. You will be asked to enter a one-line summary.
%% Form
%  NewBookFile( fName, outputIsFile )
%% Input
%  fName         (1,1)    File name
%  outputIsFile  (1,1)    True if a file is created, otherwise header is
%                         printed to the command line.
%% Output
% None.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function NewBookFile( fName, outputIsFile )

if (nargin < 2)
  outputIsFile = false;
end

if (nargin == 0 || isempty(fName)) 
  fName = input('Function name: ','s');
end

% Check if the filename is valid and if such a function already exists.
if (~isvarname(fName))
   error('Book:error','invalid name');
end
if (outputIsFile && exist(fName,'file'))
  error('Book:error','file %s already exists',fName);
end

% Get a one-line description (H1 line) from the user.
comment = input('One-line description: ','s');

% Open the file or specify command line output.
if (outputIsFile)
  fid = fopen([fName '.m'],'wt');
  c = onCleanup(@() fclose(fid));
else
  fid = 1;
  fprintf(fid,'\n');
end

% Write the header to the file. Use the current year for the copyright
% notice.
fprintf(fid,'%%%% %s %s\n',upper(fName),comment);
fprintf(fid,'%% Description.\n');
fprintf(fid,'%%%% Form\n');
fprintf(fid,'%%  y = %s( x )\n',fName);
fprintf(fid,'%%%% Input\n');
fprintf(fid,'%%   x   (1,1)    Description\n%%\n');
fprintf(fid,'%%%% Output\n');
fprintf(fid,'%%   y   (1,1)    Description\n%%\n');
fprintf(fid,'%%%% Reference\n');
fprintf(fid,'%% Insert the reference.\n');
fprintf(fid,'%%%% See also\n');
fprintf(fid,'%% List pertinent functions.\n\n');

today = strsplit(date,'-');
year = today{end};

fprintf(fid,'%%%% Copyright\n');
fprintf(fid,'%% Copyright (c) %s Princeton Satellite Systems, Inc.\n%% All rights reserved.\n',year);
fprintf(fid,'\nfunction y = %s(x)\n',fName);

if outputIsFile
  edit(fName);
end
