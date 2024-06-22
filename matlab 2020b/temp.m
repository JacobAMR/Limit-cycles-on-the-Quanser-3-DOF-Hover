period = 6.6;
shift = 0.25;
tr = 0.5;

u1 = 1.2;
u2 = 0.4;
%u = 0;
%u2 = 0;

%%% For physical
space = 1;
sampleTime = 0.005;
xPitch = pitchvalues(:, 2);
xRoll = rollvalues(:, 2);
savePlot = 1;
plotName = "detection4";
simuName = "advanced_cycletest9";

startTime = 100;
endTime = length(xRoll)*sampleTime;
endIndex = endTime*space/sampleTime;
startIndex = startTime*space/(sampleTime*space);

%sim("glycosis_sim", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));
%sim("brusselator_sim", 'StartTime', '0', 'StopTime', num2str(stopTime), 'FixedStep', num2str(sampleTime));

start = 10/sampleTime;

x = xPitch;
x2 = xRoll;

%x = brusselx;
%x2 = glycosisx;

tStart = round(startTime/(space*sampleTime)) + 1;
tEnd = round(endTime/(space*sampleTime)) + 1;
tTime = (endTime - startTime);
vLength = length(x);
%timeVector = transpose((tStart*(tTime/vLength)):(tTime/vLength):endTime);
timeVector = transpose(start*sampleTime:(sampleTime):(vLength*sampleTime));

x = round(x(start:end), 4);
%x = x - 1.2;
x = x - mean(x);
mean(x)
%y = round(brussely(start:end), 4);
x2 = round(x2(start:end), 4);
%x2 = x2 - 0.4;
x2 = x2 - mean(x2);
%x2 = round(brussely((start/sampleTime):end), 4);

% x = round(xPitch((start/sampleTime):end), 4);
% x = x - mean(xPitch);
% x2 = round(xRoll((start/sampleTime+1):end), 4);
% x2 = x2 - mean(xRoll);

fig1 = figure(1)

p = normpdf(x, u1);
p2 = normpdf(x2, u2);

endIndex = endTime/sampleTime - start + 1;
subplot(2,1,1)
plot(timeVector, x(1:endIndex))
title("Brusselator")
subplot(2, 1, 2)
plot(timeVector, x2(1:endIndex))
title("Glycosis")

if savePlot == 1
    saveas(fig1, append('images/', plotName, '_pitch-roll_', simuName, '.png'))
end

%%%
figure(2)
subplot(2, 1, 1)
plot(timeVector, p(1:endIndex))
title("Brusselator, PDF u = 0")
subplot(2, 1, 2)
plot(timeVector, p2(1:endIndex))
title("Glycosis, PDF u = 0")

%%%
figure(3)
subplot(2, 1, 1)
histogram(x);
title("Histogram for brusselator")
subplot(2, 1, 2)
histogram(x2)
title("Histogram for glycosis")
%suptitle("PDF from u = 0")

%%% Yeah, I clearly need to do this in radial coordinates.

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

disp(corrSum)
disp(corrDelayGlycosis)
disp(finalCorr)

x_shift = circshift(x, int32(corrDelayBrussel/sampleTime));
%x_shift = circshift(x, int32(3/sampleTime));
%x_shift = circshift(y, int32(corrDelayBrussel/sampleTime));
x2_shift = circshift(x2, int32(corrDelayGlycosis/sampleTime));

fig4 = figure(4);

subplot(2, 1, 1)
plot(timeVector, x(1:endIndex))
title("x1")
subplot(2, 1, 2)
plot(timeVector, x_shift(1:endIndex))
title(append("x1 shifted by ", num2str(corrDelayBrussel)))

if savePlot == 1
    saveas(fig4, append('images/', plotName, '_pitch-delay_', simuName, '.png'))
end

fig5 = figure(5);
subplot(2, 1, 1)
plot(timeVector, x2(1:endIndex))
title("Glycosis")
subplot(2, 1, 2)
plot(timeVector, x2_shift(1:endIndex))
title(append("Glycosis shifted by ", num2str(corrDelayGlycosis)))

if savePlot == 1
    saveas(fig5, append('images/', plotName, '_roll-delay_', simuName, '.png'))
end

figure(6)
[theta, rho] = cart2pol(x, x_shift);
[theta2, rho2] = cart2pol(x2, x2_shift);

subplot(2, 1, 1)
plot(timeVector, rho(1:endIndex))
title("Rho for brusselator")
subplot(2, 1, 2)
plot(timeVector, rho2(1:endIndex))
title("Rho for glycosis")


%%%
figure(7)
subplot(2, 1, 1)
%h = histogram(rho,  'BinLimits',[1.7,3.5]);
h = histogram(rho);
title("Histogram of rho for brusselator")

space = 200;

