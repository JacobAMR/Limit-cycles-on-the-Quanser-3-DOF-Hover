close all

plotpp(@(t,x)[0.4*x(1) - x(2) - x(1)*(x(1)^2 + x(2)^2);x(1) + 0.4*x(2) - x(2)*(x(1)^2 + x(2)^2)], 'xlim', [-1, 1], 'ylim', [-1, 1])

%annotation('arrow', [.3 .5], [.6 .5], "DisplayName", "Arrow thingy");

annotation('textarrow',[.325 .52], [.8 .518],'String','x_0 = [-0.8, 0.7]^T','Color','red')

xlabel("x_1")
ylabel("x_2")
title("Reyleight system with \mu = 0.4")


legend("State space trajectories", "Direction of feedback control")