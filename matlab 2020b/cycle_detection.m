%%%%%% REQUIRES RUNNING SIMULATE_HOVER FIRST

close all

%fontSize = 12;
set(0,'DefaultTextFontSize', 12);
set(0, 'DefaultLineLineWidth', 1.2);

%figure('Renderer', 'painters', 'Position', [10 10 900 600])

if exist('modelTypes','var') ~= 1
    modelType = "advanced";
    feedbackType = "normal";
    cycle = "flexible";
end
testName = append(modelType, "_", feedbackType, "_", cycle);

sampleTime = 0.002;

rhoPeaks = 2;
centerOrigin = 0;

startTime = 150;
endTime = 200;
interrupt = 600;
startIndex = startTime/(sampleTime);

%sim("glycosis_sim", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));
%sim("brusselator_sim", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));

start = startTime/sampleTime;

if strcmp(cycle, "3d") == 1
    stateNames = ["yaw", "pitch" "roll"];
else
    stateNames = ["pitch", "roll"];
end
stateType = "angle";
unitType = "(degrees)";

statesNo = length(stateNames);

%xMtemp = [xYaw(:, 1), xPitch(:, 1), xRoll(:, 1)];
xMtemp = zeros(length(xPitch), statesNo);

for stt = 1:statesNo
    if strcmp(stateNames(stt), "yaw")
        xMtemp(:, stt) = xYaw;
    elseif strcmp(stateNames(stt), "pitch")
        xMtemp(:, stt) = xPitch;
    elseif strcmp(stateNames(stt), "roll")
        xMtemp(:, stt) = xRoll;
    end
end

xM = xMtemp((start+1):(interrupt/sampleTime+1), :);

xMean = mean(xM, 1);

if centerOrigin == 1
    center = zeros(1, statesNo);
else
    center = xMean;
end

xMd = xM - center;
%xM = xMd;

vLength = length(xM);

% for n = 1:statesNo
%     xM(:, n) = xM((start+1):end, n);
%     xM(:, n) = xM(:, n) - mean(xM(:, n));
% end

tStart = startTime + sampleTime;
tEnd = round(endTime/(sampleTime)) + 1;
tTime = vLength*sampleTime;
%timeVector = transpose((tStart*(tTime/vLength)):(tTime/vLength):endTime);
timeVector = transpose(start*sampleTime:(sampleTime):(endTime));

fig1 = figure(1);
fig1.Position = [100 100 540 250];

tiledlayout(1, 2, 'Padding', 'none', 'TileSpacing', 'loose');

endIndex = endTime/sampleTime - start + 1;

cycleScaled = cycleTrajectory*180/pi;
%title("Phase plot for z")
if statesNo == 2
    nexttile
    hold on
    plot(xM(:, 1), xM(:, 2))
    plot(cycleScaled(:, 1),cycleScaled(:, 2))
    %ylim([-40.01, 40.01])
    title("Phase plot for x_r and x_d")
    xlabel(append(stateNames(1), " ", stateType, " ", unitType))
    ylabel(append(stateNames(2), " ", stateType, " ", unitType))
    %title("Phase plot for reference limit cycle")

    nexttile
    hold on
    plot(xMd(:, 1), xMd(:, 2))
    plot(cycleScaled(:, 1),cycleScaled(:, 2))
    xlabel(append(stateNames(1), " ", stateType, " ", unitType))
    ylabel(append(stateNames(2), " ", stateType, " ", unitType))
    title("Phase plot for centered x_r and x_d")
    
    legendTemp = legend("Measured results from x_r", "Desired results from z");
