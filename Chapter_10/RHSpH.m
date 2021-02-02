%% RHSPH Dynamics of a chemical mixing process.
% The process consists of an acid (HNO3) stream, buffer (NaHCO3) stream,
% and base (NaOH) stream that are mixed in a stirred tank. The mixed effluent
% exits the tank through a valve. The chemical equilibria is modeled by
% introducing two reaction invariants for each inlet stream. i = 1 for the
% acid, i = 2 for the buffer, i = 3 for the base, and i = 4 for the
% effluent.
%
%           +        -          -          =
%   wAi = [H ]i - [OH ]i - [HCO3 ]i - 2[CO3 ]i
%                         -          =
%   wBi = [H2CO3]i + [HCO3 ]i + 2[CO3 ]i
%
%% Forms
%   d    = RHSpH
%   xDot = RHSpH( t, x, d )
%
%% Inputs
%   t           (1,1) Time, unused
%   x           (3,1) State [wA4;wB4;h]
%   d            (.)  Structure
%                     .wA1       (1,1) Acid invariant A, (M)
%                     .wA2       (1,1) Buffer invariant A, (M)
%                     .wA3       (1,1) Base invariant A, (M)
%                     .wB1       (1,1) Acid invariant B, (M)
%                     .wB2       (1,1) Buffer invariant B, (M)
%                     .wB3       (1,1) Base invariant B, (M)
%                     .a         (1,1) Cross-sectional area of mixing tank (cm2)
%                     .cV        (1,1) Valve coefficient
%                     .n         (1,1) Valve exponent
%                     .z         (1,1) Vertical distance between bottom of
%                                      tank and outlet of effluent (cm)
%                     .q1        (1,1) Volumetric flow of HNO3   (ml/s)
%                     .q2        (1,1) Volumetric flow of NaHCO3 (ml/s)
%                     .q3        (1,1) Volumetric flow of NaOH   (ml/s)
%
%% Outputs
%   xDot        (3,1) State derivative
%
%% Reference
% Henson, M. A. and D. E. Seborg. (1997.) Nonlinear Process 
% Control,  Prentice-Hall. pp. 207-210.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function xDot = RHSpH( ~, x, d )

if( nargin < 1 )
  % Note: Cv was omitted in the reference; we calculated it assuming a constant
  % liquid level in the tank of 14 cm.
  d = struct('wA1',0.003,'wA2',-0.03,'wA3',-3.05e-3,...
             'wB1',0.0,  'wB2', 0.03,'wB3', 5.0e-5,...
             'a',207,'cV',4.5860777,'n',0.607,'z',11.5,...
             'q1',16.6,'q2',0.55,'q3',15.6);
  xDot = d;
  if( nargout == 0 )
    disp('RHSpH struct:');
  end
  return;
end

wA4   = x(1);
wB4   = x(2);
h     = x(3);

hA    = 1/(h*d.a);

xDot	= [hA*( (d.wA1 - wA4)*d.q1 + (d.wA2 - wA4)*d.q2 + (d.wA3 - wA4)*d.q3 );...
         hA*( (d.wB1 - wB4)*d.q1 + (d.wB2 - wB4)*d.q2 + (d.wB3 - wB4)*d.q3 );...
         d.q1 + d.q2 + d.q3 - d.cV*(h + d.z)^d.n];

