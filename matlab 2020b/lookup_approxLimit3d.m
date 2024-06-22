x1_traj = -60:1:90;
x2_traj = -60:1:90;
x3_traj = -60:1:90;

x1_traj = x1_traj*pi/180;
x2_traj = x2_traj*pi/180;
x3_traj = x3_traj*pi/180;

x1TL = length(x1_traj);
x2TL = length(x2_traj);
x3TL = length(x3_traj);

x1_trajectory = zeros(x1TL, x2TL, x3TL);
x2_trajectory = zeros(x1TL, x2TL, x3TL);
x3_trajectory = zeros(x1TL, x2TL, x3TL);
% 
tic
for n = 1:x1TL
    for nn = 1:x2TL
        for nnn = 1:x3TL
            xTemp = approxLimit([x1_traj(n); x2_traj(nn); x3_traj(nnn)]);

            x1_trajectory(n, nn, nnn) = xTemp(1);
            x2_trajectory(n, nn, nnn) = xTemp(2);
            x3_trajectory(n, nn, nnn) = xTemp(3);
        end
    end
end
toc