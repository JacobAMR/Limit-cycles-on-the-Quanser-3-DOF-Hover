function cyclePoint = approxLimit_error(realValues, cycleValues)
    tReal = transpose(realValues);
    ix = dsearchn(cycleValues, tReal);
    cyclePoint = transpose(cycleValues(ix, :));
end