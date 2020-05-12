function [] = NetworkSimulation_Simulation(mode, strength, stimGradient, motionStrength)
% Take the list of motion strength and stimuli; make detailed simulation.

    path = [pwd, '\Network\'];
    constList = [300, 30, 0.6]; % [maxFiringRate, baseline, decayRate]
    paramList = [0.5, 0.5, 0.2, 0.125, 0.125, 0.25, 35.75, 74.86]; % [W_A, W_V, W_AM, W_MA, W_VM, W_MV, sigmaA, sigmaV]

    % prepare the input for the next function
    if mode == 'A'
        path = [path,  'Audio', mat2str(strength), '\'];
        if strength >= 0
            % stimList = [V_Din, V_Uin, A_Din, A_Uin]
            stimRep = repmat([0, strength], size(stimGradient, 1), 1);
            stimListList = [stimGradient, stimRep];
        else            
            stimRep = repmat([-strength, 0], size(stimGradient, 1), 1);
            stimListList = [stimGradient, stimRep];
        end
    else
        path = [path,  'Visual', mat2str(strength), '\'];
        if strength >= 0
            % stimList = [V_Din, V_Uin, A_Din, A_Uin]
            stimRep = repmat([0, strength], size(stimGradient, 1), 1);
            stimListList = [stimRep, stimGradient];
        else
            stimRep = repmat([-strength, 0], size(stimGradient, 1), 1);
            stimListList = [stimRep, stimGradient];
        end
    end
    
    if (~exist(path))
        mkdir(path);
    end

    % for each stimulus, make detailed simulation
    length = size(stimListList, 1);
    results = zeros(2, length);
    for i=1:1:length
        stimList = stimListList(i, :);
    
        [results(1, i), results(2, i), records] = ...
            NetworkSimulation_Run(stimList, constList, paramList, mode);

        figure(1);
        NetworkSimulation_resultsVisulization(records);
        saveas(gcf, [path, mat2str(i),...
            ' VD_', mat2str(stimList(1,1)), ' VU_', mat2str(stimList(1,2)),...
            ' AD_', mat2str(stimList(1,3)), ' AU_', mat2str(stimList(1,4)),...
            '.jpg']);
        close figure 1;
    end
    
    % Plot the firing rate of the current mode
    figure(1)
    plot(motionStrength, results(1,:), 'r', 'linewidth', 1);
    hold on
    plot(motionStrength, results(2,:), 'b', 'linewidth', 1);
    scatter(motionStrength, results(1,:), '+', 'r');
    scatter(motionStrength, results(2,:), '+', 'b');
    hold off
    grid on
    set(gca, 'GridLineStyle', ':');
    set(gca, 'GridAlpha', 1); 
    xlabel({'运动强度'; 'Motion Strength'});
    ylabel({'放电频率(min^{-1})'; 'Firing rate(min^{-1})'});  
    if mode == 'A'
        legend('V_D', 'V_U');  
    else
        legend('A_D', 'A_U');
    end
    ylim([0, 300]);
    saveas(gcf, [path, 'Firing rate of current mode.jpg']);  
       
    % plot the upwards preference of the current mode
    upwardsPreference = Comparator(motionStrength, results(1, :), results(2, :), 10);        
    figure(2)
    plot(motionStrength, upwardsPreference, 'linewidth', 1);
    grid on
    set(gca, 'GridLineStyle', ':');
    set(gca, 'GridAlpha', 1); 
    xlabel({'运动强度'; 'Motion Strength'});
    ylabel({'决策结果为向上的概率', 'Upward preference'});   
    xlim([0 1]);
    ylim([0 1]);
    saveas(gcf, [path, 'Upward preference from current mode.jpg']);
    
    close all
end
