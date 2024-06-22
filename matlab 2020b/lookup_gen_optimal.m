x0 = [0, 0, 0, 0];
lb = -12*[1, 1, 1, 1];
ub = 12*[1, 1, 1, 1];

options = optimoptions('fmincon','Display','off');
const = [B, Y, V_bias, K_v, J_r];

x5_range = -15:2.5:15;
x6_range = -15:2.5:15;
u10_range = -3:0.2:3;
u20_range = -3:0.2:3;
% u10_range = 1:2;
% u20_range = 1;
%tic

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