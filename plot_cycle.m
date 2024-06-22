function [] = plot_cycle(xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, initials, tStart, fontSize, savePlot, plotName, simuName, cycleType, vM)
    close all
    uM = vM(1, :);
    aM = vM(2, :);
    rM = vM(3, :);
    w0M = vM(4, :);

    fig1 = figure(1);
    hold on
    for n = 1:initials
        plot(xPitch(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', ':')
    end
    title('Phase plot of Van der Pol oscillator with varying \mu')
    xlabel('x1')
    ylabel('x2')
    xlim([-4.1, 4.1])
    ylim([-4.1, 4.1])
    legend(arrayfun(@(mode) sprintf('u=%.01f', uM(mode)), 1:size(yYaw, 2), 'UniformOutput', false))
    %legend(arrayfun(@(mode) sprintf('test %d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    %fontsize(fig1, fontSize, "points")

    fig2 = figure(2);
    hold on
    for n = 1:initials
        plot(xPitch(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', ':')
    end
    title('Phase plot of scaled Van der Pol oscillator with varying a')
    xlabel('x1')
    ylabel('x2')
    xlim([-5.5, 5.5])
    ylim([-5.5, 5.5])
    legend(arrayfun(@(mode) sprintf('a=%.01f', aM(mode)), 1:size(yYaw, 2), 'UniformOutput', false))
    %legend(arrayfun(@(mode) sprintf('test %d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    fontsize(fig2, fontSize, "points")

    fig3 = figure(3);
    hold on
    for n = 1:initials
        plot(xPitch(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', '-')
    end
    %title('Phase plot of elliptical limit cycle with varying r')
    title('Phase plot of elliptical limit cycle with varying r', 'Position', [-0.07, 2.64, 0])
    xlabel('x1')
    ylabel('x2')
    xlim([-2.51, 2.51])
    ylim([-2.51, 2.51])
    legend(arrayfun(@(mode) sprintf('r=%.01f', rM(mode)), 1:size(yYaw, 2), 'UniformOutput', false))
    %legend(arrayfun(@(mode) sprintf('test %d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    fontsize(fig3, fontSize, "points")

    AddLetters2Plots(fig3, {'A'}, 'HShift', 0, 'VShift', 0, 'Direction', 'TopDown')

    fig4 = figure(4);
    hold on
    for n = 1:initials
        plot(xPitch(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', '-')
    end
    %title('Phase plot of elliptical limit cycle with varying \omega_0', 'Position', [0.5, -0.1, 0])
    title('Phase plot of elliptical limit cycle with varying \omega_0')
    xlabel('x1')
    ylabel('x2')
    xlim([-2.51, 2.51])
    ylim([-2.51, 2.51])
    legend(arrayfun(@(mode) sprintf('%s_0=%.01f', "\omega", w0M(mode)), 1:size(yYaw, 2), 'UniformOutput', false))
    %legend(arrayfun(@(mode) sprintf('test %d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    fontsize(fig4, fontSize, "points")

    AddLetters2Plots(fig4, {'B'}, 'HShift', 0, 'VShift', 0, 'Direction', 'TopDown')

    fig5 = figure(5);
    for n = 1:initials
        plot3(xYaw(tStart:end, n), xPitch(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', '-')
        hold on
    end
    title('Phase plot of flexible limit cycle with varying \omega_0')
    xlabel('x1')
    ylabel('x2')
    zlabel('x3')
    %xlim([-2.51, 2.51])
    %ylim([-2.51, 2.51])
    legend(arrayfun(@(mode) sprintf('a=%.01f', aM(mode)), 1:size(yYaw, 2), 'UniformOutput', false))
    %legend(arrayfun(@(mode) sprintf('test %d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    fontsize(fig5, fontSize, "points")
    
    fig6 = figure(6);
    img1 = imread(append('images/keep/elliptical_r.png'));
    img2 = imread(append('images/keep/elliptical_w.png'));

    imshow([img1, img2])

    saveas(fig6, "images/keep/elliptical_showcase.png")

