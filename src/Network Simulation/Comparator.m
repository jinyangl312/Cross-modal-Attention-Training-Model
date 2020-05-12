function [upwardPreference] = ...
    Comparator(motionStrength, downwardFiringRate, upwardFiringRate, weight)
% Make a probabilistic judgement about the motion direction.
    
    length = size(motionStrength, 2);
    upwardPreference = zeros(1, length);
    
    for i=1:1:length
        deltaDown = downwardFiringRate(1, i);
        deltaUp = upwardFiringRate(1, i);
        x = (deltaUp - deltaDown) / (deltaUp + deltaDown);
        % Use a sigmoid function to be the comparator.
        upwardPreference(1, i) = 1 / (1 + exp(-weight * x)) + 0;
    end
end