elseif statesNo == 3
    nexttile
    plot3(xM(:, 1), xM(:, 2), xM(:, 3))
    hold on
    %plot3(cycleScaled(:, 1), cycleScaled(:, 2), cycleScaled(:, 3), "LineWidth", lineWidth)
    plot3(cycleScaled(:, 1), cycleScaled(:, 2), cycleScaled(:, 3))
    xlabel(append(stateNames(1), " ", stateType, " ", unitType))
    ylabel(append(stateNames(2), " ", stateType, " ", unitType))
    zlabel(append(stateNames(3), " ", stateType, " ", unitType))
    title("Phase plot for x_r and x_d")
    
    nexttile
    plot3(xMd(:, 1), xMd(:, 2), xMd(:, 3))
    hold on
    plot3(cycleScaled(:, 1), cycleScaled(:, 2), cycleScaled(:, 3))
    xlabel(append(stateNames(1), " ", stateType, " ", unitType))
    ylabel(append(stateNames(2), " ", stateType, " ", unitType))
    zlabel(append(stateNames(3), " ", stateType, " ", unitType))
    title("Phase plot for centered x_r and x_d")

end
%legend("Measured results from x_r", "Desired results from z")
hold off
%fontsize(fig1, fontSize, "points")

%AddLetters2Plots(fig1, {'C', 'D'}, 'HShift', 0, 'VShift', 0, 'Direction', 'TopDown')
saveas(fig1, append('images/', testName, '_phaseplot.png'))

%%%
fig2 = figure(2);

if strcmp(cycle, "3d") == 1
    fig2.Position = [100 100 540 300];
else
    fig2.Position = [100 100 540 200];
end

tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');
for stt = 1:statesNo
    nexttile
    x = xMtemp(1:endTime/sampleTime, stt);
    plot(sampleTime:sampleTime:endTime, x, 'LineStyle', '-')
    title(append(stateNames(stt)))
    %xticks([])
    yRange = max(x) - min(x);
    ylim([min(x)-yRange*0.1, max(x)+yRange*0.1])
    ylabel(append(stateType(1), " ", unitType(1)))
    xlabel('time (s)')
end

%AddLetters2Plots(fig2, 'HShift', 0, 'VShift', -0.02, 'Direction', 'TopDown')
saveas(fig2, append('images/', testName, '_timeplot.png'))

%%%
fig3 = figure(3);
tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');
for stt = 1:statesNo
    nexttile
    histogram(xM(:, stt));
    title(append("Histogram for ", stateNames(stt), " ", stateType, " ", unitType))
    xlabel("Angle (degrees)")
end

x_shiftM = zeros(vLength, statesNo);
corrDelay = zeros(statesNo, 1);

for stt = 1:statesNo
    corrSum = 10;
    x = xMd(:, stt);
    for n = 0.1:0.1:10
        x_shift_temp = circshift(x, int32(n/sampleTime));
        %disp(corrcoef(x, x_shift_temp))
        tempCorr = corrcoef(x, x_shift_temp);
        tempCsum = sum(abs(tempCorr), "all");
        if corrSum > tempCsum
            corrDelay(stt) = n;
            corrSum = tempCsum;
            finalCorr = tempCorr; %%% Not actually being used
        end
    end
    x_shiftM(:, stt) = circshift(x, int32(corrDelay(stt)/sampleTime));
end

% disp(corrSum)
% disp(corrDelayGlycosis)
% disp(finalCorr)

%x_shift = circshift(x, int32(corrDelayBrussel/sampleTime));
%x_shift = circshift(x, int32(3/sampleTime));
%x_shift = circshift(y, int32(corrDelayBrussel/sampleTime));
%x2_shift = circshift(x2, int32(corrDelayGlycosis/sampleTime));

fig4 = figure(4);

tiledlayout(statesNo, 2, 'Padding', 'none', 'TileSpacing', 'loose');
for stt = 1:statesNo
    nexttile
    plot(timeVector, xMd(1:endIndex, stt))
    title(append(stateNames(stt), " ", stateType(1), " distance (from ", num2str(round(xMean(stt), 2)), ")"))
    ylabel(append(stateType(1), " ", unitType(1)))
    xlabel("Time (s)")
    nexttile
    plot(timeVector, x_shiftM(1:endIndex, stt))
    title(append(stateNames(stt), " ", stateType(1), " distance shifted by ", num2str(corrDelay(stt))))