% tempMax = max(h);
% disp(tempMax)
% thresh = tempMax*tr;
% for nn = 1:(length(h)/space)
%     tempMax = max(h((nn*space):end));
%     %if rem(nn, 10) == 0
%     %    disp(tempMax)
%     %end
%     if tempMax < thresh
%         end_value = h.binValues(nn);
%         disp(end_value)
%         break
%     end
% end

%h.BinLimits = [0, end_value];

subplot(2, 1, 2)
h = histogram(rho2);
title("Histogram for rho of glycosis")
%h.BinLimits = [2.3,2.6];

figure(8)
p = normpdf(rho, u1);
p2 = normpdf(rho2, u2);
subplot(2, 1, 1)
plot(p)
title(append("Brusselator pdf of rho at u = ", num2str(u1)))
subplot(2, 1, 2)
plot(p2)
title(append("Glycosis pdf of rho at u = ", num2str(u2)))

%%%
figure(9)
subplot(2, 1, 1)
h = histogram(p);
title("Brusselator histogram of rho pdf")
%max(h)
%h.BinLimits = [0,0.3];
%h.BinLimits = [0.001,0.15])

subplot(2, 1, 2)
h = histogram(p2);
title("Glycosis histogram of rho pdf")
%histogram(p2)
%h.BinLimits = [0.33,0.34])
%h.BinLimits = [0,0.04];

fig10 = figure(10);
subplot(2, 1, 1)
plot(x, x_shift)
xlabel("x1")
ylabel("x1, time-shifted")
title("Phase plot between x1 and its time shift")
subplot(2, 1, 2)
plot(x2, x2_shift)
xlabel("x2")
ylabel("x2, time-shifted")
title("Phase plot between x2 and its time shift")


if savePlot == 1
    saveas(fig10, append('images/', plotName, '_phaseplots_', simuName, '.png'))
end

%%%

fig11 = figure(11);
pdfSample = 100;
maxRange = max(rho);
xRange = 0:(maxRange/pdfSample):maxRange; %# Range of integers to compute a probability for
N = hist(rho, xRange); %# Bin the data
N = N./numel(x);
subplot(2, 1, 1)
%plot(xRange,N./numel(data)); %# Plot the probabilities for each integer
[M, I] = max(N(1:(pdfSample - 1)));
func = xRange*(M - N(1))/xRange(I);

postPeakRange = int32(I*1.2)
if postPeakRange > (pdfSample - 1)
    postPeakRange = (pdfSample - 1);
end
xRange = xRange(1:postPeakRange);
N = N(1:postPeakRange);
func = func(1:postPeakRange);
p_x = polyfit(xRange(1:I), N(1:I), 2);
poly = p_x(1)*xRange.^2 + p_x(2)*xRange + p_x(3);
disp(append("Brusselator second derivative is ", num2str(polyder(polyder(p_x)))))

plot(xRange, N, xRange, func, xRange, poly)
title('Brusselator')

maxRange = max(rho2);
xRange2 = 0:(maxRange/pdfSample):maxRange; %# Range of integers to compute a probability for
N2 = hist(rho2, xRange2); %# Bin the data
N2 = N2./numel(x2);
subplot(2, 1, 2)
%plot(xRange,N./numel(data)); %# Plot the probabilities for each integer
[M, I2] = max(N2(1:(pdfSample - 1)));
func2 = xRange2*(M - N2(1))/xRange2(I2);

postPeakRange = int32(I2*1.2)
if postPeakRange > (pdfSample - 1)
    postPeakRange = (pdfSample - 1);
end

xRange2 = xRange2(1:postPeakRange);
N2 = N2(1:postPeakRange);
func2 = func2(1:postPeakRange);
p_x = polyfit(xRange2(1:I2), N2(1:I2), 2);
poly = p_x(1)*xRange2.^2 + p_x(2)*xRange2 + p_x(3);
disp(append("Glycosis second derivative is ", num2str(polyder(polyder(p_x)))))

plot(xRange2, N2, xRange2, func2, xRange2, poly)
%plot(xRange, N)
title('Glycosis')
xlabel('Radius');
ylabel('Density');

pdf1 = hist(rho, 0:(0.5/100):0.5);
pdf2 = hist(rho2, 0:(0.01/100):0.01);

ddiff1 = diff(diff(pdf1));
ddiff2 = diff(diff(pdf2));

if savePlot == 1
    saveas(fig11, append('images/', plotName, '_histogram_', simuName, '.png'))
end

%%%

figure(12)
subplot(2, 1, 1)
cdfplot(rho)
subplot(2, 1, 2)
cdfplot(rho2)

%figure(13)
%subplot(2, 1, 1)
%p_x = polyfit(xRange(1:I), N(1:I), 2)
%plot(xRange, p_x(1)*xRange.^2 + p_x(2)*xRange + p_x(3))
%plot(xRange, N - func)
%subplot(2, 1, 2)
%p_x = polyfit(xRange2(1:I), N2(1:I), 2)
%plot(xRange2, p_x(1)*xRange2.^2 + p_x(2)*xRange2 + p_x(3))
%plot(xRange2, N2 - func2)