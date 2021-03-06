%--------------------------------------------------------------------------
% BrysonHo248.m
% pp. 248-250 of A. E. Bryson Jr. and Y.-C. Ho, Applied Optimal Control.
% Taylor & Francis, 1975, isbn: 9780891162285
%--------------------------------------------------------------------------
% This is a singular optimal control problem
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function varargout = BrysonHo248(varargin)
% input arguments can be provided in the format 'BrysonHo248(p,opts)'

% set local functions
ex_opts = @BrysonHo248_opts; % options function
ex_output = @BrysonHo248_output; % output function
ex_plot = @BrysonHo248_plot; % plot function

% set p and opts (see local_opts)
[p,opts] = DTQP_standardizedinputs(ex_opts,varargin);

%% tunable parameters
tf = 1;
p.alpha = 1;
p.beta = 1;
p.gamma = 20;

%% setup
% system dynamics
A = [0 1; 0 0]; 
B = [1;-1]; 

% Lagrange term
L(1).left = 2; % state variables
L(1).right = 2; % state variables
L(1).matrix = [1/2,0;0,0];

% L(2).left = 1; % control variables
% L(2).right = 1; % control variables
% L(2).matrix = 1e-8;

% initial conditions
LB(1).right = 4; % initial states
LB(1).matrix = [p.alpha;p.beta];
UB(1).right = 4; % initial states
UB(1).matrix = [p.alpha;p.beta];

% final conditions
LB(2).right = 5; % final states
LB(2).matrix = [0;0];
UB(2).right = 5; % final states
UB(2).matrix = [0;0];

% absolute value control bounds
LB(3).right = 1; % control
LB(3).matrix = -p.gamma;
UB(3).right = 1; % control
UB(3).matrix = p.gamma;

% combine
setup.A = A; setup.B = B; setup.L = L;
setup.UB = UB; setup.LB = LB; setup.tf = tf; setup.p = p;

%% solve
[T,U,Y,P,F,in,opts] = DTQP_solve(setup,opts);

%% output
[O,sol] = ex_output(T,U,Y,P,F,in,opts);
if nargout == 1
	varargout{1} = O;
end

%% plot
ex_plot(T,U,Y,P,F,in,opts,sol)

end
% User options function for this example
function opts = BrysonHo248_opts
% test number
num = 1;

switch num
case 1
    opts.dt.quadrature = 'CEF';
    opts.dt.defects = 'ZO';
    opts.dt.mesh = 'ED';
    opts.dt.nt = 100;
case 2
    opts.dt.quadrature = 'G';
    opts.dt.defects = 'PS';
    opts.dt.mesh = 'LGL';
    opts.dt.nt = 100;
case 3      
    opts.dt.quadrature = 'CQHS';
    opts.dt.defects = 'HS';
    opts.dt.mesh = 'ED';
    opts.dt.nt = 100;
end

end