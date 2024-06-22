function [K] = gainScheduling(x)
    x1 = x(1);
    x2 = x(2);
    cycle = evalin('base', 'cycle');
    
    if strcmp(cycle, 'vander') == 1
        u = evalin('base', 'u');
        a = evalin('base', 'cycleGain');
        A = [0, 1; 2*u*x2*x1/(a^2) - 1, u - u*x1^2/(a^2)];
    elseif strcmp(cycle, 'flexible') == 1
        w0 = evalin('base', 'skew');
        r = evalin('base', 'r');
        A = [0, 1; -2*w0*x2*x1 - w0, -w0*x1^2 - 3*x2^2 + r^2];
    end
    
    if strcmp(cycle, '3d') == 1
        epsilon3d = evalin('base', 'epsilon3d');
        k3d = evalin('base', 'k3d');
        A = [0, 1, 0; -1, epsilon3d, -k3d; 1, 0, -1];
        B = eye(3);
        C = eye(3);
        D = zeros(3);

        Q = eye(3);
        Q = [eye(3), zeros(3); zeros(3), 0.1*eye(3)];
        R = 0.001*eye(3);
    else
        C = eye(2);
        D = zeros(2);
        B = eye(2);

        Q = eye(2);
        Q = [eye(2), zeros(2); zeros(2), 0.1*eye(2)];
        R = 0.001*eye(2);
    end
    
    sys = ss(A, B, C, D);
    %TFs = tf(sys);d
    
    %K = lqr(sys, Q, R);
    K = lqi(sys, Q, R);

    disp(K)

    %TFs = tf(sys);
    %K = [pidtune(TFs(1, 1), 'P').Kp, pidtune(TFs(1, 2), 'P').Kp; pidtune(TFs(2, 1), 'P').Kp, pidtune(TFs(2, 2), 'P').Kp];
    %K = [pidtune(TFs(1, 1), 'P').Kp, 0; 0, pidtune(TFs(2, 2), 'P').Kp];
    %K = [pidtune(TFs(1, 1), 'P').Kp, pidtune(TFs(2, 2), 'P').Kp];
    % Kr = 0;    %disp(K)

    %K = place(A, B, [-20, -40]);
    %Kr = 1./dcgain(ss((A - B*K), B, C, D));
    %disp(Kr)
    %Kr = zeros(2);
end