function [u1_num, u2_num] = solveSyms2(x_5, x_6, u_10, u_20)  % add necessary inputs and outputs
  syms x5 x6 u10 u20 u1
  %tic
  sol1 = evalin('base', 'sol1');
  sol2 = evalin('base', 'sol2');
  sol1 = evalin('base', 'solNew1');
  sol2 = evalin('base', 'solNew2');
  % u_2 = evalin('base', 'solx11');
  % u_1 = evalin('base', 'solx21');
  % sol1 = evalin('base', 'solx1');
  % sol2 = evalin('base', 'solx2');
  % u_1 = evalin('base', 'solx11');
  % u_2 = evalin('base', 'solx21');
  % u_1 = evalin('base', 'sol11');
  % u_2 = evalin('base', 'sol21');
  % disp(x_5)
  % disp(x_6)
  % disp(u_10)
  % disp(u_20)
  %toc
  %tic
  % for n = 1:length(sol1)
  %     u1_num = double(subs(sol1(n), {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20}));
  %     u2_num = double(subs(sol2(n), {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20}));
  %     % u1_num = real(double(subs(sol1(n), {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20})));
  %     % u2_num = real(double(subs(sol2(n), {x6, u1, u10}, {x_6, u1_num, u_10})));
  %     disp(u1_num)
  %     disp(u2_num)
  %     if isreal(u1_num) & isreal(u2_num)
  %         break
  %     elseif n == 4
  %         u1_num = real(u1_num);
  %         u2_num = real(u2_num);
  %     end
  % end
  u1_num = real(double(subs(sol1, {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20})));
  u2_num = real(double(subs(sol2, {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20})));
  % 
  % u1_num = real(double(subs(sol1(4), {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20})));
  % u2_num = real(double(subs(sol2, {x6, u1, u10}, {x_6, u1_num, u_10})));
  % u1_num = real(double(subs(u_1, {x5, x6, u10, u20}, {x_5, x_6, u_10, u_20})));
  % u2_num = real(double(subs(u_2, {x6, u1, u10}, {x_6, u1_num, u_10})));
  % 
  % disp(u1_num)
  % disp(u2_num)
  % disp("")
end