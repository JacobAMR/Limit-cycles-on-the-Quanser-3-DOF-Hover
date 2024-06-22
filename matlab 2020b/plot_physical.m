function [] = plot_physical(xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL, lStart, initials, tStart, tTime, fontsize, savePlot, plotName, simuName)
    close all
    vLength = length(xYaw);
    
    minYaw = 100000;
    maxYaw = -100000;
    minPitch = 100000;
    maxPitch = -100000;
    minRoll = 100000;
    maxRoll = -100000;
    
    fig1 = figure(1);
    tiledlayout(2, 2, 'Padding', 'none', 'TileSpacing', 'compact');
    
    nexttile
    hold on
    for n = 1:initials
        %disp("hello")
        plot(xYaw(tStart:end, n), yYaw(tStart:end, n), 'LineStyle', ':')
        minTemp = min(yYaw(lStart:end, n));
        if minTemp < minYaw
            minYaw = minTemp;
        end
        maxTemp = max(yYaw(lStart:end, n));
        if maxTemp > maxYaw
            maxYaw = maxTemp;
        end
    end
    title('Yaw')
    xlabel('Angle')
    ylabel('Velocity')
    Lgnd = legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(yYaw, 2), 'UniformOutput', false));
    %Lgnd = legend(legendText)
    Lgnd.Position(1) = 0.85;
    Lgnd.Position(2) = 0.05;
    yRange = maxYaw - minYaw;
    %disp(maxYaw)
    %disp(minYaw)
    ylim([minYaw - yRange*0.1, maxYaw + yRange*0.1])
    
    nexttile
    hold on
    for n = 1:initials
        plot(xPitch(tStart:end, n), yPitch(tStart:end, n), 'LineStyle', ':')
        minTemp = min(yPitch(lStart:end, n));
        if minTemp < minPitch
            minPitch = minTemp;
        end
        maxTemp = max(yPitch(lStart:end, n));
        if maxTemp > maxPitch
            maxPitch = maxTemp;
        end
    end
    title('Pitch')
    xlabel('Angle')
    ylabel('Velocity')
    pRange = maxPitch - minPitch;
    ylim([minPitch - pRange*0.1, maxPitch + pRange*0.1])
    
    %subplot(1, 3, 3)
    nexttile
    hold on
    for n = 1:initials
        plot(xRoll(tStart:end, n), yRoll(tStart:end, n), 'LineStyle', ':')
        minTemp = min(yRoll(lStart:end, n));
        if minTemp < minRoll
            minRoll = minTemp;
        end
        maxTemp = max(yRoll(lStart:end, n));
        if maxTemp > maxRoll
            maxRoll = maxTemp;
        end
    end
    title('Roll')
    xlabel('Angle')
    ylabel('Velocity')
    
    rRange = maxRoll - minRoll;
    ylim([minRoll - rRange*0.1, maxRoll + rRange*0.1])
    
    %fontsize(fig1, %fontsize, "points")
    if savePlot == 1
        saveas(fig1, append('images/', plotName, '_angle-speed_', simuName, '.png'))
    end
    
    fig2 = figure(2);
    for n = 1:initials
        plot3(xYaw(tStart:end, n), xPitch(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', ':')
        hold on
    end
    title('Angles 3D')
    xlabel('Yaw')
    ylabel('Pitch')
    zlabel('Roll')
    legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    %fontsize(fig2, %fontsize, "points")
    if savePlot == 1
        saveas(fig2, append('images/', plotName, '_3d_angles_', simuName, '.png'))
    end
        
    fig3 = figure(3);
    hold on
    for n = 1:initials
        plot(xPitch(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', ':')
    end
    title('Angles')
    xlabel('Pitch')
    ylabel('Roll')
    %xlim([-100, 100])
    %ylim([-100, 100])
    legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    %fontsize(fig3, %fontsize, "points")
    if savePlot == 1
        saveas(fig3, append('images/', plotName, '_pitch-roll_', simuName, '.png'))
    end
    
    fig4 = figure(4);
    hold on
    for n = 1:initials
        plot(xYaw(tStart:end, n), xPitch(tStart:end, n), 'LineStyle', ':')
    end
    xlabel('Yaw')
    ylabel('Pitch')
    legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    %fontsize(fig4, %fontsize, "points")
    if savePlot == 1
        saveas(fig4, append('images/', plotName, '_yaw-pitch_', simuName, '.png'))
    end
    
    fig5 = figure(5);
    hold on
    for n = 1:initials
        plot(xYaw(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', ':')
    end
    title('Angles')
    xlabel('Yaw')
    ylabel('Roll')
    legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    %fontsize(fig5, %fontsize, "points")
    if savePlot == 1
        saveas(fig5, append('images/', plotName, '_yaw-roll_', simuName, '.png'))
    end
    
    fig6 = figure(6);
    hold on
    for n = 1:initials
        plot(yPitch(tStart:end, n), yRoll(tStart:end, n), 'LineStyle', ':')
    end
    title('Velocities')
    xlabel('Pitch')
    ylabel('Roll')
    legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    
    xlim([minPitch - pRange*0.1, maxPitch + pRange*0.1])
    ylim([minRoll - rRange*0.1, maxRoll + rRange*0.1])
    
    %fontsize(fig6, %fontsize, "points")
    if savePlot == 1
        saveas(fig6, append('images/', plotName, '_velocity_pitch-roll_', simuName, '.png'))
    end
    
    fig7 = figure(7);

    timeVector = (tStart*(tTime/vLength)):(tTime/vLength):tTime;

    %assignin('base','time_vector', timeVector);
    %assignin('base','v_length', vLength);
    tiledlayout(2, 2, 'Padding', 'none', 'TileSpacing', 'loose');
    
    disp("Front voltages:")
    nexttile
    hold on
    for n = 1:initials
        plot(timeVector, voltF(tStart:end, n), 'LineStyle', ':')
        disp(max(voltF(:, n)))
    end
    title('Front voltage')
    xticks([])
    ylabel('Voltage (V)')
    Lgnd = legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(voltF, 2), 'UniformOutput', false));
    %Lgnd = legend(legendText)
    Lgnd.Position(1) = 0.44;
    Lgnd.Position(2) = 0.45;
    %subtitle("Max: ")
    
    nexttile
    hold on
    for n = 1:initials
        plot(timeVector, voltB(tStart:end, n), 'LineStyle', ':')
    end
    title('Back voltage')
    xticks([])
    %ylabel('Voltage (V)')
    
    disp("Right voltages:")
    nexttile
    hold on
    for n = 1:initials
        plot(timeVector, voltR(tStart:end, n), 'LineStyle', ':')
        disp(max(voltR(:, n)))
    end
    title('Right voltage')
    xticks([])
    ylabel('Voltage (V)')
    
    nexttile
    hold on
    for n = 1:initials
        plot(timeVector, voltL(tStart:end, n), 'LineStyle', ':')
    end
    title('Left voltage')
    %xlabel('Time indexes')
    xticks([])
    %ylabel('Voltage (V)')
    
    %fontsize(fig7, %fontsize, "points")
    if savePlot == 1
        saveas(fig7, append('images/', plotName, '_voltages_', simuName, '.png'))
    end
    
    fig8 = figure(8);
    for n = 1:initials
        plot3(yPitch(tStart:end, n), yRoll(tStart:end, n), xRoll(tStart:end, n), 'LineStyle', ':')
        hold on
    end
    title('Velocity-velocity-angle limit cycle')
    xlabel('Pitch velocity')
    ylabel('Roll velocity')
    zlabel('Roll angle')
    
    xlim([minPitch - pRange*0.1, maxPitch + pRange*0.1])
    ylim([minRoll - rRange*0.1, maxRoll + rRange*0.1])
    
    legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
    %fontsize(fig8, %fontsize, "points")
    if savePlot == 1
        saveas(fig8, append('images/', plotName, '_3d_velocities_', simuName, '.png'))
    end

    fig9 = figure(9);
    
    tiledlayout(2, 2, 'Padding', 'none', 'TileSpacing', 'loose');

    nexttile
    hold on
    for n = 1:initials
        plot(timeVector, xPitch(tStart:end, n), 'LineStyle', ':')
    end
    title('Pitch angle')
    %xticks([])
    ylabel('Angle (degrees)')
    xlabel('Time')

    Lgnd = legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(voltF, 2), 'UniformOutput', false));
    %Lgnd = legend(legendText)
    Lgnd.Position(1) = 0.44;
    Lgnd.Position(2) = 0.45;
    
    end_index = 1;
    transformables = [xPitch, xRoll];
    assignin('base','tr', transformables);
    for n = 1:initials
        for d = 1:length(transformables(1, :))/initials
            fourierTemp = abs(fft(transformables(:, n*d)));
            tempMax = max(fourierTemp(1:((vLength-1)/2)));
            thresh = tempMax*0.01;
            for nn = 1:vLength
                if max(fourierTemp(nn:((vLength-1)/2))) < thresh
                    if nn > end_index
                        end_index = nn;
                    end
                    break
                end
            end
        end
    end
    N = end_index + round(vLength*0.001);
    fs = N/tTime;
    f = fs*(0:N/2-1)/N;

    %f = 0:fs/2-1

    nexttile
    hold on    
    for n = 1:initials
        fourier = fft(xPitch(:, n));
        fourier_half = fourier(1:N/2);
        Fr = abs(fourier_half)/(N/2);
        %%%%%% But the question is, can I select the sampling frequency
        %%%%%% freely or is that something I should be finding out?
        assignin('base','fourier', fourier);
        plot(f, Fr, 'LineStyle', ':')
    end
    title('Pitch fourier')
    %xticks([])
    ylabel('Transform')
    xlabel('Frequencies')
    %subtitle("Max: ")

    nexttile
    hold on
    for n = 1:initials
        plot(timeVector, xRoll(tStart:end, n), 'LineStyle', ':')
    end
    title('Roll angle')
    %xticks([])
    ylabel('Angle (degrees)')
    xlabel('Time')
    
    nexttile
    hold on    
    for n = 1:initials
        fourier = fft(xRoll(:, n));
        fourier_half = fourier(1:N/2);
        f = fs*(0:N/2-1)/N;
        Fr = abs(fourier_half)/(N/2);
        %%%%%% But the question is, can I select the sampling frequency
        %%%%%% freely or is that something I should be finding out?
        assignin('base','fourier', fourier);
        plot(f, Fr, 'LineStyle', ':')
    end
    
    title('Roll fourier')
    ylabel('Transform')
    xlabel('Frequencies')
    if savePlot == 1
        saveas(fig9, append('images/', plotName, '_fourier_', simuName, '.png'))
    end
end