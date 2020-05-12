function [] = NetworkSimulation_Simulation_Plot(mode, strength, stimGradient, motionStrength)
% Take the list of motion strength and stimuli; make detailed simulation.
    
    % Adapted from the function NetworkSimulation_Simulation
    
    path = [pwd, '\Network\Results curves plot\'];
    if (~exist(path))
        mkdir(path);
    end   

    constList = [300, 30, 0.6]; % [maxFiringRate, baseline, decayRate]
    paramList = [0.5, 0.5, 0.2, 0.125, 0.125, 0.25, 35.75, 74.86]; % [W_A, W_V, W_AM, W_MA, W_VM, W_MV, sigmaA, sigmaV]

    final = zeros(2, size(stimGradient, 1));
    for t_strength = [strength, -strength]
        if mode == 'A'
            if t_strength >= 0
                % stimList = [V_Din, V_Uin, A_Din, A_Uin]
                stimRep = repmat([0, t_strength], size(stimGradient, 1), 1);
                stimListList = [stimGradient, stimRep];
            else            
                stimRep = repmat([-t_strength, 0], size(stimGradient, 1), 1);
                stimListList = [stimGradient, stimRep];
            end
        else
            if t_strength >= 0
                % stimList = [V_Din, V_Uin, A_Din, A_Uin]
                stimRep = repmat([0, t_strength], size(stimGradient, 1), 1);
                stimListList = [stimRep, stimGradient];
            else
                stimRep = repmat([-t_strength, 0], size(stimGradient, 1), 1);
                stimListList = [stimRep, stimGradient];
            end
        end

        length = size(stimListList, 1);
        results = zeros(2, length);
        for i=1:1:length
            stimList = stimListList(i, :);

            [results(1, i), results(2, i), ~] = ...
                NetworkSimulation_Run(stimList, constList, paramList, mode);
        end

        if t_strength == strength
            [final(1, :)] = Comparator(motionStrength,...
                results(1, :), results(2, :), 10); 
        else
            [final(2, :)] = Comparator(motionStrength,...
                results(1, :), results(2, :), 10);
        end
    end

    % Make the plot
    figure(1)
    plot(motionStrength, final(1, :), 'r', 'linewidth', 1);
    hold on    
    plot(motionStrength, final(2, :), 'b', 'linewidth', 1);
    hold off
    grid on
    set(gca, 'GridLineStyle', ':');
    set(gca, 'GridAlpha', 1); 
    if mode == 'A'
        xlabel({'视觉运动强度'; 'Visual Motion Strength'});   
        legend(['听觉干扰向上', sprintf('\n'), 'Upward Auditory Motion'], ['听觉干扰向下', sprintf('\n'), 'Downward Auditory Motion'], 'Location', 'NorthOutside', 'Orientation','horizontal');
%        title(['Primary motion: audition']);
    else
        xlabel({'听觉运动强度'; 'Auditory Motion Strength'});
        legend(['视觉干扰向上', sprintf('\n'), 'Upward Visual Motion'], ['视觉干扰向下', sprintf('\n'), 'Downward Visual Motion'], 'Location', 'NorthOutside', 'Orientation','horizontal');
%        title(['Primary motion: vision']);
    end
    ylabel({'决策结果为向上的概率'; 'Upward preference'});   
    xlim([0.25 0.75]);
    ylim([0 1]);
    if mode == 'A'
        saveas(gcf, [path, 'Upward preference A.jpg']);
    else           
        saveas(gcf, [path, 'Upward preference V.jpg']);
    end

    close all        
end   