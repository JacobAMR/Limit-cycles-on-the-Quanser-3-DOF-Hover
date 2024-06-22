function [u1_num, u2_num] = solveSyms(v1, v2, v3, v4, v5, v6, v7)  % add necessary inputs and outputs
  syms x1 x2 x3 x4 x5 x6 u1 u2 statey_der;
  %tic
  u_1 = evalin('base', 'u_1');
  %toc
  %tic
  num1 = double(subs(u_1, {x1, x2, x3, x4, x5, x6, statey_der}, {v1, v2, v3, v4, v5, v6, v7}));
  %toc
  %tic
  if real(num1) > 0
      u1_num = abs(num1)
  else
      u1_num = -abs(num1)
  end
  %toc
  u_2 = evalin('base', 'u_2');
  num2 = double(subs(u_2, {x1, x2, x3, x4, x5, x6, u1}, {v1, v2, v3, v4, v5, v6, u1_num}));
  if real(num2) > 0
      u2_num = abs(num2)
  else
      u2_num = -abs(num2)
  end
end