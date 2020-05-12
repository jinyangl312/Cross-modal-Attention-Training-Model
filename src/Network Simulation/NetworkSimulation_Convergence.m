function [] = NetworkSimulation_Convergence(mode, strength, stimGradient, turns, threshold)
% Test the difference between two simulation with the same input. Throw a
% warning if the difference is larger than the threshold.

    results = zeros(2, turns);

    constList = [300, 30, 0.6]; % [maxFiringRate, baseline, decayRate]
    paramList = [0.5, 0.5, 0.2, 0.125, 0.125, 0.25, 35.75, 74.86]; %[W_A, W_V, W_AM, W_MA, W_VM, W_MV, sigmaA, sigmaV]

    if mode == 'A'       
        if strength >= 0
            % stimList = [V_Din, V_Uin, A_Din, A_Uin]
            stimRep = repmat([0, strength], size(stimGradient, 1), 1);
            stimListList = [stimGradient, stimRep];
        else            
            stimRep = repmat([-strength, 0], size(stimGradient, 1), 1);
            stimListList = [stimGradient, stimRep];
        end
    else
        if strength >= 0
            % stimList = [V_Din, V_Uin, A_Din, A_Uin]
            stimRep = repmat([0, strength], size(stimGradient, 1), 1);
            stimListList = [stimRep, stimGradient];
        else
            stimRep = repmat([-strength, 0], size(stimGradient, 1), 1);
            stimListList = [stimRep, stimGradient];
        end
    end

    for j=1:1:size(stimListList, 1)
        stimList = stimListList(j, :);
        for i=1:1:turns
            [results(1, i), results(2, i), ~] = ...
                        NetworkSimulation_Run(stimList, constList, paramList, mode);
        end
        
        for i=2:1:turns
            if abs(results(1, i) - results(1,1)) > threshold
                warning('The error is larger than the threshold now');
            end
            if abs(results(2, i) - results(2,1)) > threshold
                warning('The error is larger than the threshold now');
            end
        end
    end

end