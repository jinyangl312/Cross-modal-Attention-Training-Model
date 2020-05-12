function [downwardRate, upwardRate, records] = ...
    NetworkSimulation_Run(stimList, constList, paramList, mode)
% Take parameters and do simulation until the firing rates converge.

    %******************* Initialization **********
    records = zeros(7,1);
    records(1:6, 1) = constList(1, 2);

    [downwardRate, upwardRate, records] = ...
        NetworkSimulation_UnitRun(stimList, constList, paramList, 500, records, 1, mode);
    length = size(records, 2);
    count = 1;
    % continue simulation until the errors within 500 rounds is less than 0.1%
    % or after maximum turns
    while (IsConverge(records, length))
        if (count > 600)
            warning(['The model has not converge in ', 6000, ' ms! Simulation break here.'])
            break;
        end
        [downwardRate, upwardRate, records] = ...
            NetworkSimulation_UnitRun(stimList, constList, paramList, 100, records, 0.1, mode);
        length = size(records, 2);
        count = count + 1;
    end    
end

function [status] = IsConverge(records, length)
    status = false;
    for lineNum = 1:1:6
        if records(lineNum, length) > records(lineNum, length-500) * 1.001 || ...
            records(lineNum, length) < records(lineNum, length-500) * 0.999
            status = true;
            break;
        end
    end
end