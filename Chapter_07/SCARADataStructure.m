%% SCARADATASTRUCTURE Initialize the data structure for all SCARA functions.
%
%% Forms
%  d = SCARADataStructure
%  d = SCARADataStructure( a1, a2, d1, m1, m2, m3 )
%
%% Description
% Create a SCARA robot data structure. Type d = SCARADataStructure for 
% default arguments. The forces and torques are set to zero.
%
%% Inputs
%   a1  (1,1)  Link 1 length
%   a2  (1,1)  Link 2 length
%   d1  (1,1)  Distance of link 1 from ground
%   m1  (1,1)  Link 1 mass
%   m2  (1,1)  Link 2 mass
%   m3  (1,1)  Link 3 mass
%
%% Outputs
%   d  (.)     Data structure
%              .t1 (1,1) Joint 1 torque
%              .t2 (1,1) Joint 2 torque
%              .f3 (1,1) Joint 3 force

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function d = SCARADataStructure( a1, a2, d1, m1, m2, m3 )

if(  nargin < 1 )
  d = struct('a1',0.1,'a2',0.1,'d1',0.05,'m1',1,'m2',1,'m3',1,'t1',0,'t2',0,'f3',0);
else
  d = struct('a1',a1,'a2',a2,'d1',d1,'m1',m1,'m2',m2,'m3',m3,'t1',0,'t2',0,'f3',0);
end

if( nargout == 0 )
  disp('SCARADataStructure struct:');
end
