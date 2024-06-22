%function cyclePoint = approxLimit(realValues, cycleValues)
function cyclePoint = approxLimit(realValues)
    %disp(realValues)
    cycleValues = evalin('base', 'cycleTrajectory');
    tReal = transpose(realValues);
    % disp(type(realValues))
    % disp(type(cycleValues))
    ix = dsearchn(cycleValues, tReal);
    %disp(ix)
    cyclePoint = transpose(cycleValues(ix, :));
    % outError = transpose(cycleValues(ix, :)) - realValues;
    % disp(ix)
    % disp(cycleValues(ix, :))
end