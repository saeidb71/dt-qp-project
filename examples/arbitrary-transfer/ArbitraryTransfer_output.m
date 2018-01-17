%--------------------------------------------------------------------------
% ArbitraryTransfer_output.m
% Output function for ArbitraryTransfer example
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [O,sol] = ArbitraryTransfer_output(T,U,Y,P,F,p,opts)

% solution
sol = []; % no exact solution

% outputs
O(1).value = max(opts.QPcreatetime);
O(1).label = 'QPcreatetime';
O(2).value = max(opts.QPsolvetime);
O(2).label = 'QPsolvetime';