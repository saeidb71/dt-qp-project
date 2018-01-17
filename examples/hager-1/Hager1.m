%--------------------------------------------------------------------------
% Hager1.m
% W. W. Hager, Runge-Kutta Methods in Optimal Control and the Transformed
% Adjoint System," Numerische Mathematik, vol. 87, no. 2, pp. 247-282, 
% Dec. 2000. doi: 10.1007/s002110000178
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function varargout = Hager1(varargin)

% default parameters
opts.plotflag = 1; % create the plots
opts.saveflag = 0;
opts.displevel = 2;

% if input arguments are provided
% Hager1(p,p.nt,opts,opts.Quadmethod,opts.Defectmethod,opts.NType)
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

%% setup
p.t0 = 0; p.tf = 1; % time horizon

% system dynamics
A = 0.5; 
B = 1; 

% Lagrange term
L(1).left = 1; % control variables
L(1).right = 1; % control variables
L(1).matrix = 1; 
L(2).left = 2; % state variables
L(2).right = 1; % control variables
L(2).matrix = 1; 
L(3).left = 2; % state variables
L(3).right = 2; % state variables
L(3).matrix = 5/4; 

% initial conditions
LB(1).right = 4; % initial states
LB(1).matrix = 1;
UB(1).right = 4; % initial states
UB(1).matrix = 1;

% combine
setup.A = A; setup.B = B; setup.L = L;
setup.LB = LB; setup.UB = UB; setup.p = p;

%% solve
[T,U,Y,P,F,p,opts] = DTQP_solve(setup,opts);

%% output
[O,sol] = Hager1_output(T,U,Y,P,F,p,opts);
if nargout == 1
	varargout{1} = O;
end

%% plot
Hager1_plot(T,U,Y,P,F,p,opts,sol)