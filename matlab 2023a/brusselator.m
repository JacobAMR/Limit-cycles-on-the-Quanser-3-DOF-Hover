stopTime = 100;
sampleTime = 0.005;

A = 1;
o = 0.05;
%o = 0;
B = 2.15;

a = 0.1;
o_glycosis = 0.01;
%o = 0;
b = 0.4;

syms delta
d = double(solve(B == 2*delta + 1 + A^2, delta));

% out = sim("brusselator_sim", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));
% brusselx = out.brusselx;
% brussely = out.brussely;
% out = sim("glycosis_sim", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));
% glycosisx = out.glycosisx;
% glycosisy = out.glycosisy;

space = 1;