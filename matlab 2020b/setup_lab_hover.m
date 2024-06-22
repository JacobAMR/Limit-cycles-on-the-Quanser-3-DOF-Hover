%clear, clc, close all

x0 = transpose(0.5*[pi/2, pi/6, pi/6, 0, 0, 0]);
u = 1;

% 3 DOF HOVER Control Lab: 
% 
% SETUP_LAB_HOVER sets the model parameters.
%
% Copyright (C) 2010 Quanser Consulting Inc.
% Quanser Consulting Inc.
%
%% Amplifier Configuration
% Amplifier gain used for yaw and pitch axes.
K_AMP = 3;
% Amplifier Maximum Output Voltage (V)
VMAX_AMP = 24;
% Digital-to-Analog Maximum Voltage (V): set to 10 for Q4/Q8 cards
VMAX_DAC = 10;
%
%% Filter and Rate Limiter Settings
% Specifications of a second-order low-pass filter
wcf = 2 * pi * 20; % filter cutting frequency
zetaf = 0.6;        % filter damping ratio
%
% Maximum Rate of Desired Position (rad/s)
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
%% 1 - State-space compact representation:

%A = [0, 1, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0; 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 0, 0];
%B = [0, 0, 0, 0; -Kt/Jy, -Kt/Jy, Kt/Jy, Kt/Jy; 0, 0, 0, 0; L*Kf/Jp, -L*Kf/Jp, 0, 0; 0, 0, 0, 0; 0, 0, L*Kf/Jr, -L*Kf/Jr];
%C = [1, 0, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0; 0, 0, 0, 0, 1, 0];
%D = [0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0];

A = [0, 0, 0, 1, 0, 0; 0, 0, 0, 0, 1, 0; 0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0];
B = [0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; -Kt/Jy, -Kt/Jy, Kt/Jy, Kt/Jy; L*Kf/Jp, -L*Kf/Jp, 0, 0; 0, 0, L*Kf/Jr, -L*Kf/Jr];
C = [1, 0, 0, 0, 0, 0; 0, 1, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0];
D = [0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0];

Ct = ctrb(A, B);
Ctr = rank(Ct);
disp("The rank is: " + string(Ctr))

%% 2 - Pole placement:

%p = -2*[0.5, 0.4, 0.5, 0.4, 0.5, 0.4] 

%K = place(A,B,p)

%% 3 - Design LQR Controller

%Q = 1000*eye(6);
Q = [500, 0, 0, 0, 0, 0; 0, 350, 0, 0, 0, 0; 0, 0, 350, 0, 0, 0; 0, 0, 0,  20, 0, 0; 0, 0, 0, 0,  20, 0; 0, 0, 0, 0, 0,  20];
R = 0.01*eye(4);

sys = ss(A, B, C, D);

[K1, S, P] = lqr(sys, Q, R);

[X, K2, L_other] = icare(A, B, Q, R);

disp("K with 'lqr' and 'icare' (in order)")
disp(K1)
disp(K2)

K = K1

%% Plotting:
%Comment out these lines when connecting to the physical model.
%sim('sim_hover_state_feedback')
%plotting;