cycle = 'vander';

x1_range = -45:0.5:45;
x2_range = -45:0.5:45;

x1L = length(x1_range);
x2L = length(x2_range);

K1_T = zeros(x1L, x2L);
K2_T = zeros(x1L, x2L);

tic
for n = 1:x1L
    for nn = 1:x2L
        K = gainScheduling([x1_range(n), x2_range(nn)]);
        K1_T(n, nn) = K1(1);
        K2_T(n, nn) = K2(2);
    end
end
toc