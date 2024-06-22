load yawvalues.mat
yawvalues = transpose(ans(2:3, :));
load pitchvalues.mat;
pitchvalues = transpose(ans(2:3, :));
load rollvalues.mat;
rollvalues = transpose(ans(2:3, :));
load voltages.mat;
voltages = transpose(ans(2:5, :));

%xYaw = yawvalues(2, :);
%xPitch = pitchvalues(2, :);
%xRoll = rollvalues(2, :);