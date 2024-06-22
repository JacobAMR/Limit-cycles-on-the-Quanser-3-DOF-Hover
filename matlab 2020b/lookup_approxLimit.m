x1_traj = -60:0.1:60;
x2_traj = -50:0.1:90;

x1_traj = x1_traj*pi/180;
x2_traj = x2_traj*pi/180;

x1TL = length(x1_traj);
x2TL = length(x2_traj);

x1_trajectory = zeros(x1TL, x2TL);
x2_trajectory = zeros(x1TL, x2TL);
% 
tic
for n = 1:x1TL
    for nn = 1:x2TL
        xTemp = approxLimit([x1_traj(n); x2_traj(nn)]);
        
        x1_trajectory(n, nn) = xTemp(1);
        x2_trajectory(n, nn) = xTemp(2);
    end
end
toc