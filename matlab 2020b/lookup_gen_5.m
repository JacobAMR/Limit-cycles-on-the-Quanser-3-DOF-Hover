syms u10 u20

eq1 = sqrt(u10/B + V_bias^2) - V_bias;
eq2 = sqrt(u20/B + V_bias^2) - V_bias;

u10_range = -40:0.00001:40;
u20_range = -40:0.00001:40;

%u10_range = -10:0.005:10;
%u20_range = -10:0.005:10;

%[X1, X2] = ndgrid(u10_range, u20_range);

tic
u1_num = real(double(subs(eq1, {u10}, {u10_range})));
toc
tic
u2_num = real(double(subs(eq2, {u20}, {u20_range})));
toc