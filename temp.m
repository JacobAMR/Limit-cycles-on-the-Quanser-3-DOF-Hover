beta3d = 0.9;
epsilon3d = 1;
k3d = 1.65;
cycleGain = 1;

Alin = [0, 1, 0; -1, epsilon3d, -k3d; 1, 0, -1];
Blin = eye(3)/cycleGain;
Clin = eye(3);
Dlin = zeros(3);

Q = eye(3);
R = 0.01*eye(3);

sys = ss(Alin, Blin, Clin, Dlin);

[K, etc1, etc2] = lqr(sys, Q, R);
