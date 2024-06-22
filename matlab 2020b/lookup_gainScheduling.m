

x1_range = -60:1:60;
x2_range = -50:1:90;

x1_range = x1_range*pi/180;
x2_range = x2_range*pi/180;

x1L = length(x1_range);
x2L = length(x2_range);

K1M = zeros(x1L, x2L);
K2M = zeros(x1L, x2L);
K3M = zeros(x1L, x2L);
K4M = zeros(x1L, x2L);
K5M = zeros(x1L, x2L);
K6M = zeros(x1L, x2L);
K7M = zeros(x1L, x2L);
K8M = zeros(x1L, x2L);
% 
tic
for n = 1:x1L
    for nn = 1:x2L
        K_g = gainScheduling([x1_range(n); x2_range(nn)]);
        
        K1M(n, nn) = K_g(1, 1);
        K2M(n, nn) = K_g(1, 2);
        K3M(n, nn) = K_g(1, 3);
        K4M(n, nn) = K_g(1, 4);
        K5M(n, nn) = K_g(2, 1);
        K6M(n, nn) = K_g(2, 2);
        K7M(n, nn) = K_g(2, 3);
        K8M(n, nn) = K_g(2, 4);
    end
end
toc