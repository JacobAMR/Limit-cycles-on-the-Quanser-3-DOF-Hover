function [u1_num, u2_num, u3_num, u4_num] = solveSyms5(x_5, x_6, u_10, u_20, x0, lb, ub, options, const)
% function [u1_num, u2_num, u3_num, u4_num] = solveSyms5(x_5, x_6, u_10, u_20)
    % x0 = [0, 0, 0, 0];
    % %lb = -12*[1, 1, 1, 1];
    % %ub = 12*[1, 1, 1, 1];
    % lb = -24*[1, 1, 1, 1];
    % ub = 24*[1, 1, 1, 1];   
    % 
    % options = optimoptions('fmincon','Display','off', 'Algorithm', 'interior-point');
    % B = evalin('base', 'B');
    % Y = evalin('base', 'Y');
    % V_bias = evalin('base', 'V_bias');
    % K_v = evalin('base', 'K_v');
    % J_r = evalin('base', 'J_r');
    % 
    % u_num = fmincon(@(x) myfun(x, x_5, x_6, u_10, u_20, B, Y, V_bias, K_v, J_r), x0, [], [], [], [], lb, ub, [], options);
    u_num = fmincon(@(x) myfun(x, x_5, x_6, u_10, u_20, const(1), const(2), const(3), const(4), const(5)), x0, [], [], [], [], lb, ub, [], options);
    u1_num = u_num(1);
    u2_num = u_num(2);
    u3_num = u_num(3);
    u4_num = u_num(4);
    % disp(u2_num)
    % disp(u3_num)
    % disp(u4_num)
end