function y=myfun3d_3(unknowns, u00, u10, u20, L, Kf, Kt, Jp, Jy, Jr)
    u1=unknowns(1);
    u2=unknowns(2);
    u3=unknowns(3);
    u4=unknowns(4);
    eq0 = Kt*(u4 + u3 - u2 - u1)/Jy;
    eq1 = L*Kf*(u1 - u2)/Jp;
    eq2 = L*Kf*(u3 - u4)/Jr;
    %y = (eq1 - u10)^2 + (eq2 - u20)^2;
    y = (eq0 - u00)^2 + (eq1 - u10)^2 + (eq2 - u20)^2;
end