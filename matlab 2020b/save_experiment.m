%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BE VERY CAREFUL TO USE RIGHT NAME BEFORE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUNNING THIS

%filename = "linear_flexible_trajectory_R10";
filename = "modelTestGood";

%Linear, nonlinear, advanced
%Flexible, 3d, vander
%Normal, trajectory
%medium = 0.01, strong = 0.001, Rx

Uinput = input(append("Are you sure you want the name to be ", filename, "? Press 1 if yes.\n"));


if Uinput == 1
    load yawvalues.mat
    yawvalues = transpose(ans(2:3, :));
    load pitchvalues.mat;
    pitchvalues = transpose(ans(2:3, :));
    load rollvalues.mat;
    rollvalues = transpose(ans(2:3, :));
    load voltages.mat;
    voltages = transpose(ans(2:5, :));


    save(append("arrays/", filename), 'Q', 'R', 'K', 'yawvalues', 'pitchvalues', 'rollvalues', 'voltages', 'u', 'cycleGain', 'r', 'skew')
end