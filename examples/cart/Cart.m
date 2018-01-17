%--------------------------------------------------------------------------
% Cart.m
% pp. 124-126 of D. H. Ballard, An Introduction to Natural Computation. 
% MIT Press, 1999, isbn: 9780262522588
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function varargout = Cart(varargin)

% number of time points
p.nt = 100;

% if input arguments are provided
% Cart(p,p.nt,opts,opts.Quadmethod,opts.Defectmethod,opts.NType)
if nargin >= 1
    p = varargin{1};
end
if nargin >= 2
    p.nt = varargin{2};
end
if nargin >= 3
    opts = varargin{3};
end
if nargin >= 4
    opts.Quadmethod = varargin{4};
end
if nargin >= 5
    opts.Defectmethod = varargin{5};
end
if nargin >= 6
    opts.NType = varargin{6};
end
if nargin > 6
    warning('too many input arguments...');
end

% set current file name and path
[mpath,mname] = fileparts(mfilename('fullpath'));
opts.mpath = mpath;
opts.mname = mname;

%% tunable parameters
p.t0 = 0;

%% setup
p.tf = 1; % time horizon
setup.p = p;

% system dynamics
A = [0 1; 0 -1]; 
B = [0;1];

% Lagrange term
L(1).left = 1; % control variables
L(1).right = 1; % control variables
L(1).matrix(1,1) = 1/2; % 1/2*u.^2

% Mayer term
M(1).left = 0; % singleton
M(1).right = 5; % final states
M(1).matrix = [-1,0];

% initial states
LB(1).right = 4; % initial states
LB(1).matrix = [0;0];
UB(1).right = 4; % initial states
UB(1).matrix = [0;0];

% combine structures
setup.A = A; setup.B = B; setup.L = L; setup.M = M; 
setup.LB = LB; setup.UB = UB;

%% solve
[T,U,Y,P,F,p,opts] = DTQP_solve(setup,opts);

%% output
[O,sol] = Cart_output(T,U,Y,P,F,p,opts);
if nargout == 1
	varargout{1} = O;
end

%% plot
Cart_plot(T,U,Y,P,F,p,opts,sol)