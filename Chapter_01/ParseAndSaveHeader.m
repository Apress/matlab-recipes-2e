%% PARSEANDSAVEHEADER Save the header of a function to a new file.
% A copy of the source file is saved with a suffix of _orig. The header is saved
% back to the named file, replacing it.
%% Form
%   ParseAndSaveHeader( readFromFile, writeToFile )
%
%% Inputs
%   readFromFile (1,:) Path to the source file
%   writeToFile  (1,:) Path to the destination file. This may be 1 for
%                      standard out.
%
%% Outputs
% None.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function ParseAndSaveHeader( readFromFile, writeToFile )

filePath = which(readFromFile);
[pathStr,name,ext] = fileparts(filePath);

copyfile(filePath,fullfile(pathStr,[name,'_orig',ext]));

fid = fopen(filePath,'rt');
t = fgetl(fid);
hlp = '';
while( ~isempty(t) && strcmp(t(1),'%') )
  if length(t)>1 && strcmp(t(2),'%')
    t = ['%' t];
  end
  hlp = [hlp,'\n%',t];
  t = fgetl(fid);
  if( ~ischar(t) )
    break;
  end
end
hlp = [hlp,'\n%%\n%% This function was parsed on ',date,'\n\n'];
fclose(fid);
if ischar(writeToFile)
  fid = fopen(writeToFile,'wt');
else
  fid = writeToFile;
end
fprintf(fid,hlp);
if ischar(writeToFile)
  fclose(fid);
end

pcode(filePath);