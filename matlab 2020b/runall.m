filename = "linear_flexible_normal_weak";
filename = "linear_vander_normal_normal";

%Linear, nonlinear, advanced
%Flexible, 3d, vander
%Normal, trajectory
%weak = 0.1, medium = 0.01, strong = 0.001, Rx for trajectory
%Actually I think medium was = 0.001...

sampleTime = 0.001;

loadvalues
save_experiment
physical_plotting
cycle_detection