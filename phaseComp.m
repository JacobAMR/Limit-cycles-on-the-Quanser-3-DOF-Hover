%AddLetters2Plots(fig1, 'HShift', 0, 'VShift', 0, 'Direction', 'LeftRight'), saveas(fig1, append('images/keep/', testName, '_phaseComp.png'))

%clear, clc
lookups = ["lookup_advancedPGain2.mat", "lookup_advanced_noSat2"];
skipSims = 1;
%simuName = "advanced_feedback";

warning('off', 'all')

%%%
derivative = [0, 0];
saturation = [1, 0];

flexSize = [1.2, 1.2];

%inputWeights = [50, 1]; 
%inputWeights = [500, 0.1];  

plotNo = 1;
external = 1;
%feedbackType = "trajectory";
feedbackType = "none";
sets_external = 1;
sets = 8;

%compType = ["numerical derivative", "true derivative"];
%compType = ["voltage saturation", "no saturation"];
compType = ["voltage saturation", "no saturation"];
modelType = ["Linear", "Nonlinear", "Improved nonlinear"];
modelCode = ["LM", "NM", "IM"];
%modelType = ["linear"];
simuNames = ["cycletest_feedback", "nonlin_feedback", "advanced_feedback"];
%simuNames = ["cycletest_feedback"];

testName = "sizeLimit";

for mNo = 1:length(simuNames)
    if skipSims == 0
        simuName = simuNames(mNo);
        simuNo = 2;

        for no = 1:simuNo
            if exist('derivative','var') == 1
                der = derivative(no);
            end
            if exist('saturation','var') == 1
                sat = saturation(no);
                load(lookups(no))
            end
            if exist('flexSize', 'var') == 1
                r = flexSize(no);
            end
            if exist('inputWeights','var') == 1
                R = inputWeights(no)*eye(2);
            end
            %derivative(no)
            %disp(der)
            %simuName = simuNames(no);
            simulate_hover;
            vLength = length(xPitch);
            if exist('modelPitchM', 'var') ~= 1
                modelPitchM = zeros(vLength, simuNo*length(simuNames));
                modelRollM = zeros(vLength, simuNo*length(simuNames));
                % modelFrRoll = zeros(vLength, simuNo);
                % modelFrPitch = zeros(vLength, simuNo);
                modelf = zeros(vLength, simuNo);
                voltageMatrix1 = zeros(vLength, 4*length(simuNames));
                voltageMatrix2 = zeros(vLength, 4*length(simuNames));
                cycleTrajectory1 = zeros(2001, 2);
                cycleTrajectory2 = zeros(2001, 2);
                timeVector = (sampleTime):sampleTime:(vLength*sampleTime);
            end
            modelPitchM(:, 2*mNo+no-2) = xPitch;
            modelRollM(:, 2*mNo+no-2) = xRoll;
            if no == 1
                voltageMatrix1(:, (-3:0) + 4*mNo) = [voltF, voltB, voltR, voltL];
                cycleTrajectory1 = cycleTrajectory;
            elseif no == 2
                voltageMatrix2(:, (-3:0) + 4*mNo) = [voltF, voltB, voltR, voltL];
                cycleTrajectory2 = cycleTrajectory;
            end
            %cycleTrajectoryM(:, (-1:0) + 2*no) = cycleTrajectory;
        
        end
    end
end

startTime = 150;
stateNames = ["pitch", "roll"]; %%%%%
stateType = "angle";
unitType = "(degrees)";

close all
%figure(1)

fig1 = figure(1);

t1 = tiledlayout(3, 2,'TileSpacing','Compact','Padding','Compact');

