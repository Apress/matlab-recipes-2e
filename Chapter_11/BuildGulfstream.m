%% Create a CAD model of the ISS
% Loads data from ISS2.obj, this takes some time. Saves the model it in a mat
% file, ISS.mat. The data from an obj file is not the complete data structure so
% we add the core body, etc in this script.
% -------------------------------------------------------------------------
%  See also BuildCADModel, CreateBody, SaveStructure, ShowCAD
% -------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   Copyright (c) 2020 Princeton Satellite Systems, Inc. 
%   All rights reserved.
%--------------------------------------------------------------------------
%   Since 2020.1
%--------------------------------------------------------------------------

% Load in from an obj file
d = LoadCAD('Gulfstream.obj');

% Create the CAD model for ISS
BuildCADModel( 'initialize' );
BuildCADModel( 'set name' ,	'Gulfstream' );
BuildCADModel( 'set units',	'mks'     );

m = CreateBody( 'make', 'name', 'Core' );
BuildCADModel('add body', m );

% This creates the connections between the bodies
BuildCADModel( 'compute paths' );

% Add in the components
for k = 1:length(d.component)
  d.component(k).inside = 0;
  d.component(k).rA = d.component(k).rA - [0;24.5;18];
  BuildCADModel( 'add component', d.component(k) );
end

g  = BuildCADModel('get model');

SaveStructure( g, 'Gulfstream' );
ShowCAD( g );


%--------------------------------------
% $Date: 2020-07-23 00:00:17 -0400 (Thu, 23 Jul 2020) $
% $Revision: 53155 $
