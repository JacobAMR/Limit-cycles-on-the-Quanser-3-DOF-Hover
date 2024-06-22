close all

skipSims = 0;
%no = 3;
%simuNames = ["cycletest6" "nonlinCycletest1" "advanced_cycletest9"];
%simuNames = ["cycletest_feedback" "nonlin_feedback" "advanced_feedback"];
simuNames = ["advanced_modelError"];
%modelType = ["linear" "nonlinear" "detailed"];
modelType = ["nonlinear"];


startTime = 100;
endTime = 600;
timeSpan = 100;

endIndex = endTime*space/sampleTime;
startIndex = startTime*space/(sampleTime*space);
start = startTime/sampleTime;

histAdjustPitch = [1, 1];
histAdjustRoll = [1, 1];

if skipSims == 0
    load lookup_nopos_physical2.mat
    simuNo = length(simuNames);
    for no = 1:simuNo
        simuName = simuNames(no);
        simulate_hover;
        vLength = length(xPitch);
        if exist('modelPitch', 'var') ~= 1
            modelPitch = zeros(vLength, simuNo);
            modelRoll = zeros(vLength, simuNo);
            modelFrRoll = zeros(vLength, simuNo);
            modelFrPitch = zeros(vLength, simuNo);
            modelf = zeros(vLength, simuNo);
        end
        modelPitch(:, no) = xPitch;
        modelRoll(:, no) = xRoll;
    
        Mlength = length(modelFrRoll);
        exLength = length(FrRoll);
        if Mlength > exLength
            modelFrRoll = modelFrRoll(1:exLength, :);
            modelFrPitch = modelFrPitch(1:exLength, :);
            modelf = modelf(1:exLength, :);
        elseif Mlength < exLength
            FrRoll = FrRoll(1:Mlength);
            FrPitch = FrPitch(1:Mlength);
            FrRoll = FrRoll(1:Mlength);
            fPitch = fPitch(1:Mlength);
        end
        modelFrRoll(:, no) = FrRoll;
        modelFrPitch(:, no) = FrPitch;
        modelf(:, no) = fPitch;
    end
end

close all

fig1 = figure(1);
t0 = tiledlayout(simuNo,2,'TileSpacing','Compact','Padding','Compact');

timeVectorMerge = (endTime - timeSpan):sampleTime:(endTime);
for n= 1:simuNo
    nexttile
    plot(timeVectorMerge, modelPitch(((endTime-timeSpan)/sampleTime):(endTime/sampleTime), n))
    title(append('Pitch (', modelType(n), " model)"))
    if n ~= simuNo
        xticks([])
    end
    nexttile
    plot(timeVectorMerge, modelRoll(((endTime-timeSpan)/sampleTime):(endTime/sampleTime), n))
    title(append('Roll (', modelType(n), " model)"))
    if n ~= simuNo
        xticks([])
    end
end


%legend(arrayfun(@(mode) sprintf('Model %d', mode), 1:size(yYaw, 2), 'UniformOutput', false))

fontsize(fig1, fontSize, "points")

saveas(fig1, 'images/timeSeries.png')


fig2 = figure(2);
t1 = tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact');
nexttile
hold on
for n = 1:simuNo
    plot(modelPitch(:, n), modelRoll(:, n), 'LineStyle', ':')
end
title('Angles (degrees)')
xlabel('Pitch')
ylabel('Roll')
%xlim([-100, 100])
%ylim([-100, 100])

nexttile

for n = 1:simuNo
    plot(modelf, modelFrPitch, 'LineStyle', ':')
end
title('Pitch fourier')
%xticks([])
ylabel('Transform')
xlabel('Frequencies')

nexttile

for n = 1:simuNo
    plot(modelf, modelFrRoll, 'LineStyle', ':')
end
title('Roll fourier')
%xticks([])
%ylabel('Transform')
xlabel('Frequencies')

%legend(arrayfun(@(mode) sprintf('Model %d', mode), 1:size(yYaw, 2), 'UniformOutput', false))
if simuNo ~= 1
    legend("Linear model", "Nonlinear model", "Detailed model")
end
%legend(arrayfun(@(mode) sprintf('test %d', mode), 1:size(yYaw, 2), 'UniformOutput', false))

fontsize(fig2, fontSize, "points")

saveas(fig2, 'images/combined.png')

fig3 = figure(3);

tl2 = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');


