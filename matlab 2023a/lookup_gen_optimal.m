x0 = [0, 0, 0, 0];
%lb = -12*[1, 1, 1, 1];
%ub = 12*[1, 1, 1, 1];
lb = -24*[1, 1, 1, 1];
ub = 24*[1, 1, 1, 1];

options = optimoptions('fmincon','Display','off');
const = [B, Y, V_bias, K_v, J_r];
%const = [kQ, k_T, l_a, I_zz, I_yy, I_xx];
%const = [L, Kf, Kt, Jp, Jy, Jr];

x5_range = -45:5:45;
x6_range = -45:5:45;
u10_range = -19:0.5:15;
u20_range = -19:0.5:15;
% u10_range = 1:2;
% u20_range = 1;
%tic
% x5_range = -45:10:45;
% x6_range = -45:10:45;
% u00_range = -11:2:11;
% u10_range = -11:2:11;
% u20_range = -11:2:11;
% Was 2361 seconds.

x5L = length(x6_range);
x6L = length(x5_range);
u10L = length(u10_range);
u20L = length(u20_range);

u1_T = zeros(x5L, x6L, u10L, u20L);
u2_T = zeros(x5L, x6L, u10L, u20L);
u3_T = zeros(x5L, x6L, u10L, u20L);
u4_T = zeros(x5L, x6L, u10L, u20L);

tic
for n = 1:x5L
    for nn = 1:x6L
        for nnn = 1:u10L
            for nnnn = 1:u20L
                [u1, u2, u3, u4] = solveSyms5(x5_range(n), x6_range(nn), u10_range(nnn), u20_range(nnnn), x0, lb, ub, options, const);
                u1_T(n, nn, nnn, nnnn) = u1;
                u2_T(n, nn, nnn, nnnn) = u2;
                u3_T(n, nn, nnn, nnnn) = u3;
                u4_T(n, nn, nnn, nnnn) = u4;
            end
        end
    end
end
toc

%%% advanced 3d:

% u1_T = zeros(x5L, x6L, u00L, u10L, u20L);
% u2_T = zeros(x5L, x6L, u00L, u10L, u20L);
% u3_T = zeros(x5L, x6L, u00L, u10L, u20L);
% u4_T = zeros(x5L, x6L, u00L, u10L, u20L);
% 
% 
% tic
% for n = 1:x5L
%     for nn = 1:x6L
%         for nnn = 1:u00L
%             for nnnn = 1:u10L
%                 for nnnnn = 1:u20L
%                     [u1, u2, u3, u4] = solveSyms3d(x5_range(n), x6_range(nn), u00_range(nnn), u10_range(nnnn), u20_range(nnnnn), x0, lb, ub, options, const);
%                     u1_T(n, nn, nnn, nnnn, nnnnn) = u1;
%                     u2_T(n, nn, nnn, nnnn, nnnnn) = u2;
%                     u3_T(n, nn, nnn, nnnn, nnnnn) = u3;
%                     u4_T(n, nn, nnn, nnnn, nnnnn) = u4;
%                 end
%             end
%         end
%     end
% end
% toc

%%%% nonlinear 3d:

% u1_T = zeros(u00L, u10L, u20L);
% u2_T = zeros(u00L, u10L, u20L);
% u3_T = zeros(u00L, u10L, u20L);
% u4_T = zeros(u00L, u10L, u20L);
% 
% 
% tic
% for n = 1:u00L
%     for nn = 1:u10L
%         for nnn = 1:u20L
%             %[u1, u2, u3, u4] = solveSyms3d_2(u00_range(n), u10_range(nn), u20_range(nnn), x0, lb, ub, options, const);
%             [u1, u2, u3, u4] = solveSyms3d_3(u00_range(n), u10_range(nn), u20_range(nnn), x0, lb, ub, options, const);
%             u1_T(n, nn, nnn) = u1;
%             u2_T(n, nn, nnn) = u2;
%             u3_T(n, nn, nnn) = u3;
%             u4_T(n, nn, nnn) = u4;
%         end
%     end
% end
% toc

%%% Pitch yaw, lin or nonlin

% u1_T = zeros(u00L, u10L);
% u2_T = zeros(u00L, u10L);
% u3_T = zeros(u00L, u10L);
% u4_T = zeros(u00L, u10L);
% 
% tic
% for n = 1:u00L
%     for nn = 1:u10L
%         [u1, u2, u3, u4] = solveSyms3d_2(u00_range(n), u10_range(nn), 0, x0, lb, ub, options, const);
%         %[u1, u2, u3, u4] = solveSyms3d_3(u00_range(n), u10_range(nn), u20_range(nnn), x0, lb, ub, options, const);
%         u1_T(n, nn) = u1;
%         u2_T(n, nn) = u2;
%         u3_T(n, nn) = u3;
%         u4_T(n, nn) = u4;
%     end
% end
% toc

