function [] = set_model_params(long, sampleTime, plotName, simuName, sat, method, der, sets, initials)
    
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
    
    Jeq_prop = Jm + m_prop*L^2;
    Jp = 2*Jeq_prop;
    Jy = 4*Jeq_prop;
    Jr = 2*Jeq_prop;
    
    A = [0, 0, 0, 1, 0, 0; 0, 0, 0, 0, 1, 0; 0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0];
    B = [0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; -Kt/Jy, -Kt/Jy, Kt/Jy, Kt/Jy; L*Kf/Jp, -L*Kf/Jp, 0, 0; 0, 0, L*Kf/Jr, -L*Kf/Jr];
    %B = [0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; L*Kf/Jp, -L*Kf/Jp, 0, 0; 0, 0, L*Kf/Jr, -L*Kf/Jr];
    %C = [1, 0, 0, 0, 0, 0; 0, 1, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0];
    %D = zeros(3, 4);
    C = eye(6);
    D = zeros(6, 4);
    
    
    % Nonlinear model
    I_yy = 0.0522;
    I_xx = 0.0522;
    I_zz = 0.1104;
    l_a = 0.1968;
    k_T = 0.1188;
    kQ = 0.0036;
    
    %B1 = [-kQ, kQ, -kQ, kQ; 
    %    l_a*k_T, 0, -l_a*k_T, 0;
    %    0, -l_a*k_T, 0, l_a*k_T];
    
    %1 -> 1, 3 -> 2, 4 -> 3, 2 -> 4 
    
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
end