pdfSample = 1000;
for no = 1:simuNo
    %subplot(2, 3, no)
    nexttile(no)

    x = modelPitch(start:end, no);
    x = x - mean(x);
    x2 = modelRoll(start:end, no);
    x2 = x2 - mean(x2);

    corrDelayBrussel = 0;
    corrSum = 10;
    for n = 0.1:0.1:10
        x_shift_temp = circshift(x, int32(n/sampleTime));
        %disp(corrcoef(x, x_shift_temp))
        tempCorr = corrcoef(x, x_shift_temp);
        tempCsum = sum(abs(tempCorr), "all");
        if corrSum > tempCsum
            corrDelayBrussel = n;
            corrSum = tempCsum;
            finalCorr = tempCorr;
        end
    end
    
    disp(corrSum)
    disp(corrDelayBrussel)
    disp(finalCorr)
    
    corrDelayGlycosis = 0;
    corrSum = 10;
    for n = 0.1:0.1:10
        x_shift_temp = circshift(x, int32(n/sampleTime));
        %disp(corrcoef(x, x_shift_temp))
        tempCorr = corrcoef(x, x_shift_temp);
        tempCsum = sum(abs(tempCorr), "all");
        if corrSum > tempCsum
            corrDelayGlycosis = n;
            corrSum = tempCsum;
            finalCorr = tempCorr;
        end
    end
    
    x_shift = circshift(x, int32(corrDelayBrussel/sampleTime));
    %x_shift = circshift(x, int32(3/sampleTime));
    %x_shift = circshift(y, int32(corrDelayBrussel/sampleTime));
    x2_shift = circshift(x2, int32(corrDelayGlycosis/sampleTime));

    [theta, rho] = cart2pol(x, x_shift);
    [theta2, rho2] = cart2pol(x2, x2_shift);

    maxRange = max(rho)*histAdjustPitch(no);
    xRange = 0:(maxRange/pdfSample):maxRange; %# Range of integers to compute a probability for
    N = hist(rho, xRange); %# Bin the data
    N = N./numel(x);
    %plot(xRange,N./numel(data)); %# Plot the probabilities for each integer
    [M, I] = max(N(1:(pdfSample - 1)));
    func = xRange*(M - N(1))/xRange(I);
    
    postPeakRange = int32(I*1.2);
    if postPeakRange > (pdfSample - 1)
        postPeakRange = (pdfSample - 1);
    end

    %postPeakRange = postPeakRange*histAdjustPitch(no);
    %I = histAdjustPitch(no);

    xRange = xRange(1:postPeakRange);
    N = N(1:postPeakRange);
    func = func(1:postPeakRange);
    p_x = polyfit(xRange(1:I), N(1:I), 2);
    poly = p_x(1)*xRange.^2 + p_x(2)*xRange + p_x(3);
    disp(append("x1 second derivative is ", num2str(polyder(polyder(p_x)))))
    
    plot(xRange, N, xRange, func, xRange, poly)
    title(append('Pitch (', modelType(no), ' model)'))
    if no == 1
        ylabel('Density');
    elseif no == 3
        legend("Histogram", "Straight line", "Polynomial");
    end
    %ylabel('Density');
    
    maxRange = max(rho2)*histAdjustRoll(no);
    xRange2 = 0:(maxRange/pdfSample):maxRange; %# Range of integers to compute a probability for
    N2 = hist(rho2, xRange2); %# Bin the data
    N2 = N2./numel(x2);
    %plot(xRange,N./numel(data)); %# Plot the probabilities for each integer
    [M, I2] = max(N2(1:(pdfSample - 1)));
    func2 = xRange2*(M - N2(1))/xRange2(I2);
    
    postPeakRange = int32(I2*1.2)
    if postPeakRange > (pdfSample - 1)
        postPeakRange = (pdfSample - 1);
    end
    
    %postPeakRange = postPeakRange*histAdjustRoll(no);
    %I2 = histAdjustRoll(no);

    xRange2 = xRange2(1:postPeakRange);
    N2 = N2(1:postPeakRange);
    func2 = func2(1:postPeakRange);
    %func2_poly = polyfit(xRange2(1:I2), N2(1:I2), 1);
    %func2 = func2_poly(1)*xRange2 + func2_poly(2);
    p_x2 = polyfit(xRange2(1:I2), N2(1:I2), 2);
    poly2 = p_x2(1)*xRange2.^2 + p_x2(2)*xRange2 + p_x2(3);
    disp(append("x2 second derivative is ", num2str(polyder(polyder(p_x2)))))
    
    %subplot(2, 3, no+3);
    % pos = get(gca, 'Position');
    % pos(1) = 0.055;
    % pos(3) = 0.9;
    % set(gca, 'Position', pos)

    nexttile(no + 3)
    plot(xRange2, N2, xRange2, func2, xRange2, poly2)
    %plot(xRange, N)
    title(append('Roll (', modelType(no), ' model)'))
    xlabel('Radius')
    if no == 1
        ylabel('Density');
    end
end
%Lgnd = legend("Histogram", "Straight line", "Polynomial");
%Lgnd.Position(1) = 0.76;
%Lgnd.Position(2) = 0.72

sgtitle('Histograms of radii')
%title(fig2,'Histograms of radii') 
fontsize(fig2, 11, "points")

saveas(fig3, 'images/detections.png')