end
fig5 = figure(5);

tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');
rho = zeros(vLength, statesNo);

for stt = 1:statesNo
    [thetaTemp, rhoTemp] = cart2pol(xMd(:, stt), x_shiftM(:, stt));
    rho(:, stt) = rhoTemp;
    
    nexttile
    plot(timeVector, rhoTemp(1:endIndex))
    title(append("Rho for ", stateNames(stt), " ", stateType(1)))
    ylabel(append(stateType(1), " ", unitType(1)))
    xlabel("time (s)")
end
%%%
fig6 = figure(6);

tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');

for stt = 1:statesNo
    nexttile
    %h = histogram(rho,  'BinLimits',[1.7,3.5]);
    h = histogram(rho(:, stt));
    title(append("Histogram of rho for ", stateNames(stt), " ", stateType(1), " ", unitType(1)))
end

fig7 = figure(7);

if strcmp(cycle, "3d") == 1
    fig7.Position = [100 100 540 150];
else
    fig7.Position = [100 100 540 250];
end

end_index = 1;
%transformables = [x(1:100:end), x2(1:100:end)];
%transformables = [x x2];
for d = 1:1:length(xM(1, :))
    fourierTemp = abs(fft(xM(:, d)));
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

timeVector2 = transpose((startTime + sampleTime):sampleTime:(interrupt+sampleTime));
%timeVector2 = (startTime+1):sampleTime:vLength;

tiledlayout(1, statesNo, 'Padding', 'none', 'TileSpacing', 'loose');

for stt = 1:statesNo

    % nexttile
    % plot(timeVector, xM(1:endIndex, stt), 'LineStyle', '-')
    % title(append(stateNames(stt), ' angle'))
    % %xticks([])
    % yRange = max(xM(1:endIndex, stt)) - min(xM(1:endIndex, stt));
    % ylim([min(xM(1:endIndex, stt))-yRange*0.1, max(xM(1:endIndex, stt))+yRange*0.1])
    % ylabel(append(stateType(1), " ", unitType(1)))
    % xlabel('time (s)')
 
    N = end_index + round(vLength*0.001);
    fs = N/(500);
    %fs = N/(vLength*sampleTime*1.001);
    %fs = sampleTime;
    
    f = fs*(0:N/2-1)/N;
    
    nexttile
    fourier = fft(xM(:, stt));
    fourier_half = fourier(1:N/2);
    Fr = abs(fourier_half)/(N/2);
    
    plot(f, Fr, 'LineStyle', '-')
    
    title(append(stateNames(stt), ' Fourier'))
    ylabel('Transform')
    xlabel('Frequencies (Hz)')
end

%sgtitle()

%Lgnd = legend(arrayfun(@(mode) sprintf('x%d', mode), 1:size(x, 2), 'UniformOutput', false));
%Lgnd = legend(legendText)
% Lgnd.Position(1) = 0.44;
% Lgnd.Position(2) = 0.45;

sgtitle("Fourier transforms")

%AddLetters2Plots(fig7, 'HShift', 0, 'VShift', 0, 'Direction', 'TopDown')
saveas(fig7, append('images/', testName, '_fourier.png'))

fig8 = figure(8);

tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');

for stt = 1:statesNo
    nexttile
    plot(xM(:, stt), x_shiftM(:, stt))
    xlabel(stateNames(stt))
    ylabel(append(stateNames(stt), " ", stateType, ' delayed by ', num2str(round(center(stt), 2))))
    title(append(stateNames(stt), " ", stateType, ' and time delayed ', stateNames(stt), " ", stateType))
end

sgtitle(append('Phase plot between state distance and time delayed state distance'))
%%%

