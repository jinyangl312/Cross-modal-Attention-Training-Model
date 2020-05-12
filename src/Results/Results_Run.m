function [preference] = Results_Run(mode, strength, stimGradient, motionStrength, attention, integration, sensitivity)
% Get the upward preference under certain level of attention, integration
% and sensitivity.
    
    % Change the sensitivity level into sentitivity strength
    sensitivity = 1 + (sensitivity - 1) / 50;

    constList = [300, 30, 0.6]; % [maxFiringRate, baseline, decayRate]
    paramList = [0.5, 0.5, 0.2, 0.125, 0.125, 0.25, 35.75, 74.86]; % [W_A, W_V, W_AM, W_MA, W_VM, W_MV, sigmaA, sigmaV]

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
    
    stimNum = size(stimListList, 1);
    results = zeros(4, stimNum);
    for i=1:1:stimNum
        stimList = stimListList(i, :);
 
        %*********** Do simulation for each stimList ********
        records = zeros(7,1);
        records(1:6, 1) = constList(1, 2);

        [results(1, i), results(2, i), records] = ...
            Results_UnitRun(stimList, constList, paramList, 500, records, 1, mode, attention, integration);
        length = size(records, 2);
        count = 1;
        % continue simulation until the errors within 500 rounds is less than 0.1%
        % or after maximum turns
        while records(1, length) > records(1, length-500) * 1.001 || ...
                records(1, length) < records(1, length-500) * 0.999
            if (count > 600)
                warning(['The model has not converge in ', 6000, ' ms! Simulation break here.'])
                break;
            end
            [results(1, i), results(2, i), records] = ...
                Results_UnitRun(stimList, constList, paramList, 100, records, 0.1, mode, attention, integration);
            length = size(records, 2);
            count = count + 1;
        end         
    end
    
    preference = Comparator(motionStrength, results(1, :), results(2, :), 10*sensitivity);
end   