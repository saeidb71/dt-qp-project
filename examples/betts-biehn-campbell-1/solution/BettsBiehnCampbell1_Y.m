function out1 = BettsBiehnCampbell1_Y(t)
%BETTSBIEHNCAMPBELL1_Y
%    OUT1 = BETTSBIEHNCAMPBELL1_Y(T)

%    This function was generated by the Symbolic Math Toolbox version 8.0.
%    17-Dec-2017 22:39:24

t2 = t-4.0;
t3 = t2.^2;
out1 = [-t3.^2+1.5e1,t2.*t3.*-4.0];