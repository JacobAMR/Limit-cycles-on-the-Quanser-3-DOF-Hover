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

%%%%%%%%%%
%%%%%%%%%%
%%%%%%%%%%

sampleTime = 0.001;
stopTime = 200;
sigma = 0;

modelTypes = ["Improved nonlinear", "Nonlinear", "Linear"];

%simout = sim("modelsCompare", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));

load("arrays/part 2/modelTestGood")

fig1 = figure(1);
tiledlayout(4, 3, 'Padding', 'none', 'TileSpacing', 'loose');

type = 1;

yaw = [yawvalues(:, 1), simout.yawAdvanced(:, 1), simout.yawLinear(:, 1), simout.yawNonlinear(:, 1)];
pitch = [pitchvalues(:, 1), simout.pitchAdvanced(:, 1), simout.pitchLinear(:, 1), simout.pitchNonlinear(:, 1)];
roll = [rollvalues(:, 1), simout.rollAdvanced(:, 1), simout.rollLinear(:, 1), simout.rollNonlinear(:, 1)];

timeRange = 0:sampleTime:stopTime;

voltScaleFactor = 40;

for n = 1:4
    voltScaledYaw = voltages*(max(yaw(:, n))-min(yaw(:, n)))/voltScaleFactor;
    voltScaledPitch = voltages*(max(pitch(:, n))-min(pitch(:, n)))/voltScaleFactor;
    voltScaledRoll = voltages*(max(roll(:, n))-min(roll(:, n)))/voltScaleFactor;

    voltScaledYaw = voltScaledYaw + 0.9*(min(yaw(:, n)) - min(voltScaledYaw));
    voltScaledPitch = voltScaledPitch + 0.9*(min(pitch(:, n)) - min(voltScaledPitch));
    voltScaledRoll = voltScaledRoll + 0.9*(min(roll(:, n)) - min(voltScaledRoll));

    nexttile
    pl1 = plot(timeRange, yaw(:, n), 'r', "DisplayName", "yaw");
    hold on
    pl4 = plot(timeRange, voltScaledYaw(:, 1), ":c", "DisplayName", "front voltage");
    pl5 = plot(timeRange, voltScaledYaw(:, 2), ":m", "DisplayName", "back voltage");
    pl6 = plot(timeRange, voltScaledYaw(:, 3), ":", "color", [0.9290 0.6940 0.1250], "DisplayName", "right voltage");
    pl7 = plot(timeRange, voltScaledYaw(:, 4), ":k", "DisplayName", "left voltage");
    % hL = legend("Yaw velocity", "Front voltage", "Back voltage", "Right voltage", "Left voltage");
    % set(hL.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.7]));
    if n == 3
        temp = voltScaledYaw;
    end
    if n == 4
        xlabel("Time (s)")
    end
    ylabel("Velocity (degrees/s)")
    axis padded

    nexttile
    pl2 = plot(timeRange, pitch(:, n), 'b', "DisplayName", "pitch");
    hold on
    plot(timeRange, voltScaledPitch(:, 1), ":c", timeRange, voltScaledPitch(:, 2), ":m", timeRange, voltScaledPitch(:, 4), ":k");
    plot(timeRange, voltScaledPitch(:, 3), ":", "color", [0.9290 0.6940 0.1250])
    % hL = legend("Pitch velocity", "Front voltage", "Back voltage", "Right voltage", "Left voltage");
    % set(hL.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.7]));
    if n == 4
        xlabel("Time (s)")
    end
    if n == 1
        title("Physical Hover")
    else
        title(append(modelTypes(n-1), " model"))
    end
    axis padded

    nexttile
    pl3 = plot(timeRange, roll(:, n), 'g', "DisplayName", "roll");
    hold on
    plot(timeRange, voltScaledRoll(:, 1), ":c", timeRange, voltScaledRoll(:, 2), ":m", timeRange, voltScaledRoll(:, 4), ":k");
    plot(timeRange, voltScaledRoll(:, 3), ":", "color", [0.9290 0.6940 0.1250])
    % hL = legend("Roll velocity", "Front voltage", "Back voltage", "Right voltage", "Left voltage");
    % set(hL.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.7]));
    if n == 4
        xlabel("Time (s)")
    end
    axis padded
end
hL = legend([pl1, pl2, pl3, pl4, pl5, pl6, pl7],'Position',[0.19 0.65 0.2 0.2]);
set(hL.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.7]));

%hL.Position = [10, 10];

AddLetters2Plots(fig1, 'HShift', 0, 'VShift', 0.02, 'Direction', 'LeftRight')

fig1.Position = [100 100 550 650];

saveas(fig1, append('images/modelComp.png'))

fig2 = figure(2);

plot(timeRange, voltages)
xlabel("Time (s)")
ylabel("Voltage (V)")

axis padded

hL = legend("Front voltage", "Back voltage", "Right voltage", "Left voltage");
set(hL.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.7]));

fig2.Position = [100 100 440 250];

saveas(fig2, append('images/modelCompVoltages.png'))

fig3 = figure(3);

