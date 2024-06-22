function [plotName, startTime, stopTime, space, x0M] = set_sim_params(long, sampleTime, plotName, plotMax, simuName, sat, method, der, sets, initials, cycle, feedbackType, cycleType)
    
    %%% Start time of the plotting and stop time of the simulation
    if long == 0
        stopTime = 600;
        startTime = 0;
        plotName = append(plotName, '_short');
    elseif long == 1
        startTime = 1000;
        stopTime = 1200;
        plotName = append(plotName, '_long');
    end
    
    % This part sets the necessary space between datapoints to create the
    % desired plotMax, and the "if" clause makes sure it doesn't try to make a plot bigger than the simulation array
    % size.
    if plotMax < stopTime/sampleTime
        space = stopTime/(plotMax*sampleTime);
    else
        space = 1;
    end
    
    
    %%% Saturation on or off, method selection, cycle type
    if strcmp(cycle, '3d') ~= 1
        if sat == 0
           set_param(append(simuName, '/torqueTranslate/sat1'), 'sw', '1')
           set_param(append(simuName, '/torqueTranslate/sat2'), 'sw', '1')
           plotName = append(plotName, '_unsat');
        elseif sat == 1
           set_param(append(simuName, '/torqueTranslate/sat1'), 'sw', '0')
           set_param(append(simuName, '/torqueTranslate/sat2'), 'sw', '0')
           plotName = append(plotName, '_sat');
        end
        if strcmp(method, 'bias')
            set_param(append(simuName, '/torqueTranslate/method'), 'sw', '1')
            set_param(append(simuName, '/m1'), 'sw', '1')
            set_param(append(simuName, '/m2'), 'sw', '0')
            set_param(append(simuName, '/m3'), 'sw', '1')
            set_param(append(simuName, '/m4'), 'sw', '0')
            set_param(append(simuName, '/d1'), 'sw', '1')
            set_param(append(simuName, '/d2'), 'sw', '0')
            set_param(append(simuName, '/d3'), 'sw', '1')
            set_param(append(simuName, '/d4'), 'sw', '1')
            plotName = append(plotName, '_bias');
        elseif strcmp(method, 'func')
            set_param(append(simuName, '/torqueTranslate/method'), 'sw', '0')
            set_param(append(simuName, '/m1'), 'sw', '0')
            set_param(append(simuName, '/m2'), 'sw', '1')
            set_param(append(simuName, '/m3'), 'sw', '0')
            set_param(append(simuName, '/m4'), 'sw', '1')
            set_param(append(simuName, '/d1'), 'sw', '1')
            set_param(append(simuName, '/d2'), 'sw', '0')
            set_param(append(simuName, '/d3'), 'sw', '1')
            set_param(append(simuName, '/d4'), 'sw', '1')
            plotName = append(plotName, '_func');
        elseif strcmp(method, 'double')
            set_param(append(simuName, '/torqueTranslate/method'), 'sw', '1')
            set_param(append(simuName, '/m1'), 'sw', '1')
            set_param(append(simuName, '/m2'), 'sw', '0')
            set_param(append(simuName, '/m3'), 'sw', '1')
            set_param(append(simuName, '/m4'), 'sw', '0')
            set_param(append(simuName, '/d1'), 'sw', '0')
            set_param(append(simuName, '/d2'), 'sw', '1')
            set_param(append(simuName, '/d3'), 'sw', '0')
            set_param(append(simuName, '/d4'), 'sw', '0')
            plotName = append(plotName, '_double');
        end
        if strcmp(cycleType, 'angle') == 1
            set_param(append(simuName, '/feedback control/vel-angle_1'), 'sw', '0')
            set_param(append(simuName, '/feedback control/vel-angle_6'), 'sw', '0')
            set_param(append(simuName, '/feedbackSub/vel-angle_2'), 'sw', '1')
            set_param(append(simuName, '/feedbackSub/vel-angle_3'), 'sw', '1')
            set_param(append(simuName, '/feedbackSub/vel-angle_4'), 'sw', '0')
            set_param(append(simuName, '/feedbackSub/vel-angle_5'), 'sw', '0')
        elseif strcmp(cycleType, 'velocity') == 1
            set_param(append(simuName, '/feedback control/vel-angle_1'), 'sw', '1')
            set_param(append(simuName, '/feedbackSub/vel-angle_2'), 'sw', '0')
            set_param(append(simuName, '/feedbackSub/vel-angle_3'), 'sw', '0')
            set_param(append(simuName, '/feedbackSub/vel-angle_4'), 'sw', '1')
            set_param(append(simuName, '/feedbackSub/vel-angle_5'), 'sw', '1')
        end
    else
        if sat == 0
           set_param(append(simuName, '/torqueTranslate/sat1'), 'sw', '1')
        elseif sat == 1
           set_param(append(simuName, '/torqueTranslate/sat1'), 'sw', '0')
        end
    end

    if strcmp(cycle, 'vander') == 1
       set_param(append(simuName, '/feedbackSub/cycleSwitch'), 'sw', '0')
       set_param(append(simuName, '/feedback control/time_sim/feedback_cycleType'), 'sw', '0')
       plotName = append(plotName, '_vander');

    elseif strcmp(cycle, 'flexible') == 1
       set_param(append(simuName, '/feedbackSub/cycleSwitch'), 'sw', '1')
       set_param(append(simuName, '/feedback control/time_sim/feedback_cycleType'), 'sw', '1')
       plotName = append(plotName, '_flexible');
    end

    % if feedback == 0
    %    set_param(append(simuName, '/feedback_switch'), 'sw', '1')
    % elseif feedback == 1
    %    set_param(append(simuName, '/feedback_switch'), 'sw', '0')
    % end

    if strcmp(feedbackType, 'trajectory') == 1
       set_param(append(simuName, '/feedback control/timebased'), 'sw', '0')
       %set_param(append(simuName, '/feedback control/disable'), 'sw', '0')
       set_param(append(simuName, '/feedback_switch'), 'sw', '0')
    elseif strcmp(feedbackType, 'time') == 1
        set_param(append(simuName, '/feedback control/timebased'), 'sw', '1')
        %set_param(append(simuName, '/feedback control/disable'), 'sw', '1')
        set_param(append(simuName, '/feedback_switch'), 'sw', '0')
    elseif strcmp(feedbackType, 'none') == 1
        set_param(append(simuName, '/feedback_switch'), 'sw', '1')
    end
    
    %%% Initial condition sets
    x0M = zeros(6, initials);
    plotName = append(plotName, '_', num2str(initials), 'init');
    plotName = append(plotName, '_set', num2str(sets));
    if sets == 1
        x0M(1:6, 1) = transpose(0.1*[pi/2, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 2) = transpose(-0.5*[pi/2, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 3) = transpose(-0.1*[pi/2, pi/6, pi/10, 0, 0, 0]);
        %x0M(1:6, 4) = transpose(5*[pi/20, -pi/6, pi/6, 0, 0, 0]);
        %x0M(1:6, 5) = transpose(-5*[pi/20, -pi/6, pi/6, 0, 0, 0]);
    
    elseif sets == 2
        x0M(1:6, 1) = transpose(0.1*[pi/2, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 2) = transpose(5*[pi/20, -pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 3) = transpose(-5*[pi/20, -pi/6, pi/6, 0, 0, 0]);
    
    elseif sets == 3
        x0M(1:6, 1) = transpose(0.1*[pi/2, pi/6, pi/6, 1, 1, 1]);
        x0M(1:6, 2) = transpose(-0.5*[pi/2, pi/6, pi/6, 0.1, -0.5, 0.1]);
        x0M(1:6, 3) = transpose(-0.1*[pi/2, pi/6, pi/6, 1, 1, 1]);
    
    elseif sets == 4
        x0M(1:6, 1) = transpose(pi/180*[10, 10, 10, 0, 0, 0]);
        x0M(1:6, 2) = transpose(pi/180*[30, 30, 30, 0, 0, 0]);
        x0M(1:6, 3) = transpose(-pi/180*[20, 20, 20, 0, 0, 0]);
    elseif sets == 5
        x0M(1:6, 1) = transpose(pi/180*[4, 4, 4, 0, 0, 0]);
        x0M(1:6, 2) = transpose(pi/180*[30, 30, 30, 0, 0, 0]);
        x0M(1:6, 3) = transpose(-pi/180*[20, 20, 20, 0, 0, 0]);
    
    elseif sets == 6
        x0M(1:6, 1) = transpose(pi/180*[2, 2, 2, 0, 0, 0]);
        x0M(1:6, 2) = transpose(pi/180*[5, 5, 5, 0, 0, 0]);
        x0M(1:6, 3) = transpose(-pi/180*[2, 2, 2, 0, 0, 0]);
    elseif sets == 7
        x0M(1:6, 1) = transpose(pi/180*[1, 1, 1, 0, 0, 0]);
        x0M(1:6, 2) = transpose(pi/180*[2, 2, 2, 0, 0, 0]);
        x0M(1:6, 3) = transpose(-pi/180*[1, 1, 1, 0, 0, 0]);
    elseif sets == 8
        x0M(1:6, 1) = transpose(0.001*[0, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 2) = transpose(0.001*[0, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 3) = transpose(0.001*[0, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 4) = transpose(0.001*[0, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 5) = transpose(0.001*[0, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 6) = transpose(0.001*[0, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 7) = transpose(0.001*[0, pi/6, pi/6, 0, 0, 0]);
        x0M(1:6, 8) = transpose(0.001*[0, pi/6, pi/6, 0, 0, 0]);

    end
    
    %%%
    if der == 0
       set_param(append(simuName, '/derivative1'), 'sw', '0')
       set_param(append(simuName, '/derivative2'), 'sw', '0')
       set_param(append(simuName, '/derivative3'), 'sw', '0')
       plotName = append(plotName, '_der');
    elseif der == 1
       set_param(append(simuName, '/derivative1'), 'sw', '1')
       set_param(append(simuName, '/derivative2'), 'sw', '1')
       set_param(append(simuName, '/derivative3'), 'sw', '1')
       plotName = append(plotName, '_nonder');
    end
    %%% Test selection. By setting it = 0 you can freely adjust the parameters
    %%% above instead
    %%% I haven't actually finished all the test initializations though...
    testno = 0;
    if testno > 0
        plotName = append(plotName, '_', num2str(testno));
    elseif testno == 1
        stopTime = 200;
        startTime = sampleTime;
        space = 1;
    elseif testno == 2
    
    elseif testno == 3
    
    elseif testno == 4
    
    elseif testno == 5
    
    elseif testno == 6
    
    elseif testno == 7
    
    elseif testno == 8
    
    elseif testno == 9
    
    elseif testno == 10
    
    elseif testno == 11
    
    elseif testno == 12
    
    end
    
end