%% Add lighting to the cube patch
% We use findobj to locate the patch drawn in Patch, then change its properties
% to be suitable for lighting. We add a local light.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Create the box patch object
BoxPatch;

%% Find and update the patch object
p = findobj(gcf,'type','patch');
c = [0.7 0.7 0.1];
set(p,'facecolor',c,'edgecolor',c,...
      'edgelighting','gouraud','facelighting','gouraud');
material('metal'); 

%% Lighting
l = light('style','local','position',[10 10 10]);

