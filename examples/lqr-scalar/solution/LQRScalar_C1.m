function C1 = LQRScalar_C1(a,b,q,r)
%LQRSCALAR_C1
%    C1 = LQRSCALAR_C1(A,B,Q,R)

%    This function was generated by the Symbolic Math Toolbox version 8.0.
%    16-Jan-2018 13:03:12

C1 = sqrt(a.^2.*r+b.^2.*q);
