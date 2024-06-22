

endTime = 200;
sampleTime = 0.001;

timeVector = 0:sampleTime:endTime;

figure(1)
tiledlayout(4, 3, 'Padding', 'none', 'TileSpacing', 'loose');
nexttile
plot(timeVector, yawLinear(:, 2))
nexttile
plot(timeVector, pitchLinear(:, 2))
nexttile
plot(timeVector, rollLinear(:, 2))

nexttile
plot(timeVector, yawNonlinear(:, 2))
nexttile
plot(timeVector, pitchNonlinear(:, 2))
nexttile
plot(timeVector, rollNonlinear(:, 2))

nexttile
plot(timeVector, yawAdvanced(:, 2))
nexttile
plot(timeVector, pitchAdvanced(:, 2))
nexttile
plot(timeVector, rollAdvanced(:, 2))
