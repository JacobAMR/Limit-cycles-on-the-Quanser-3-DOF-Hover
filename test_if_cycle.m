md = 2;
if md == 0
    load('feedbackresults.mat', 'X')
    yawvalues = X(:, 1:2);
    pitchvalues = X(:, 3:4);
    rollvalues = X(:, 5:6);
    disp("e")
elseif md == 1
    sim('vandertest2')
end

tstart = 20000;

x = pitchvalues(:, 2);
y = pitchvalues(:, 1);
z = yawvalues(:, 2);

tEnd = length(x);
x1 = x(tEnd);
x2 = y(tEnd);
closestDiff = [1000, 1000];
badCheck = 0;

for n = 1:(tEnd - tstart)
    currentPos1 = x(tEnd-n);
    currentPos2 = y(tEnd-n);
    currentDiff = [abs(x1 - currentPos1), abs(x2 - currentPos2)];
    if abs(currentDiff) < abs(closestDiff)
        closestDiff = currentDiff;
        closestPos = [currentPos1, currentPos2];
        closestNo = n;
    end
    if [currentPos1, currentPos2] == [x1, x2]
        disp("It's a closed orbit")
    end
    %if badCheck == 0
    %    if
    %end
end

disp("Starting point:")
disp([x1, x2])
disp("Closest point:") 
disp(closestPos)
disp("Closest point array location (n, nRem): ") 
disp(closestNo)
disp(tEnd - closestNo)
disp("Closest point difference: ") 
disp(closestDiff)
disp(" ")

%if x1 == x1_measured:
    %disp("It's a closed orbit")
%    disp("Yep, that's a limit cycle")
%Kanskje litt vanskelig å gjøre uten simulink.

%Prøv å test programmet via feedback systemet, cycletest, og et system du
%vet ikke er en limit cycle