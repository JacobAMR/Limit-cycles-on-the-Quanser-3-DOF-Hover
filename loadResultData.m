%filename = "arrays/advanced_feedback2_1";
%load("arrays/nonlin_feedback_trajectory_1")

if exist('modelTypes','var') ~= 1
    cycle = "vander";
    loadString = "nonlin_feedback_trajectory_1";
end

load(append("arrays/part 2/", loadString))

yPitch = pitchvalues(:, 1);
xPitch = pitchvalues(:, 2);

yRoll = rollvalues(:, 1);
xRoll = rollvalues(:, 2);

yYaw = yawvalues(:, 1);
xYaw = yawvalues(:, 2);

if strcmp(cycle, 'vander') == 1
    simout = sim("vanderpol.slx", 'StartTime', '0', 'StopTime', '500', 'FixedStep', '0.005');
    cycleTrajectory = simout.cycleValues((100001-2000):100001, :);
elseif strcmp(cycle, 'flexible') == 1
    simout = sim("paperCycle.slx", 'StartTime', '0', 'StopTime', '500', 'FixedStep', '0.005');
    cycleTrajectory = simout.cycleValues((100001-2000):100001, :);
elseif strcmp(cycle, '3d') == 1
    beta3d = 0.9;
    epsilon3d = 1;
    k3d = 1.65;
    simout = sim("vander3d.slx", 'StartTime', '0', 'StopTime', '500', 'FixedStep', '0.002');
    cycleTrajectory = simout.cycleValues((250001-4000):250001, :);
end