for mNo = 1:length(simuNames)

    modelPitch = modelPitchM(:, (-1:0) + mNo*2);
    modelRoll = modelRollM(:, (-1:0) + mNo*2);
    
    cycleScaled1 = cycleTrajectory1*180/pi;
    cycleScaled2 = cycleTrajectory2*180/pi;

    xM = [modelPitch(startTime/sampleTime:end, 1), modelRoll(startTime/sampleTime:end, 1)];
    xMbase = [modelPitch(startTime/sampleTime:end, 2), modelRoll(startTime/sampleTime:end, 2)];
    [vLength2, statesNo] = size(xM);
    
    nexttile
    hold on
    if exist('inputWeights','var') == 1
        pl1 = plot(xM(:, 1), xM(:, 2), 'b', 'DisplayName', append("results with ", compType(1)), "LineWidth", 2.1);
    else
        pl1 = plot(xM(:, 1), xM(:, 2), 'b', 'DisplayName', append("results with ", compType(1)));
    end

    pl2 = plot(cycleScaled1(:, 1), cycleScaled1(:, 2), 'r', 'DisplayName', 'desired results');
    %pl2 = plot(cycleScaled1(:, 1), cycleScaled1(:, 2), 'r', 'DisplayName', 'desired results (large radius)');
    if exist('flexSize','var') == 1
        ylim([-80.01, 80.01])
        xlim([-60.01, 60.01])
    else
        ylim([-40.01, 40.01])
        xlim([-30.01, 30.01])
    end
    xlabel("Pitch angle")
    ylabel("Roll angle")
    %title(append("Phase plots for ", modelType(mNo), " model"), 'Position', [36, 41])
    %legend(append("results with ", compType(1)), "desired results")
    
    nexttile
    hold on
    if exist('inputWeights','var') == 1
        pl3 = plot(xMbase(:, 1), xMbase(:, 2), 'g*', 'DisplayName', append("results with ", compType(2)), "LineWidth", 2.1);
    else
        pl3 = plot(xMbase(:, 1), xMbase(:, 2), 'g', 'DisplayName', append("results with ", compType(2)));
    end
    pl4 = plot(cycleScaled2(:, 1),cycleScaled2(:, 2), 'r');
    %pl4 = plot(cycleScaled2(:, 1),cycleScaled2(:, 2), "color", [0.9290 0.6940 0.1250], 'DisplayName', 'desired results (medium radius)');
    if exist('flexSize','var') == 1
        ylim([-80.01, 80.01])
        xlim([-60.01, 60.01])
        title(append(modelType(mNo), " model"), 'Position', [-75, 79])
    else
        ylim([-40.01, 40.01])
        xlim([-30.01, 30.01])
        title(append(modelType(mNo), " model"), 'Position', [-37, 41])  
    end
    xlabel("Pitch angle")
    ylabel("Roll angle")
    %title(append(modelType(mNo), " model"), 'Position', [-75, 79])
    %title(append(modelType(mNo), " model"), 'Position', [-37, 41])  
    %title(append("Phase plot for ", modelType(mNo), " results"))
    %title("Phase plot for reference limit cycle")
    %legend(append("results with ", compType(2)), "desired results")

    xError = zeros(vLength2, statesNo);

    for nn = 1:vLength2
        xError(nn, :) = approxLimit_error(transpose(xM(nn, :)*pi/180), cycleTrajectory1)*180/pi-transpose(xM(nn, :));
    end

    baseError = zeros(vLength2, statesNo);
    for nn = 1:vLength2
        baseError(nn, :) = approxLimit_error(transpose((xMbase(nn, :)-mean(xMbase, 1))*pi/180), cycleTrajectory2)*180/pi-transpose(xMbase(nn, :));
    end

    if mNo == 1
        disp("\begin{table}[]")
        disp("\centering")
        disp("\begin{tabular}{|c|c|c|c|c|c|}")
        fprintf(append("\\hline\nModel & State ", unitType," & RMSE (1) & MAE (1) & RMSE (2) & MAE (2) \\\\ \n\\hline \n"))
    end
    indices = zeros(4, statesNo);
    for stt = 1:statesNo
        
        % xErrorTemp = xError(:, stt);
        % 
        % MSE = mean(xErrorTemp.^2, 1);
        % indices(1, stt) = sqrt(MSE);
        % %indices(3, stt) = 1 - sum(abs(xErrorTemp), 1)/sum(abs(baseError(:, stt)), 1);
        % %indices(2, stt) = indices(1, stt)/(max(cycleScaled(:, stt))-min(xM(nn, :)));
        % indices(2, stt) = indices(1, stt)/(max(xM(stt, :))-min(xM(stt, :)));
        % indices(3, stt) = mean(abs(xErrorTemp), 1);
        % indices(4, stt) = 1 - mean(baseError(:, stt).^2, 1)/MSE;
        % %indices(3, stt) = sum(timeVector2.*abs(xErrorTemp), 1);
        % %indices(4, stt) = sum(timeVector2.*(xErrorTemp.^2), 1);

        indices(1, stt) = sqrt(mean(xError(:, stt).^2, 1));
        indices(2, stt) = mean(abs(xError(:, stt)), 1);
        indices(3, stt) = sqrt(mean(baseError(:, stt).^2, 1));
        indices(4, stt) = mean(abs(baseError(:, stt)), 1);
    
        % metricString = append("test x & x", num2str(stt), " & %.4g & %.4g & %.4g & %.4g");
        %metricString = append(modelCode(mNo), " & ", stateNames(stt), " ", stateType, " & %.4g & %.4g & %.4g & %.4g");
        metricString = append(modelType(mNo), " & ", stateNames(stt), " ", stateType, " & %.4g & %.4g & %.4g & %.4g");
        metricString = append(metricString, " \\\\ \n\\hline \n");
        fprintf(metricString, indices(1, stt), indices(2, stt), indices(3, stt), indices(4, stt))
    end
end
disp("\end{tabular}")
disp(append("\caption{Error metrics for simulations with ", compType(1), " (1), and simulations with ", compType(2), " (2)}"))
disp(append("\label{tab:", strrep(testName, " ", "_"), "_metrics}"))
disp("\end{table}")
disp(" ")

%hL = legend([pl1, pl3, pl2], 'Position', [0.64 0.86 0.35 0.1]);
hL = legend([pl1, pl3, pl2], 'Position', [0.64 0.86 0.35 0.1]); 

set(hL.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.7]));  % [.5,.5,.5] is light gray; 0.8 means 20% transparent

