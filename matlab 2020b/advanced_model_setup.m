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
u = 0.2;
%%% Decides the size (and thus voltage requirements) of the van der pol limit cycle
cycleGain = 0.5;
%%%
c3 = 1;
r = 0.2;
%r = 4;
kd = 0.5;
skew = 1;

K_AMP = 3;
VMAX_AMP = 24;
V_max = VMAX_AMP;
VMAX_DAC = 10;
wcf = 2 * pi * 20; % filter cutting frequency
zetaf = 0.6;        % filter damping ratio
CMD_RATE_LIMIT = 60 * pi/180; % 60 deg/s converted to rad/s

velMax = 1000000;

g = 9.81;
% Motor Armature Resistance (Ohm)
Rm = 0.83;
% Motor Current-Torque Constant (N.m/A)
Kt_m = 0.0182;
% Motor Rotor Moment of Inertia (kg.m^2)
Jm = 1.91e-6;
% Moving Mass of the Hover system (kg)
m_hover = 2.85;
% Mass of each Propeller Section = motor + shield + propeller + body (kg)
m_prop = m_hover / 4;
% Distance between Pivot to each Motor (m)
L = 7.75*0.0254;
% Propeller Force-Thrust Constant found Experimentally (N/V)
Kf = 0.1188;
% Propeller Torque-Thrust Constant found Experimentally (N-m/V)
Kt = 0.0036;
Jeq_prop = Jm + m_prop*L^2;
% Equivalent Moment of Inertia about each Axis (kg.m^2)
Jp = 2*Jeq_prop;
Jy = 4*Jeq_prop;
Jr = 2*Jeq_prop;

K_EC_Y = -2 * pi / ( 8 * 1024 );
K_EC_P = 2 * pi / ( 8 * 1024 );
K_EC_R = 2 * pi / ( 8 * 1024 );
% Bias voltage applied to motors (V)
V_bias = 12;
%
K_JOYSTICK_X = -25;
% Joystick input Y sensitivity used for pitch (deg/s/V)
K_JOYSTICK_Y = 25;
% Pitch integrator saturation of joystick (deg)
INT_JOYSTICK_SAT_LOWER = -10;
INT_JOYSTICK_SAT_UPPER = 10;
% Deadzone of joystick: set input ranging from -DZ to +DZ to 0 (V)
JOYSTICK_X_DZ = 0.25;
JOYSTICK_Y_DZ = 0.25;

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


u1line = l_a*k_T*V_max;
u2line = l_a*k_T*V_max;
u3line = 2*kQ*V_max;

kfr_r = 0.4*u1line/x4line;
kfr_p = 0.4*u2line/x5line;
kfr_y = 0.4*u3line/x6line;