function y=myfun3d_2(unknowns, u00, u10, u20, kQ, k_T, l_a, I_zz, I_yy, I_xx)
    u1=unknowns(1);
    u2=unknowns(2);
    u3=unknowns(3);
    u4=unknowns(4);
    eq0 = kQ*(u4 + u3 - u2 - u1)/I_zz;
    eq1 = k_T*l_a*(u1 - u2)/I_yy;
    eq2 = k_T*l_a*(u3 - u4)/I_xx;
    %y = (eq1 - u10)^2 + (eq2 - u20)^2;
    y = (eq0 - u00)^2 + (eq1 - u10)^2;
    %y = (eq0 - u00)^2 + (eq1 - u10)^2 + (eq2 - u20)^2;
end