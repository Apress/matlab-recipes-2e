function  SaveMovie( m, fileName )

%% Save a MATLAB movie.
%
% .avi will be appended to the file name.
% 
% Changing the figure window size while recording will cause this function
% to fail.
%
% Type SaveMovie for a demo creating and saving a movie of a SCARA robot.
%
%--------------------------------------------------------------------------
%   Form:
%   SaveMovie( m, fileName )
%--------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   m           (1,1)  Movie file
%   fileName    (1,:)  File name 
%
%   -------
%   Outputs
%   -------
%   None
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   Copyright (c) 2013 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------
%   2019.1 Removed movie2avi and replaced with VideoWriter and writeVideo
%--------------------------------------------------------------------------

% Demo
if( nargin < 1 )
	m = DrawSCARA;
	SaveMovie( m, 'scara' );
	return;
end

file   = sprintf('%s.avi',fileName);
vidObj = VideoWriter(file);
open(vidObj);

for k = 1:length(m)
  writeVideo(vidObj,m(k));
end

close(vidObj);

%--------------------------------------
% $Date: 2020-05-19 17:09:52 -0400 (Tue, 19 May 2020) $
% $Revision: 52325 $
