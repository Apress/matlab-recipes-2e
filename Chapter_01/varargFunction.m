function [y,varargout] = varargFunction(x,varargin)
% Example of a function using varargin and varargout.
% See also VARARGIN, VARARGOUT

y = varargin{1};
varargout{1} = size(x,1);
varargout{2} = size(x,2);
