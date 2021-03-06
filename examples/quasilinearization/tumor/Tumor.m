%--------------------------------------------------------------------------
% Tumor.m
% U. Ledzewicz and H. Schättler, Analysis of optimal controls for a
% mathematical model of tumour anti‐angiogenesis, Optim. Control Appl.
% Meth., vol. 29, pp. 41-57, 2008, doi:10.1002/oca.814
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributor: Athul K. Sundarrajan (AthulKrishnaSundarrajan on GitHub)
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function varargout = Tumor(varargin)
% input arguments can be provided in the format 'Tumor(p,opts)'

% set local functions
ex_opts = @Tumor_opts; % options function
ex_output = @Tumor_output; % output function
ex_plot = @Tumor_plot; % plot function

% set p and opts (see local_opts)
[p,opts] = DTQP_standardizedinputs(ex_opts,varargin);

%% tunable parameters
A0 = 15;
b = 5.85; % per day
Mew = 0.02; % per day
G = 0.15; % per mg of dose per day
zeta = 0.084; % per day
D = 0.00873; % per mm^2 per day
p0 = (((b-Mew)/D)^(3/2))/2;
q0 = p0/2;
umax = 75;
y0 = [p0,q0,0];
ymin = [0.1,0.1,-inf];

%% setup
% time horizon
p.t0 = 0; p.tf = 1.2;

% system dynamics
symb.D = '[-zeta*y1*log(y1/y2); y2*(b-(Mew+(D*(y1^(2/3)))+G*u1)); u1]';
symb.o.ny = 3; % number of states
symb.o.nu = 1; % number of inputs
symb.o.output = 2; % interp1 compatible
symb.o.param = 'zeta b Mew D G';
symb.param = [0.0840 5.8500 0.0200 0.00873 0.1500];

% Mayer term
M(1).right = 5; % final states
M(1).left = 0; % singleton
M(1).matrix = [1,0,0];

% simple bounds
UB(1).right = 4; UB(1).matrix = y0'; % initial states
LB(1).right = 4; LB(1).matrix = y0';
UB(2).right = 1; UB(2).matrix = umax; % controls
LB(2).right = 1; LB(2).matrix = 0;
UB(3).right = 5; UB(3).matrix = [inf,inf,A0]'; % final states
LB(3).right = 2; LB(3).matrix = ymin'; % states

% combine structures
setup.symb = symb; setup.M = M; setup.UB = UB; setup.LB = LB;
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
function opts = Tumor_opts
% test number
num = 1;

switch num
case 1
    % default parameters
    opts.general.displevel = 1;
    opts.general.plotflag = 1;
    opts.dt.defects = 'HS';
    opts.dt.quadrature = 'CQHS';
    opts.dt.mesh = 'ED';
    opts.dt.nt = 100; % number of nodes
    opts.qlin.sqpflag = false;
    opts.qlin.trustregionflag = true;
    opts.qlin.improveX0flag = false;
    opts.qlin.delta = 3000;
end

end