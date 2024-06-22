[xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL] = temp_physical(md, 1, stopTime, sampleTime, loadName, x0M, simuName, 1, linear, pitchvalues, rollvalues, yawvalues, voltages);
% Remember that I set initials = 1 an space = 1
plot_physical(xYaw, yYaw, xPitch, yPitch, xRoll, yRoll, voltF, voltB, voltR, voltL, lStart, 1, tStart, (stopTime - startTime), fontSize, savePlot, plotName, simuName);

%if 1 == 0
for n = 1:initials
disp(append("Initial condition ",num2str(n), " (in degrees):"))
    disp(append(num2str(xRoll(1, n)), ", ", num2str(xPitch(1, n)), ", ",  num2str(xYaw(1, n)), ...
        ", ",  num2str(yRoll(1, n)), ", ",  num2str(yPitch(1, n)), ", ",  num2str(yYaw(1, n))))
end
%end