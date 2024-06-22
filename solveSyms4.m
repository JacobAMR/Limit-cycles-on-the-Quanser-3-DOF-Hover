function [u1_num, u2_num, u3_num, u4_num] = solveSyms4(x_5, x_6, u_00, u_10, u_20)  % add necessary inputs and outputs
  syms x5 x6 u00 u10 u20 u1 Vl
  %tic
  % sol1 = evalin('base', 'solNew1');
  % sol2 = evalin('base', 'solNew2');
  % sol3 = evalin('base', 'solNew3');
  % sol4 = evalin('base', 'solNew4');
  sol1 = evalin('base', 'solNew1x');
  sol2 = evalin('base', 'solNew2x');
  sol3 = evalin('base', 'solNew3x');
  % disp(x_5)
  % disp(x_6)
  % disp(u_10)
  % disp(u_20)


  u1_num = real(double(subs(sol1(1), {u00, u10, u20, x5, x6, Vl}, {u_00, u_10, u_20, x_5, x_6, 0})));
  u2_num = real(double(subs(sol2(1), {u00, u10, u20, x5, x6, Vl}, {u_00, u_10, u_20, x_5, x_6, 0})));
  u3_num = real(double(subs(sol3(1), {u00, u10, u20, x5, x6, Vl}, {u_00, u_10, u_20, x_5, x_6, 0})));
  %u4_num = real(double(subs(sol4(1), {u00, u10, u20, x5, x6}, {u_00, u_10, u_20, x_5, x_6})));
  u4_num = 0;
  
  % disp("")
  % disp(u1_num)
  % disp(u2_num)
  % disp(u3_num)
  % disp(u4_num)
  % disp("")
end