AddLetters2Plots(fig1, 'HShift', 0, 'VShift', 0, 'Direction', 'LeftRight')

saveas(fig1, append('images/keep/', testName, '_phaseComp.png'))

disp("\begin{figure}")
disp("\centering")
disp(append("\includegraphics[width=0.8\linewidth]{", "Bilder/", testName, "_phaseComp.png}"))
disp(append("\caption{(A) Phase plot for results with ", compType(1) ," compared to desired results, for ", modelType(1), " model. (B) Phase plot for results with ", compType(2) ," compared to desired results, for ", modelType(1), " model. (C-D) Same as (A-B), but for ", modelType(2), " model. (E-F) Same as (A-B), but for ", modelType(3), " model.}"))
disp(append("\label{fig:", strrep(testName, " ", "_"), "_phaseComp}"))
disp("\end{figure}")

fig2 = figure(2);
%fig2.Position = [200 100 640 780];
t1 = tiledlayout(3, 2,'TileSpacing','Compact','Padding','Compact');

timeLim = 1200;

whatever = 0;
if whatever == 1
    timeVectorx = timeVector(1:(timeLim/sampleTime));
    voltageMatrix1x = voltageMatrix1(1:(timeLim/sampleTime), :);
    voltageMatrix2x = voltageMatrix2(1:(timeLim/sampleTime), :);
    vLengthx = timeLim/sampleTime;
else
    timeVectorx = timeVector;
    voltageMatrix1x = voltageMatrix1;
    voltageMatrix2x = voltageMatrix2;
    vLengthx = vLength;
end

voltLines = 1.5;

for mNo = 1:length(simuNames)
    nexttile
    hold on
    plot(timeVectorx, voltageMatrix1x(:, -3 + 4*mNo), "LineWidth", voltLines)
    plot(timeVectorx, voltageMatrix1x(:, -2 + 4*mNo), "LineWidth", voltLines)
    plot(timeVectorx, voltageMatrix1x(:, -1 + 4*mNo), "LineWidth", voltLines)
    plot(timeVectorx, voltageMatrix1x(:, 0 + 4*mNo), "LineWidth", voltLines)
    plot(timeVectorx, 24*ones(vLengthx, 1), ":", "color", [.7 .7 .7])
    plot(timeVectorx, zeros(vLengthx, 1), ":", "color", [.7 .7 .7])
    hold off
    xlim([0, timeLim])
    xlabel("Time (s)")
    % ylabel("Voltage (V)")
    % if mNo == 1
    %     title(append("Voltages for ", compType(1), " by model"))
    % end
    %title(append("Voltages for ", modelType(mNo), " model"), 'Position', [1350, 30.5])
    title(append("Voltages for ", modelType(mNo), " model"), 'Position', [timeLim*1.1, 30.5])
    nexttile
    hold on
    plot(timeVectorx, voltageMatrix2x(:, -3 + 4*mNo), "LineWidth", voltLines)
    plot(timeVectorx, voltageMatrix2x(:, -2 + 4*mNo), "LineWidth", voltLines)
    plot(timeVectorx, voltageMatrix2x(:, -1 + 4*mNo), "LineWidth", voltLines)
    plot(timeVectorx, voltageMatrix2x(:, 0 + 4*mNo), "LineWidth", voltLines)
    plot(timeVectorx, 24*ones(vLengthx, 1), ":", "color", [.7 .7 .7])
    plot(timeVectorx, zeros(vLengthx, 1), ":", "color", [.7 .7 .7])
    hold off

    xlim([0, timeLim])
    xlabel("Time (s)")
    ylabel("Voltage (V)")
    if mNo == 1
        hL = legend("Front voltage", "Back voltage", "Right voltage", "Left voltage", "Voltage limits");
        %title(append("Voltages for ", compType(2), " by model"))
    end
end
sgtitle(append(compType(1), "                                  ", compType(2)))

AddLetters2Plots(fig2, 'HShift', 0, 'VShift', 0, 'Direction', 'LeftRight')

set(hL.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.7]));  % [.5,.5,.5] is light gray; 0.8 means 20% transparent

saveas(fig2, append('images/keep/', testName, '_voltages.png'))


disp(" ")
disp("\begin{figure}")
disp("\centering")
disp(append("\includegraphics[width=0.8\linewidth]{", "Bilder/", testName, "_voltages.png}"))
%disp(append("\caption{(A) Voltages for simulation with ", compType(1) ,", for ", modelType(1), " model. (B) voltages of simulation with ", compType(2) ,", for ", modelType(1), " model. (C-D) Same as (A-B), but for ", modelType(2), " model. (E-F) Same as (A-B), but for ", modelType(3), " model.}"))
disp(append("\caption{(A) Voltages over the first ", num2str(timeLim), " for simulation with ", compType(1) ,", for ", modelType(1), " model. (B) voltages of simulation with ", compType(2) ,", for ", modelType(1), " model. (C-D) Same as (A-B), but for ", modelType(2), " model. (E-F) Same as (A-B), but for ", modelType(3), " model.}"))
disp(append("\label{fig:", strrep(testName, " ", "_"), "_voltages}"))
disp("\end{figure}")