md = 2;

simuName = 'vandertest2';
plotName = 'normalTest';
stopTime = 200;
fontSize = 14;
set(0, 'DefaultLineLineWidth', 2)

if md == 1
    load('feedbackresults.mat', 'X')
    yawvalues = X(:, 1:2);
    pitchvalues = X(:, 3:4);
    rollvalues = X(:, 5:6);
elseif md == 2
    sim('vandertest2', stopTime)
    X = [yawvalues, pitchvalues, rollvalues];
    save(append('arrays/', simuName, '.mat'), 'X');
end

yYaw = yawvalues(:, 1);
xYaw = yawvalues(:, 2);
yPitch = pitchvalues(:, 1);
xPitch = pitchvalues(:, 2);
yRoll = rollvalues(:, 1);
xRoll = rollvalues(:, 2);


vLength = length(xYaw);
vStart = 1000;

fig1 = figure(1)
tiledlayout(2,2, 'Padding', 'none', 'TileSpacing', 'compact');

nexttile
plot(xYaw, yYaw, 'LineStyle', ':')
title('Yaw')
xlabel('Angle')
ylabel('Velocity')
yRange = max(yYaw(vStart:vLength)) - min(yYaw(vStart:vLength));
ylim([min(yYaw(vStart:vLength)) - yRange*0.1, max(yYaw(vStart:vLength)) + yRange*0.1])

nexttile
plot(xPitch, yPitch, 'LineStyle', ':')
title('Pitch')
xlabel('Angle')
ylabel('Velocity')
pRange = max(yPitch(vStart:vLength)) - min(yPitch(vStart:vLength));
ylim([min(yPitch(vStart:vLength)) - pRange*0.1, max(yPitch(vStart:vLength)) + pRange*0.1])

nexttile
plot(xRoll, yRoll, 'LineStyle', ':')
title('Roll')
xlabel('Angle')
ylabel('Velocity')
rRange = max(yRoll(vStart:vLength)) - min(yRoll(vStart:vLength));
ylim([min(yRoll(vStart:vLength)) - rRange*0.1, max(yRoll(vStart:vLength)) + rRange*0.1])
fontsize(fig1, fontSize, "points")
saveas(fig1, append('images/', plotName, '_angle-speed_', simuName, '.png'))

fig2 = figure(2)
plot3(xYaw, xPitch, xRoll, 'LineStyle', ':')
title('Angles 3D')
xlabel('Yaw')
ylabel('Pitch')
zlabel('Roll')
fontsize(fig2, fontSize, "points")
saveas(fig2, append('images/', plotName, '_3d_angles_', simuName, '.png'))

fig3 = figure(3)
plot(xPitch, xRoll, 'LineStyle', ':')
title('Angles')
xlabel('Pitch')
ylabel('Roll')
fontsize(fig3, fontSize, "points")
saveas(fig3, append('images/', plotName, '_pitch-roll_', simuName, '.png'))

fig4 = figure(4)
plot(xYaw, xPitch, 'LineStyle', ':')
xlabel('Yaw')
ylabel('Pitch')
legend('x0', 'x1', 'x2')
fontsize(fig4, fontSize, "points")
saveas(fig4, append('images/', plotName, '_yaw-pitch_', simuName, '.png'))

fig5 = figure(5)
plot(xYaw, xRoll, 'LineStyle', ':')
title('Angles')
xlabel('Yaw')
ylabel('Roll')
fontsize(fig5, fontSize, "points")
saveas(fig5, append('images/', plotName, '_yaw-roll_', simuName, '.png'))

fig6 = figure(6)
plot(yPitch, yRoll, 'LineStyle', ':')
title('Velocities')
xlabel('Pitch')
ylabel('Roll')

xlim([min(yPitch(vStart:vLength)) - pRange*0.1, max(yPitch(vStart:vLength)) + pRange*0.1])
ylim([min(yRoll(vStart:vLength)) - rRange*0.1, max(yRoll(vStart:vLength)) + rRange*0.1])

fontsize(fig6, fontSize, "points")
saveas(fig6, append('images/', plotName, '_velocity_roll-yaw_', simuName, '.png'))