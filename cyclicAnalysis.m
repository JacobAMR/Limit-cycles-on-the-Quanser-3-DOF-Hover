function [N, poly, func, xRange] = cyclicAnalysis(x, pdfSample, xPeaks)
        maxRange = max(x);
        xRange = 0:(maxRange/pdfSample):(maxRange); %# Range of integers to compute a probability for
        N = hist(x, xRange); %# Bin the data
        N = N./numel(x);

        [pks, locs] = findpeaks(N, NPeaks=xPeaks, SortStr="descend");
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
end