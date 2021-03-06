%--------------------------------------------------------------------------
% OptimalConsumption.m
% L. C. Evans, *An Introduction to Mathematical Optimal Control Theory*.
% Department of Mathematics, University of California, Berkeley,
% Version 0.2, pp. 51-52
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributor: Athul K. Sundarrajan (AthulKrishnaSundarrajan on GitHub)
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function varargout = OptimalConsumption(varargin)
% input arguments can be provided in the format 'OptimalConsumption(p,opts)'

% set local functions
ex_opts = @OptimalConsumption_opts; % options function
ex_output = @OptimalConsumption_output; % output function
ex_plot = @OptimalConsumption_plot; % plot function

% set p and opts (see local_opts)
[p,opts] = DTQP_standardizedinputs(ex_opts,varargin);

%% tunable parameters

%% setup
% time horizon
p.t0 = 0; p.tf = 1.5;

% system dynamics
symb.D = '[y1*u1]';
symb.o.ny = 1; % number of states
symb.o.nu = 1; % number of controls
symb.o.output = 2; % interp1 compatible

% Lagrange term
L(1).left = 0; L(1).right = 2; L(1).matrix = -1;
L(2).left = 1; L(2).right = 2; L(2).matrix = 1;

% simple bounds
UB(1).right = 1; UB(1).matrix = 1; % controls
LB(1).right = 1; LB(1).matrix = 0;
LB(2).right = 4; LB(2).matrix = 1; % initial states
UB(2).right = 4; UB(2).matrix = 1;

% combine structures
setup.symb = symb; setup.L = L; setup.UB = UB; setup.LB = LB;
setup.t0 = p.t0; setup.tf = p.tf; setup.p = p;

%% solve
[T,U,Y,P,F,in,opts] = DTQP_solve(setup,opts);

%% output
[O,sol] = ex_output(T,U,Y,P,F,in,opts);
if nargout == 1
	varargout{1} = O;
end

%% plot
% disp("paused"); pause % for quasilinearization plots
% ex_plot(T,U,Y,P,F,in,opts,sol)

end
% User options function for this example
function opts = OptimalConsumption_opts
% test number
num = 1;

switch num
case 1
    % default parameters
    opts.general.displevel = 1;
    opts.dt.defects = 'HS';
    opts.dt.quadrature = 'CQHS';
    opts.dt.mesh = 'ED';
    opts.dt.nt = 100; % number of nodes
case 2
    opts.general.displevel = 1;
    opts.dt.defects = 'PS';
    opts.dt.quadrature = 'G';
    opts.dt.mesh = 'LGL';
    opts.dt.nt = 100; % number of nodes
case 3
    opts.general.displevel = 1;
    opts.dt.defects = 'HS';
    opts.dt.quadrature = 'CQHS';
    opts.dt.mesh = 'ED';
    opts.dt.nt = 100; % number of nodes
    opts.qlin.sqpflag = false;
    opts.qlin.trustregionflag = true;
end

end