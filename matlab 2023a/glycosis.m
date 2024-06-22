a = 0.1;
o_glycosis = 0.01;
o = o_glycosis;
%o = 0;
b = 0.4;

syms delta
double(solve(b == sqrt(0.5*(1 - 2*a - 2*delta - sqrt(4*delta^2 + 1 - 8*a - 4*delta))), delta))
%double(solve(b == sqrt(0.5*(1 - 2*a - 2*delta + sqrt(4*delta^2 + 1 - 8*a - 4*delta))), delta))

%delta = 0.022;
%b = sqrt(0.5*(1 - 2*a - 2*delta - sqrt(4*delta^2 + 1 - 8*a - 4*delta)));

%sim("glycosis_sim")