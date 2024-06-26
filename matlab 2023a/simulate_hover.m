%clear, clc
%%% md = 0 and comment out the above part => use data in workspace
%%% md = 1 => runs a new simulation
%%% md = 2 => loads a saved simulation
md = 1;

%load lookup_nopos_physical2.mat;

%%% Selecting the desired file
if exist('simuNames','var') ~= 1

    %load lookup.mat
    %load lookup_nopos_physical2.mat
    load lookup_advancedPGain.mat
    %load lookup_nonlin3d.mat
    %load lookup_3d.mat

    %simuName = 'cycletest6';
    %simuName = 'nonlinCycletest1';
    %simuName = 'advanced_cycletest9';
    %simuName = 'nonlin_feedback';
    %simuArray = [''];
    simuName = "advanced_feedback";
    simuName = 'nonlin_feedback';
    %simuName = 'cycletest_feedback';
    %simuName = 'nonlin_timefeedback';
    %simuName = 'cycletest_timefeedback';
    %simuName = 'advanced_timefeedback';
    %simuName = 'nonlin_3d';
    %simuName = 'cycletest_3d';
    %simuName = 'nonlin_pitchyaw_lookup';
    %simuName = 'advanced_3d_lookup';
    simuName = 'advanced_modelError';
    %simuName = "vanderpol";
    simuName = "paperCycle";
    %simuName = "vander3d";
end

%R = 1 works perfectly for all?

%disp(simuName)


%%% Lets you adjust the names of the plots you make
%plotName = '3dRVPVRA';
plotName = 'PARA';

%plotting = 1;


%%% Van-der-pol oscillator parameter (is technically supposed to be 'mu'
%%% but meh)
u = 0.5;
%%% Decides the size (and thus voltage requirements) of the van der pol limit cycle
cycleGain = 0.2;
%%% Other method parameters
c3 = 1;
if exist('flexSize','var') ~= 1
    r = 0.5;
end
%r = 4;
kd = 0.5;
skew = 2;
%%% 3d vander
beta3d = 0.9;
epsilon3d = 1;
k3d = 1.65;


%sjekk plagiatkontroll bare i tilfelle
%%% Whether feedback is on (1) or not (0)
%feedback = 0;
%%% What type of feedback is being used, "trajectory" or "time" or "none"
if exist('simuNames','var') ~= 1
    feedbackType = "none";
end
%%% Noise parameter
%sigma = 0.1;
sigma = 0;

%%%
%3d = 1;

%%% vander, flexible, or 3d
cycle = 'flexible';
%%% angle and velocity
cycleType = 'angle';
%%% Start time of the plotting and stop time of the simulation
long = 1;
%%% Saturation on (1) or off (0), method selection (bias, func, double)
if exist('saturation','var') ~= 1
    sat = 1;
end
method = 'bias';
%%% Whether you use the velocity states directly (0), or the derivative of the
%%% angle (1)
if exist('derivative','var') ~= 1
    %disp("hello")
    der = 1;
end
%%% Number of initial conditions to simulate and plot (can only use as many
%%% as are added below)
initials = 1;
%%% Initial condition set selection (they can be found in set_sim_params)
if exist('sets_external','var') ~= 1
    sets = 6;
end
%%%
sampleTime = 0.002;
%%% To prevent lag, this will forcefully limit the plot length to a set
%%% amount. Cannot
%plotMax = 50000;
plotMax = 3000/sampleTime;

%%%
paramTest = 1;
%vM = [0.1, 0.3, 0.5, 0.8, 1, 1.2, 1.5, 2; ones(3, 8)]; %% u?
%vM = [ones(1, 5); 0.1, 0.3, 0.5, 1, 1.5; ones(2, 5)]; %% cycleGain?
%vM = [ones(2, 6); 0.1, 0.2, 0.5, 1, 1.5, 2; ones(1, 6)]; %% r
vM = [ones(3, 6); 0.2, 0.3, 0.5, 1, 2, 5]; %% w

%%% Whether you want to save the plots as images (1 for yes)
savePlot = 0;

%%% For loading saved arrays
loadName = 'vandertest2';

%%% Style options
fontSize = 11;
set(0, 'DefaultLineLineWidth', 2)
%set(0,'DefaultFigureWindowStyle','docked')

if paramTest == 1
    initials = length(vM);
end
velMax = 100*60*pi/180;

V_max = 24;
V_bias = 12;

K_AMP = 3;
VMAX_AMP = 24;
VMAX_DAC = 10;
wcf = 2 * pi * 20; % filter cutting frequency
zetaf = 0.6;        % filter damping ratio
CMD_RATE_LIMIT = 60 * pi/180; % 60 deg/s converted to rad/s