fig9 = figure(9);
fig9.Position = [100 100 540 250];

tiledlayout(1, statesNo, 'Padding', 'none', 'TileSpacing', 'loose');
pdfSample = 1000;

p_xA{stt} = cell(1, statesNo);
histTitle = "Histogram of radius near center (";

for stt = 1:statesNo
    maxRange = max(rho(:, stt));
    xRange = 0:(maxRange/pdfSample):(maxRange); %# Range of integers to compute a probability for
    N = hist(rho(:, stt), xRange); %# Bin the data
    N = N./numel(x);
    %N(end+1) = 0;
    %N(numel(N)+2) = 0;
    %plot(xRange,N./numel(data)); %# Plot the probabilities for each integer
    %[M, I] = max(N(1:(pdfSample - 1)));
    [pks, locs] = findpeaks(N, 'SortStr','descend');
    I = max(locs);
    [Ifirst, locMin] = min(locs);
    M = pks(locMin);
    

    func = xRange*(M - N(1))/xRange(Ifirst);
    
    postPeakRange = int32(I*1.2);
    if postPeakRange > (pdfSample)
        postPeakRange = (pdfSample);
    end
    xRange = xRange(1:postPeakRange);
    N = N(1:postPeakRange);
    func = func(1:postPeakRange);
    p_x = polyfit(xRange(1:Ifirst), N(1:Ifirst), 2);
    poly = p_x(1)*xRange.^2 + p_x(2)*xRange + p_x(3);

    nexttile
    plot(xRange, N, xRange, func, xRange, poly)
    title(append(stateNames(stt), " ", stateType(1)))
    xlabel(append('Radius ', unitType));
    ylabel('Density');
    ylim([0, inf])

    p_xA{stt} = p_x;
    if stt == statesNo
        histTitle = append(histTitle, num2str(round(center(stt), 2)), ")^T");
    else
        histTitle = append(histTitle, num2str(round(center(stt), 2)), ", ");
    end
end
legend("Measured values", "Straight line", "Fitted polynomial")

sgtitle(histTitle)

%AddLetters2Plots(fig9, {'C', 'D'}, 'HShift', 0, 'VShift', 0, 'Direction', 'TopDown')
saveas(fig9, append('images/', testName, '_radhist.png'))

fig10 = figure(10);
tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');
for stt = 1:statesNo
    nexttile
    cdfplot(rho(:, stt))
    %title('Cumulative plot for ', stateNames(stt), ' angle distance')
end

fig11 = figure(11);

%vLength = round(vLength*0.05, 0);

tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');

xError = zeros(vLength, statesNo);
for nn = 1:vLength
    xError(nn, :) = approxLimit(transpose(xMd(nn, :)*pi/180))*180/pi-transpose(xMd(nn, :));
end

disp("\begin{table}[]")
disp("\centering")
disp("\begin{tabular}{|c|c|c|c|c|c|}")
fprintf(append("\\hline\nModel & State ", unitType," & RMSE & NRMSE & MAE & Center distance & Curvature \\\\ \n\\hline \n"))
indices = zeros(4, statesNo);
for stt = 1:statesNo
    % xErrorTemp = zeros(vLength, 1);
    % for nn = 1:vLength
    %     xErrorTemp(nn) = approxLimit(xM(nn, stt));
    % end
    % xError(:, stt) = xErrorTemp;
    xErrorTemp = xError(:, stt);

    % Order: RMSE & NRMSE & MAE & distance from center
    indices(1, stt) = sqrt(sum((xErrorTemp.^2), 1));
    indices(2, stt) = indices(1, stt)/(max(cycleScaled(:, stt))-min(cycleScaled(:, stt)));
    indices(3, stt) = sum(abs(xErrorTemp), 1);
    %indices(4, stt) = 1 - indices(3, stt)/sum(abs(baseError(:, stt)), 1);
    indices(4, stt) = center(stt);
    %indices(3, stt) = sum(timeVector2.*abs(xErrorTemp), 1);
    %indices(4, stt) = sum(timeVector2.*(xErrorTemp.^2), 1);

    nexttile
    plot(timeVector2, xErrorTemp)
    title(append(stateNames(stt), " ", stateType))
    ylabel(append('error'))
    xlabel("Time (s)")
    %metricString = append("test x & x", num2str(n), " & ", num2str(polyder(polyder(p_x))), " & ", num2str(indices(1, n)), " & ", num2str(indices(2, n)), " & ", num2str(indices(3, n)), " & ", num2str(indices(4, n)));

    metricString = append("test x & ", stateNames(stt), " ", stateType, " ", unitType, " & %.4g & %.4g & %.4g & %.4g & %.4g \\\\ \n\\hline \n");
    fprintf(metricString, indices(1, stt), indices(2, stt), indices(3, stt), indices(4, stt), polyder(polyder(p_xA{stt})));
