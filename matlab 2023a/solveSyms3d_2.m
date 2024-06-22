%function [u1_num, u2_num, u3_num, u4_num] = solveSyms3d_2(u_00, u_10, u_20, x0, lb, ub, options, const)
function [u1_num, u2_num, u3_num, u4_num] = solveSyms3d_2(u_00, u_10, u_20)
    x0 = [0, 0, 0, 0];
    lb = -12*[1, 1, 1, 1];
    ub = 12*[1, 1, 1, 1];
    options = optimoptions('fmincon','Display','off', 'Algorithm', 'interior-point');

    kQ = evalin('base', 'kQ');
    k_T = evalin('base', 'k_T');
    l_a = evalin('base', 'l_a');
    I_zz = evalin('base', 'I_zz');
    I_yy = evalin('base', 'I_yy');
    I_xx = evalin('base', 'I_xx');

    u_num = fmincon(@(x) myfun3d_2(x, u_00, u_10, u_20, kQ, k_T, l_a, I_zz, I_yy, I_xx), x0, [], [], [], [], lb, ub, [], options);
    
    %u_num = fmincon(@(x) myfun3d_2(x, u_00, u_10, u_20, const(1), const(2), const(3), const(4), const(5), const(6)), x0, [], [], [], [], lb, ub, [], options);
    u1_num = u_num(1);
    u2_num = u_num(2);
    u3_num = u_num(3);
    u4_num = u_num(4);
    % disp(u2_num)
    % disp(u3_num)
    % disp(u4_num)
end