g = 9.81;
Rm = 0.83;
Kt_m = 0.0182;
Jm = 1.91e-6;
m_hover = 2.85;
m_prop = m_hover / 4;
L = 7.75*0.0254;
Kf = 0.1188;
Kt = 0.0036;

angleLim = pi/3;

Jeq_prop = Jm + m_prop*L^2;
Jp = 2*Jeq_prop;
Jy = 4*Jeq_prop;
Jr = 2*Jeq_prop;

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

a = 0;
tempSat = 100000;


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


if strcmp(cycle, 'vander') == 1
    Alin = [0, 1; -1, u];
    %Alin = [0, 1; 0.5*u/(cycleGain^2) - 1, u - 0.5*u/(cycleGain^2)];
    Blin = eye(2);
    % temp = load("vanderCycle.mat");
    % cycleTrajectory = temp.vanderCycle;
    simout = sim("vanderpol.slx", 'StartTime', '0', 'StopTime', '500', 'FixedStep', '0.005');
    cycleTrajectory = simout.cycleValues((100001-2000):100001, :);
    %cycleTrajectory2 = cycleValues;
elseif strcmp(cycle, 'flexible') == 1
    Alin = [0, 1; -skew, r^2];
    Blin = eye(2);
    % temp = load("paperCycle.mat");
    % cycleTrajectory = temp.paperCycle;
    simout = sim("paperCycle.slx", 'StartTime', '0', 'StopTime', '500', 'FixedStep', '0.005');
    cycleTrajectory = simout.cycleValues((100001-2000):100001, :);
end

if strcmp(cycle, '3d') == 1
    simout = sim("vander3d.slx", 'StartTime', '0', 'StopTime', '500', 'FixedStep', '0.002');
    cycleTrajectory = simout.cycleValues((250001-4000):250001, :);
    Alin = [0, 1, 0; -1, epsilon3d, -k3d; 1, 0, -1];
    Blin = eye(3);
    Clin = eye(3);
    Dlin = zeros(3);
    Q = eye(3);
    R = 0.1*eye(3);
else
    Clin = [1, 0; 0, 1];
    Dlin = [0, 0; 0, 0];
    
    Q = eye(2);
    Q = [eye(2), zeros(2); zeros(2), 0.01*eye(2)];
    if exist('inputWeights','var') ~= 1
        R = 1000*eye(2);
        %R = 0.001*eye(2);
    end
end

sys = ss(Alin, Blin, Clin, Dlin);
%TFs = tf(sys);d

%K = lqr(sys, Q, R);
K = lqi(sys, Q, R);

disp("K: ")
disp(K)

%K = place(Alin, Blin, [-2, -1]);

%K_temp = 1./dcgain(ss((Alin - Blin*K), Blin, Clin, Dlin));
Kr = 1;

%K = eye(2);
%K = [K(2, 2), 0; 0, K(2, 2)];

[plotName, startTime, stopTime, space, x0M] = set_sim_params(long, sampleTime, plotName, plotMax, simuName, sat, method, der, sets, initials, cycle, feedbackType, cycleType, paramTest);

plotName = append(plotName, '_', strrep(num2str(u),'.','-'));

% Translating start time to start index
tStart = round(startTime/(space*sampleTime)) + 1;

[xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL] = run_simulations(md, initials, stopTime, sampleTime, loadName, x0M, simuName, space, vM, paramTest);
%[xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL] = run_simulations(md, initials, stopTime, sampleTime, loadName, x0M, simuName, space);

%%% Decides when plot limits for velocities should start being found (to
%%% prevent spikes at the start from ruining the plot)
lStart = 5000/space;
%vStart = 1;

if exist('plotNo','var') ~= 1
    if paramTest == 1
        plot_cycle(xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, initials, tStart, fontSize, savePlot, plotName, simuName, cycleType, vM)
    else
        plot_simulations(xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL, lStart, initials, tStart, (stopTime - startTime), fontSize, savePlot, plotName, simuName, cycleType, vM);
    end
    for n = 1:initials
        disp(append("Initial condition ",num2str(n), " (in degrees):"))
        disp(append(num2str(xYaw(1, n)), ", ", num2str(xPitch(1, n)), ", ",  num2str(xRoll(1, n)), ...
            ", ",  num2str(yYaw(1, n)), ", ",  num2str(yPitch(1, n)), ", ",  num2str(yRoll(1, n))))
    end
% else
%     disp("plotting has been skipped")
end