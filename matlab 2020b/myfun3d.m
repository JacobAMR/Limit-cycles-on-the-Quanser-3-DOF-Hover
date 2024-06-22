function y=myfun3d(unknowns, x6, x5, u00, u10, u20, B, Y, V_bias, K_v, J_r)
    disp(u00)
    disp(u10)
    disp(u20)
    disp("")
    u1=unknowns(1);
    u2=unknowns(2);
    u3=unknowns(3);
    u4=unknowns(4);
    eq0 = Y*((u4 + V_bias)^2 - (u2 + V_bias)^2 + (u3 + V_bias)^2 - (u1 + V_bias)^2);
    eq1 = B*((u1 + V_bias)^2 - (u2 + V_bias)^2) - J_r*x6*K_v*(u4 - u2 + u3 - u1);
    eq2 = B*((u3 + V_bias)^2 - (u4 + V_bias)^2) + J_r*x5*K_v*(u4 - u2 + u3 - u1);
    disp(eq0)
    disp(eq1)
    disp(eq2)
    disp("")
    disp("")

    %y = (eq1 - u10)^2 + (eq2 - u20)^2;
    y = (eq0 - u00)^2 + (eq1 - u10)^2;
    %y = (eq0 - u00)^2 + (eq1 - u10)^2 + (eq2 - u20)^2;
end