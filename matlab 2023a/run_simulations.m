function [xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL] = run_simulations(md, initials, stopTime, sampleTime, loadName, x0M, simuName, space, vM, paramTest)
    uM = vM(1, :);
    aM = vM(2, :);
    rM = vM(3, :);
    w0M = vM(4, :);
    if md > 0
        if md == 1
            %x0_temp = x0M(1:6, 1);
            if paramTest == 1
                assignin('base', 'u', uM(1))
                assignin('base', 'cycleGain', aM(1))
                assignin('base', 'r', rM(1))
                assignin('base', 'skew', w0M(1))
            else
                for k = 1:6
                    set_param(append(simuName, '/Subsystem/stateint', num2str(k)),'InitialCondition', num2str(x0M(k, 1)))
                    %set_param(append(simuName, '/feedback control/time_sim/Subsystem/stateint', num2str(k)),'InitialCondition', num2str(x0M(k, 1)))
                end
            end

            simout = sim(simuName, 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));
            pitchvalues = simout.pitchvalues;
            rollvalues = simout.rollvalues;
            yawvalues = simout.yawvalues;
            voltages = simout.voltages;
    
        elseif md == 2
            load(append('arrays/', loadName, '_1.mat'), 'X')
            yawvalues = X(:, 1:2);
            pitchvalues = X(:, 3:4);
            rollvalues = X(:, 5:6);
        end
        
        %l = length(yawvalues(:, 1))
        vLength = length(yawvalues(1:space:end, 1));
    
        yYaw = zeros(vLength, initials);
        xYaw = zeros(vLength, initials);
        yPitch = zeros(vLength, initials);
        xPitch = zeros(vLength, initials);
        yRoll = zeros(vLength, initials);
        xRoll = zeros(vLength, initials);
        voltF = zeros(vLength, initials);
        voltB = zeros(vLength, initials);
        voltR = zeros(vLength, initials);
        voltL = zeros(vLength, initials);
    
        yYaw(1:end, 1) = yawvalues(1:space:end, 1);
        xYaw(1:end, 1) = yawvalues(1:space:end, 2);
        yPitch(1:end, 1) = pitchvalues(1:space:end, 1);
        xPitch(1:end, 1) = pitchvalues(1:space:end, 2);
        yRoll(1:end, 1) = rollvalues(1:space:end, 1);
        xRoll(1:end, 1) = rollvalues(1:space:end, 2);
        voltF(1:end, 1) = voltages(1:space:end, 1);
        voltB(1:end, 1) = voltages(1:space:end, 2);
        voltR(1:end, 1) = voltages(1:space:end, 3);
        voltL(1:end, 1) = voltages(1:space:end, 4);
        
        if md == 1
            X = [yawvalues, pitchvalues, rollvalues];
            save(append('arrays/', simuName, '_1.mat'), 'X');
        end
        if initials > 1
            for n = 2:initials
                if md == 1
                    %x0_temp = x0M(1:6, n);
                    %assignin('base', 'x0', 'x0_temp');
                    if paramTest == 1
                        assignin('base', 'u', uM(n))
                        assignin('base', 'cycleGain', aM(n))
                        assignin('base', 'r', rM(n))
                        assignin('base', 'skew', w0M(n))
                    else
                        for k = 1:6
                            set_param(append(simuName, '/Subsystem/stateint', num2str(k)),'InitialCondition', num2str(x0M(k, n)))
                            %set_param(append(simuName, '/feedback control/time_sim/Subsystem/stateint', num2str(k)),'InitialCondition', num2str(x0M(k, 1)))
                        end
                    end
                    simout = sim(simuName, 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));
                    pitchvalues = simout.pitchvalues;
                    rollvalues = simout.rollvalues;
                    yawvalues = simout.yawvalues;
                    voltages = simout.voltages;

                elseif md == 2
                    load(append('arrays/', loadName, '_', string(n)), '.mat', 'X')
                    yawvalues = X(:, 1:2);
                    pitchvalues = X(:, 3:4);
                    rollvalues = X(:, 5:6);
                end
    
                yYaw(1:end, n) = yawvalues(1:space:end, 1);
                xYaw(1:end, n) = yawvalues(1:space:end, 2);
                yPitch(1:end, n) = pitchvalues(1:space:end, 1);
                xPitch(1:end, n) = pitchvalues(1:space:end, 2);
                yRoll(1:end, n) = rollvalues(1:space:end, 1);
                xRoll(1:end, n) = rollvalues(1:space:end, 2);
                voltF(1:end, n) = voltages(1:space:end, 1);
                voltB(1:end, n) = voltages(1:space:end, 2);
                voltR(1:end, n) = voltages(1:space:end, 3);
                voltL(1:end, n) = voltages(1:space:end, 4);
                if md == 1
                    X = [yawvalues, pitchvalues, rollvalues];
                    save(append('arrays/', simuName, '_', string(n) ,'.mat'), 'X');
                end
            end
        end
    end
end