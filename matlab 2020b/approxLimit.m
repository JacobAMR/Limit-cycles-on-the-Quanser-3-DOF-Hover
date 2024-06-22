function cyclePoint = approxLimit(realValues)
    %disp(realValues)
%     coder.extrinsic('evalin');
%     coder.extrinsic('dsearchn');
%     cycleValues = zeros(2001, 2, 'double');
%     cyclePoint = zeros(2, 1, 'double');
    
    cycleValues = evalin('base', 'cycleTrajectory');
    tReal = transpose(realValues);
    ix = dsearchn(cycleValues, tReal);
    cyclePoint = transpose(cycleValues(ix, :));

end