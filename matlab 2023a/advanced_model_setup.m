b = 3.9351*10^(-6);
d = 1.1925*10^(-7);

J_inertia = 6*10^(-5);
J_xx = 0.0552;
J_yy = 0.0552;
J_zz = 0.1104;

K_v = 54.945;
L = 0.1969;

g_r = 5.2;
g_p = 10.5;

f_y = 0.175;
f_r = 0.4;
f_p = 1.3;

Y = d*(K_v)^2 /J_zz;
B = b*L*(K_v)^2 /J_xx;

J = (J_yy - J_zz)/J_xx;
J_r = J_inertia/J_xx;

VMAX_AMP = 24;
V_bias = 12;

a = 0;
tempSat = 100000;

%%% Van-der-pol oscillator parameter (is technically supposed to be 'mu'
%%% but meh)
u = 1;
%%% Decides the size (and thus voltage requirements) of the van der pol limit cycle
cycleGain = 0.1;
%%%
c3 = 1;
r = 0.2;
%r = 4;
kd = 0.5;
skew = 1;

%%%
beta3d = 0.9;
epsilon3d = 1;
k3d = 1.65;

K_AMP = 3;
VMAX_AMP = 24;
VMAX_DAC = 10;
wcf = 2 * pi * 20; % filter cutting frequency
zetaf = 0.6;        % filter damping ratio
CMD_RATE_LIMIT = 60 * pi/180; % 60 deg/s converted to rad/s

a = 0;
velMax = 1000;

DG = 1;

% Nonlinear model
I_yy = 0.0522;
I_xx = 0.0522;
I_zz = 0.1104;
l_a = 0.1968;
k_T = 0.1188;
kQ = 0.0036;

B1  =[-kQ, -kQ, kQ, kQ;
    l_a*k_T, -l_a*k_T, 0, 0;
    0, 0, l_a*k_T, -l_a*k_T];

B2 = [0, 0, 0;
    0, 0, 0;
    0, 0, 0;
    1/I_zz, 0, 0;
    0, 1/I_yy, 0;
    0, 0, 1/I_xx];

x4line = pi/4;
x5line = pi/4;
x6line = pi/4;


u1line = l_a*k_T*VMAX_AMP;
u2line = l_a*k_T*VMAX_AMP;
u3line = 2*kQ*VMAX_AMP;

kfr_r = 0.4*u1line/x4line;
kfr_p = 0.4*u2line/x5line;
kfr_y = 0.4*u3line/x6line;

%%
%Astate = [0, 1; -skew, r^2];
Astate = [0, 1; -1, u];
Bstate = [1, 0; 0, 1];
Cstate = [1, 0; 0, 1];
Dstate = [0, 0; 0, 0];

Q = eye(2);
R = 0.01*eye(2);

sys = ss(Astate, Bstate, Cstate, Dstate);

[K1, S, P] = lqr(sys, Q, R);

[X, K2, L_other] = icare(Astate, Bstate, Q, R);

disp("K with 'lqr' and 'icare' (in order)")
disp(K1)
disp(K2)

K = K1;