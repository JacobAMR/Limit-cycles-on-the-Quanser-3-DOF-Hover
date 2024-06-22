syms u2 u1 u20 u10 u00 x6 x5 bias1 Vf Vb Vr Vl
%u20 = [];
%x3 = [];
%u10 = [];

% eq1 = B*((u1 + V_bias)^2 - V_bias^2) - J_r*x6*K_v*(sqrt(u2^2) - sqrt(u1^2)) == u10;
% eq2 = B*((u2 + V_bias)^2 - V_bias^2) + J_r*x5*K_v*(sqrt(u2^2) - sqrt(u1^2)) == u20;  
% eq1 = B*(u1^2 - V_bias^2) - J_r*x6*K_v*(u2 - u1) == u10;
% eq2 = B*(u2^2 - V_bias^2) + J_r*x5*K_v*(u2 - u1) == u20;  
eq1 = B*((u1 + V_bias)^2 - V_bias^2) - J_r*x6*K_v*(u2 - u1) == u10;
eq2 = B*((u2 + V_bias)^2 - V_bias^2) + J_r*x5*K_v*(u2 - u1) == u20;  
% eq1 = B*((u1 + V_bias)^2 - V_bias^2) - J_r*x6*K_v*(sqrt(u2^2) - sqrt(u1^2)) == u10;
% eq2 = B*((u2 + V_bias)^2 - V_bias^2) + J_r*x5*K_v*(sqrt(u2^2) - sqrt(u1^2)) == u20;  
tic
[sol1, sol2] = solve([eq1, eq2], [u1, u2]);
toc
sol11 = sol1(1);
sol21 = sol2(1);

%symvar(sol11)
%symvar(sol21)

%%

%x_5 = -10;
%x_6 = 2;
%u_10 = 100;
%u_20 = 150;

%num1 = double(subs(sol11, {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20}))

%num2 = double(subs(sol21, {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20}))

%%%

%solx1 = solve(eq1, u2);

solx2 = (B*((u1 + V_bias)^2 - V_bias^2) + J_r*x6*K_v*u1 - u10)/(J_r*x6*K_v);
%%% IT doesn't make any sense to add bias to the gyroscopic
%%% Is the bias really supposed to be in the way I put it? Think about that
%%% more.
%%% I think I should be adding it to the solution instead?

eq3 = B*((solx2 + V_bias)^2 - V_bias^2) + J_r*x5*K_v*(solx2 - u1) == u20;

solx1 = solve(eq3, u1);

% tempSol = (B*(u1)^2 - J_r*x6*K_v*12 - (u10 + bias1))/(J_r*x6*K_v);
% biasSol = solve(B*(tempSol)^2 + J_r*x5*K_v*(tempSol - u1) == u20, u1);
% 
% bias = solve(biasSol(1) == solx2(1) + 12, bias1);
% biasSol = bias(1);
% symvar(biasSol)

solx11 = solx1(1);
solx21 = solx2(1);

%symvar(solx11);
%symvar(solx21);

%num1 = double(subs(solx21, {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20}))
%num2 = double(subs(solx11, {u1, u20, x6}, {num1, u_20, x_6}))

%%
x5_range = -(29.5):10:(30.5);
x6_range = -(29.5):10:(30.5);

u10_range = -199:100:401;
u20_range = -199:100:401;
u1_range = -15:1:15;

% x5_range = -(29.5):5:(30.5);
% x6_range = -(29.5):5:(30.5);
% 
% u10_range = -199:10:201;
% u20_range = -199:10:201;

% x5_range = -14.5:2:15.5;
% x6_range = -14.5:2:15.5;
% 
% u10_range = 80:2:200;
% u20_range = 80:2:200;
% u1_range = 9:0.1:15;

%%% Function ranges:
% u10_range = 0:20:200;
% u20_range = 0:20:200;
% u1_range = 0:10:80;


% [X1, X2, X3, X4] = ndgrid(x5_range, x6_range, u10_range, u20_range);
% tic
% num1_ds_imag = double(subs(sol11, {x5, x6, u10, u20}, {X1, X2, X3, X4}));
% num1_ds = real(num1_ds_imag);
% num2_ds_imag = double(subs(sol21, {x5, x6, u10, u20}, {X1, X2, X3, X4}));
% num2_ds = real(num2_ds_imag);
% 
% num1_imag = double(subs(solx11, {x5, x6, u10, u20}, {X1, X2, X3, X4}));
% num1 = real(num1_imag);
% toc
% % tic
% % numBias = real(double(subs(biasSol, {x5, x6, u10, u20}, {X1, X2, X3, X4})));
% % toc
% [X12, X22, X32] = ndgrid(x6_range, u1_range, u10_range);
% tic
% num2_imag = double(subs(solx21, {x6, u1, u10}, {X12, X22, X32}));
% num2 = real(num2_imag);
toc

%%

eq0 = Y*((Vl + V_bias)^2 - (Vb + V_bias)^2 + (Vr + V_bias)^2 - (Vf + V_bias)^2) == u00;
eq1 = B*((Vf + V_bias)^2 - (Vb + V_bias)^2) - J_r*x6*K_v*(Vl - Vb + Vr - Vf) == u10;
eq2 = B*((Vr + V_bias)^2 - (Vl + V_bias)^2) + J_r*x5*K_v*(Vl - Vb + Vr - Vf) == u20;


%[solNew1, solNew2, solNew3, solNew4] = solve([eq0, eq1, eq2], [Vf, Vb, Vr, Vl]);
%solNew = solve([eq0, eq1, eq2], [Vf, Vb, Vr, Vl], 'ReturnConditions', true);
%solNewNC = solve([eq0, eq1, eq2], [Vf, Vb, Vr, Vl])
%solSimp = simplify(solve([eq0, eq1, eq2], [Vf, Vb, Vr, Vl]));


% solS1 = simplify(solNew1);
% solS2 = simplify(solNew2);
% solS3 = simplify(solNew3);
% solS4 = simplify(solNew4);

%%

% eq0 = Y*((V_bias)^2 - (Vb + V_bias)^2 + (Vr + V_bias)^2 - (Vf + V_bias)^2) == u00;
% eq1 = B*((Vf + V_bias)^2 - (Vb + V_bias)^2) - J_r*x6*K_v*(-Vb + Vr - Vf) == u10;
% eq2 = B*((Vr + V_bias)^2 - (V_bias)^2) + J_r*x5*K_v*(-Vb + Vr - Vf) == u20;
% 
% 
[solNew1x, solNew2x, solNew3x] = vpasolve([eq0, eq1, eq2], [Vf, Vb, Vr]);
% solNew = vpasolve([eq0, eq1, eq2], [Vf, Vb, Vr, Vl], 'ReturnConditions', true);
%solNewNC = solve([eq0, eq1, eq2], [Vf, Vb, Vr, Vl])
%solSimp = simplify(solve([eq0, eq1, eq2], [Vf, Vb, Vr, Vl]));


% solS1 = simplify(solNew1);
% solS2 = simplify(solNew2);
% solS3 = simplify(solNew3);
% solS4 = simplify(solNew4);
