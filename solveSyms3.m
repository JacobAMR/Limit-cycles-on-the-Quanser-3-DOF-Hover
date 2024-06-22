function [u1_num, u2_num] = solveSyms3(u_10, u_20)  % add necessary inputs and outputs
  syms u10 u20 u1 u2

  bias = evalin('base', 'V_bias');
  B = evalin('base', 'B');
  eq1 = sqrt(u_10/B + bias^2) - bias;
  eq2 = sqrt(u_20/B + bias^2) - bias;

  u1_num = real(double(subs(eq1, {u10}, {u_10})));
  u2_num = real(double(subs(eq2, {u20}, {u_20})));
  % 
  % disp(u1_num)
  % disp(u2_num)
  % disp("")
end