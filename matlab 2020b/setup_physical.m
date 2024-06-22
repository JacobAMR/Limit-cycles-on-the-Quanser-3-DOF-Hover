%clear, clc
%%% md = 0 and comment out the above part => use data in workspace
%%% md = 1 => runs a new simulation
%%% md = 2 => loads a saved simulation
md = 1;

%%% Selecting the desired file
%simuName = 'cycletest6';
%simuName = 'vandertest2';
simuName = 'advanced_cycletest1_physical';
%simuName = 'linear_papertest_physical';

%%% Set whether the system you're using is linear or not (maybe make this
%%% automatic later)
linear = 1;

%%% Lets you adjust the names of the plots you make
%plotName = '3dRVPVRA';
plotName = 'realA-Vsmaller';

%%% Van-der-pol oscillator parameter (is technically supposed to be 'mu'
%%% but meh)
u = 1;
%%% Decides the size (and thus voltage requirements) of the van der pol limit cycle
cycleGain = 1;
%%% Other method parameters
c3 = 1;
r = 2;
%r = 4;
kd = 0.5;
skew = 1;
%%% Start time of the plotting and stop time of the simulation
long = 0;
%%% Saturation on (1) or off (0), method selection (bias, func, double)
sat = 1;
method = 'bias';
%%% Whether you use the velocity states directly (0), or the derivative of the
%%% angle (1)
der = 1;
%%% Number of initial conditions to simulate and plot (can only use as many
%%% as are added below)
initials = 1;
%%% Initial condition set selection (they can be found in set_sim_params)
sets = 3;
%%%
sampleTime = 0.001;
%%% To prevent lag, this will forcefully limit the plot length to a set
%%% amount. Cannot
plotMax = 50000;

velMax = 100*60*pi/180;
sigma = 0;

%%% Whether you want to save the plots as images (1 for yes)
savePlot = 1;

%%% For loading saved arrays
loadName = 'vandertest2';

%%% Style options
fontSize = 14;
set(0, 'DefaultLineLineWidth', 2)
%set(0,'DefaultFigureWindowStyle','docked')

[plotName, startTime, stopTime, space, x0M] = set_sim_params(long, sampleTime, plotName, plotMax, simuName, sat, method, der, sets, initials);

plotName = append(plotName, '_', strrep(num2str(u),'.','-'));

% Translating start time to start index
tStart = round(startTime/(space*sampleTime)) + 1;

V_max = 24;
V_bias = 12;

K_AMP = 3;
VMAX_AMP = 24;
VMAX_DAC = 10;
wcf = 2 * pi * 20; % filter cutting frequency
zetaf = 0.6;        % filter damping ratio
CMD_RATE_LIMIT = 60 * pi/180; % 60 deg/s converted to rad/s

%% Set the model parameters of the 3DOF HOVER.
% These parameters are used for model representation and controller design.
% Gravitational Constant (m/s^2)
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
% note: front/back motor are counter-clockwise (negative torque) and 
% left/right motor are clockwise (positive torque).
% 
% Equivalent Moment of Inertia of each Propeller Section (kg.m^2)
Jeq_prop = Jm + m_prop*L^2;
% Equivalent Moment of Inertia about each Axis (kg.m^2)
Jp = 2*Jeq_prop;
Jy = 4*Jeq_prop;
Jr = 2*Jeq_prop;
%
% Pitch and Yaw Axis Encoder Resolution (rad/count)
K_EC_Y = -2 * pi / ( 8 * 1024 );
K_EC_P = 2 * pi / ( 8 * 1024 );
K_EC_R = 2 * pi / ( 8 * 1024 );
% Bias voltage applied to motors (V)
V_bias = 12;
%
%% Joystick Settings
% Joystick input X sensitivity used for roll (deg/s/V)
K_JOYSTICK_X = -25;
% Joystick input Y sensitivity used for pitch (deg/s/V)
K_JOYSTICK_Y = 25;
% Pitch integrator saturation of joystick (deg)
INT_JOYSTICK_SAT_LOWER = -10;
INT_JOYSTICK_SAT_UPPER = 10;
% Deadzone of joystick: set input ranging from -DZ to +DZ to 0 (V)
JOYSTICK_X_DZ = 0.25;
JOYSTICK_Y_DZ = 0.25;
%

A = [0, 0, 0, 1, 0, 0; 0, 0, 0, 0, 1, 0; 0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0];
B = [0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; -Kt/Jy, -Kt/Jy, Kt/Jy, Kt/Jy; L*Kf/Jp, -L*Kf/Jp, 0, 0; 0, 0, L*Kf/Jr, -L*Kf/Jr];
%B = [0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; L*Kf/Jp, -L*Kf/Jp, 0, 0; 0, 0, L*Kf/Jr, -L*Kf/Jr];
%C = [1, 0, 0, 0, 0, 0; 0, 1, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0];
%D = zeros(3, 4);
C = eye(6);
D = zeros(6, 4);


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


u1line = l_a*k_T*V_max;
u2line = l_a*k_T*V_max;
u3line = 2*kQ*V_max;

kfr_r = 0.4*u1line/x4line;
kfr_p = 0.4*u2line/x5line;
kfr_y = 0.4*u3line/x6line;

x0 = x0M(:, 1);
%[xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL] = run_simulations(md, initials, stopTime, sampleTime, loadName, x0M, simuName, space, linear);

%%% Decides when plot limits for velocities should start being found (to
%%% prevent spikes at the start from ruining the plot)
lStart = 5000/space;
%vStart = 1;

% plot_simulations(xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL, lStart, initials, tStart, (stopTime - startTime), fontSize, savePlot);
% 
% %if 1 == 0
% for n = 1:initials
% disp(append("Initial condition ",num2str(n), " (in degrees):"))
%     disp(append(num2str(xRoll(1, n)), ", ", num2str(xPitch(1, n)), ", ",  num2str(xYaw(1, n)), ...
%         ", ",  num2str(yRoll(1, n)), ", ",  num2str(yPitch(1, n)), ", ",  num2str(yYaw(1, n))))
% end
% %end

space = 1;