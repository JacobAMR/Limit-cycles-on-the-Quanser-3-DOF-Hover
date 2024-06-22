%%%%%% REQUIRES RUNNING SIMULATE_HOVER FIRST

close all

%fontSize = 12;
set(0,'DefaultTextFontSize', 12);
set(0, 'DefaultLineLineWidth', 1.2);

%figure('Renderer', 'painters', 'Position', [10 10 900 600])

modelTypes = ["Brusselator", "Glycolysis"];
simNames = ["brusselator_sim", "glycosis_sim"];
feedbackType = "normal";
cycle = "vander";

sampleTime = 0.001;

rhoPeaks = 1;
centerOrigin = 0;

startTime = 150;
endTime = 200;
interrupt = 2000;
startIndex = startTime/(sampleTime);

%sim("glycosis_sim", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));
%sim("brusselator_sim", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));

start = startTime/sampleTime;

stateNames = ["x_1", "x_2"];

stateType = "";
unitType = "";

A = 1;
o = 0.05;
%o = 0;
B = 2.15;

a = 0.1;
o_glycosis = 0.01;
%o = 0;
b = 0.4;

syms delta
d = double(solve(B == 2*delta + 1 + A^2, delta));

for mdl = 1:length(modelTypes)
    modelType = modelTypes(mdl);

    out = sim(simNames(mdl), 'StartTime', '0', 'StopTime', num2str(interrupt), 'FixedStep', num2str(sampleTime));
    xPitch = out.xPitch;
    xRoll = out.xRoll;
    
    testName = append(modelType, "_test");
    statesNo = length(stateNames);
    
    %xMtemp = [xYaw(:, 1), xPitch(:, 1), xRoll(:, 1)];
    xMtemp = zeros(length(xPitch), statesNo);
    
    xMtemp(:, 1) = xPitch;
    xMtemp(:, 2) = xRoll;
    
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
    
    
    tStart = startTime + sampleTime;
    tEnd = round(endTime/(sampleTime)) + 1;
    tTime = vLength*sampleTime;
    %timeVector = transpose((tStart*(tTime/vLength)):(tTime/vLength):endTime);
    timeVector = transpose(start*sampleTime:(sampleTime):(endTime));
    
    fig1 = figure(1);
    fig1.Position = [100 100 250 240];
    
    endIndex = endTime/sampleTime - start + 1;
    
    plot(xM(:, 1), xM(:, 2))
    %ylim([-40.01, 40.01])
    title(append("Phase plot"))
    xlabel("x_1")
    ylabel("x_2")
    %title("Phase plot for reference limit cycle")

    AddLetters2Plots(fig1, {'C'}, 'HShift', 0, 'VShift', 0, 'Direction', 'TopDown')
    
    saveas(fig1, append('images/', testName, '_phaseplot.png'))
    
    %%%
    fig2 = figure(2);
    fig2.Position = [100 100 250 240];
    
    tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');
    for stt = 1:statesNo
        nexttile
        x = xMtemp(1:endTime/sampleTime, stt);
        plot(sampleTime:sampleTime:endTime, x, 'LineStyle', '-')
        title(append("Time signal for ", stateNames(stt)))
        %xticks([])
        yRange = max(x) - min(x);
        ylim([min(x)-yRange*0.1, max(x)+yRange*0.1])
        ylabel(append(stateType(1), " ", unitType(1)))
        xlabel('Time (s)')
    end
    
    sgtitle(append(modelType))
    
    AddLetters2Plots(fig2, {'A', 'B'}, 'HShift', 0, 'VShift', 0, 'Direction', 'TopDown')
    saveas(fig2, append('images/', testName, '_timeplot.png'))
    
    %%%
    % fig3 = figure(3);
    % tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');
    % for stt = 1:statesNo
    %     nexttile
    %     histogram(xM(:, stt));
    %     title(append("Histogram for ", stateNames(stt), " ", stateType, " ", unitType))
    %     xlabel("Angle (degrees)")
    % end
    
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
    
    % fig4 = figure(4);
    % 
    % tiledlayout(statesNo, 2, 'Padding', 'none', 'TileSpacing', 'loose');
    % for stt = 1:statesNo
    %     nexttile
    %     plot(timeVector, xMd(1:endIndex, stt))
    %     title(append(stateNames(stt), " ", stateType(1), " distance (from ", num2str(round(xMean(stt), 2)), ")"))
    %     ylabel(append(stateType(1), " ", unitType(1)))
    %     xlabel("Time (s)")
    %     nexttile
    %     plot(timeVector, x_shiftM(1:endIndex, stt))
    %     title(append(stateNames(stt), " ", stateType(1), " distance shifted by ", num2str(corrDelay(stt))))
    % end
    % fig5 = figure(5);
    % 
    % tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');
    rho = zeros(vLength, statesNo);
    
    for stt = 1:statesNo
        [thetaTemp, rhoTemp] = cart2pol(xMd(:, stt), x_shiftM(:, stt));
        rho(:, stt) = rhoTemp;
        
        % nexttile
        % plot(timeVector, rhoTemp(1:endIndex))
        % title(append("Rho for ", stateNames(stt), " ", stateType(1)))
        % ylabel(append(stateType(1), " ", unitType(1)))
        % xlabel("time (s)")
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
    
    fig7 = figure(6+mdl);
    fig7.Position = [100 100 540 250];
    
    tiledlayout(1, statesNo, 'Padding', 'none', 'TileSpacing', 'loose');
    
    for stt = 1:statesNo
     
        N = end_index + round(vLength*0.001);
        fs = N/(500);
        %fs = N/(vLength*sampleTime*1.001);
        %fs = sampleTime;
        
        f = fs*(0:N/2-1)/N;
        
        nexttile
        fourier = fft(xM(:, stt));
        fourier_half = fourier(2:N/2);
        Fr = abs(fourier_half)/(N/2);
        f = f(2:end);
        %Fr = smooth(Fr, 40);
        
        plot(f, Fr, 'LineStyle', '-')
        
        title(append(stateNames(stt), ' Fourier'))
        ylabel('Transform')
        xlabel('Frequencies (Hz)')
        
        pdfSample = 100000;
        %%%%%%%%%%%%%%%%%%%%%%%
        

        N = Fr;
        xRange = f;
        %[N, poly, func, xRange] = cyclicAnalysis(Fr, pdfSample, rhoPeaks);
        [pks, locs] = findpeaks(N, NPeaks=rhoPeaks, SortStr="descend");
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
        
        %nexttile

        %histogram(Fr, pdfSample)
        %plot(xRange, N, xRange, func, xRange, poly)
    
        %disp(append("Curvature: ", num2str(polyder(polyder(p_x)))));
    end
    
    
    sgtitle(append(modelType, " system"))
    if mdl == 1
        AddLetters2Plots(fig7, {'C', 'D'}, 'HShift', 0, 'VShift', 0, 'Direction', 'LeftRight')
    else
        AddLetters2Plots(fig7, {'A', 'B'}, 'HShift', 0, 'VShift', 0, 'Direction', 'LeftRight')
    end

    saveas(fig7, append('images/', testName, '_fourier.png'))
    
    % fig8 = figure(8);
    % 
    % tiledlayout(statesNo, 1, 'Padding', 'none', 'TileSpacing', 'loose');
    % 
    % for stt = 1:statesNo
    %     nexttile
    %     plot(xM(:, stt), x_shiftM(:, stt))
    %     xlabel(stateNames(stt))
    %     ylabel(append(stateNames(stt), " ", stateType, ' delayed by ', num2str(round(center(stt), 2))))
    %     title(append(stateNames(stt), " ", stateType, ' and time delayed ', stateNames(stt), " ", stateType))
    % end
    % 
    % sgtitle(append('Phase plot between state distance and time delayed state distance'))
    %%%
    
    fig9 = figure(9);
    fig9.Position = [100 100 540 250];
    
    tiledlayout(1, statesNo, 'Padding', 'none', 'TileSpacing', 'loose');
    pdfSample = 1000;
    
    p_xA{stt} = cell(1, statesNo);
    histTitle = append(modelType, " histogram of radius near center (");
    
    for stt = 1:statesNo
        x = rho(:, stt);
        maxRange = max(x);
        xRange = 0:(maxRange/pdfSample):(maxRange); %# Range of integers to compute a probability for
        N = hist(x, xRange); %# Bin the data
        N = N./numel(x);

        [pks, locs] = findpeaks(N, NPeaks=rhoPeaks, SortStr="descend");
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
        hL = legend("Measured values", "Straight line", "Fitted polynomial");
        set(hL.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.7]));

        ylim([0, inf])
    
        disp(append("Curvature: ", num2str(polyder(polyder(p_x)))));
        if stt == statesNo
            histTitle = append(histTitle, num2str(round(center(stt), 2)), ")^T");
        else
            histTitle = append(histTitle, num2str(round(center(stt), 2)), ", ");
        end
    end
    
    sgtitle(histTitle)
    sgtitle(append(modelType, " system"))
    if mdl == 1
        AddLetters2Plots(fig9, {'C', 'D'}, 'HShift', 0, 'VShift', 0, 'Direction', 'LeftRight')
    else
        AddLetters2Plots(fig9, {'A', 'B'}, 'HShift', 0, 'VShift', 0, 'Direction', 'LeftRight')
    end
    saveas(fig9, append('images/', testName, '_radhist.png'))
    
    fig12 = figure(9+mdl);
    
    img1 = imread(append('images/', testName, '_timeplot.png'));
    img2 = imread(append('images/', testName, '_phaseplot.png'));
    
    % for n = 1:2
    %     img2 = insertText(img2,[400, 100+n*30], "legend");
    % end
    imshow([img1, img2])
    
    saveas(fig12, append('images/keep/', testName, '_timeAndPhase.png'))
end

fig12 = figure(12);

testName = append(modelType, "_test");

img1 = imread(append('images/glycolysis_test_fourier.png'));
img2 = imread(append('images/brusselator_test_fourier.png'));

imshow([img1; img2])

saveas(fig12, append('images/keep/demonstrate_fourier.png'))

fig13 = figure(13);

img1 = imread(append('images/glycolysis_test_radhist.png'));
img2 = imread(append('images/brusselator_test_radhist.png'));

imshow([img1; img2])

saveas(fig13, append('images/keep/demonstrate_radhist.png'))