end
disp("\end{tabular}")
disp(append("\caption{Metrics, center distance and radius histogram curvature, for imitation inputs designed with ", modelType, " model and using ", feedbackType, " feedback}"))
disp(append("\label{tab:", modelType, "_", feedbackType, "}"))
disp("\end{table}")

sgtitle("Error between measured and desired state value")

fig12 = figure(12);

img1 = imread(append('images/', testName, '_timeplot.png'));
img2 = imread(append('images/', testName, '_phaseplot.png'));

% for n = 1:2
%     img2 = insertText(img2,[400, 100+n*30], "legend");
% end

if strcmp(cycle, "3d") == 1
    legend3d = imread("images/3dLegend.jpg");
    alph = 0.85;
    sza = size(legend3d);
    B = img2;
    aaa = repmat(im2uint8(legend3d),[1 1 1]); % need to cast, rescale, expand
    fLoc = size(B) - [290, 5, 0];
    Broi = B(fLoc(1)-sza(1)+1:fLoc(1),fLoc(2)-sza(2)+1:fLoc(2),:);
    B(fLoc(1)-sza(1)+1:fLoc(1),fLoc(2)-sza(2)+1:fLoc(2),:) = aaa*alph + Broi*(1-alph); % insert into ROI
    img2 = B;
end

imshow([img1; img2])


saveas(fig12, append('images/keep/', testName, '_timeAndPhase.png'))

fig13 = figure(13);

img1 = imread(append('images/', testName, '_fourier.png'));
img2 = imread(append('images/', testName, '_radhist.png'));

imshow([img1; img2])

saveas(fig13, append('images/keep/', testName, '_fourierAndCyclic.png'))

disp(" ")

disp("\begin{figure}")
disp("\centering")
disp(append("\includegraphics[width=0.8\linewidth]{", "Bilder/", testName, "_timeAndPhase.png}"))
disp(append("\caption{(A-B) Time signal over ", num2str(endTime), " seconds for states of selected x_r. (C) phase plot over ", num2str(startTime),"-", num2str(interrupt), " seconds, for imitation inputs designed with ", modelType, " model and using ", feedbackType," feedback. (D) Same, but where x_r is centered around the origin}"))
disp(append("\label{fig:", strrep(testName, " ", "_"), "_timeAndPhase}"))
disp("\end{figure}")

disp(" ")

disp("\begin{figure}")
disp("\centering")
disp(append("\includegraphics[width=0.8\linewidth]{", "Bilder/", testName, "_fourierAndCyclic.png}"))
disp(append("\caption{(A-B) Fourier analysis for states of selected x_r over ", num2str(startTime),"-", num2str(interrupt), " seconds, for imitation inputs designed with ", modelType, " model and using ", feedbackType," feedback. (C-D) Same, but for cyclic analysis rather than fourier analysis}"))
disp(append("\label{fig:", strrep(testName, " ", "_"), "_fourierAndCyclic}"))
disp("\end{figure}")