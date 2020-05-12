function [  ] = Results_Integration_Sensitivity(stimGradient, mode, strength, integrationList, sensitivityList, motionStrength)
% Show the change of preference curves when integration inhibition and sensitivity are changed.

    path = [pwd, '\Results\Combination\'];
    if (~exist(path)) mkdir(path); end 
    
    AUC = zeros(size(sensitivityList, 2), size(integrationList, 2));
    AUC2 = zeros(size(sensitivityList, 2), size(integrationList, 2));
    
    line = 1;
    for sensitivity = sensitivityList
        results = zeros(size(integrationList, 2), size(stimGradient, 1));   
        results2 = zeros(size(integrationList, 2), size(stimGradient, 1));     
        results3 = zeros(size(integrationList, 2), size(stimGradient, 1));             

        % different integration     
        for i=1:1:size(integrationList, 2)
            integration = integrationList(1, i);
            results(i, :) = ...
                Results_Run(mode, strength, stimGradient, motionStrength, 1, integration, sensitivity);
            results2(i, :) = ...
                Results_Run(mode, -strength, stimGradient, motionStrength, 1, integration, sensitivity);
            results3(i, :) = ...
                Results_Run(mode, 0, stimGradient, motionStrength, 1, integration, sensitivity);
        end        

        % Should decline        
        for i=1:1:size(integrationList, 2)
            for j=2:1:size(motionStrength, 2)
                if motionStrength(1, j) <= 0.5
                    AUC(line, i) = AUC(line, i) + ...
                        (results(i, j) + results(i, j-1)) * (motionStrength(1,j) - motionStrength(1, j-1)) /2+...
                        (results2(i, j) + results2(i, j-1)) * (motionStrength(1,j) - motionStrength(1, j-1)) /2;
                    AUC2(line, i) = AUC2(line, i) + ...
                        (results3(i, j) + results3(i, j-1)) * (motionStrength(1,j) - motionStrength(1, j-1)) /2;
                else
                    AUC(line, i) = AUC(line, i) + ...
                        (2 - results(i, j) - results(i, j-1)) * (motionStrength(1,j) - motionStrength(1, j-1)) /2+...
                        (2 - results2(i, j) - results2(i, j-1)) * (motionStrength(1,j) - motionStrength(1, j-1)) /2;                
                    AUC2(line, i) = AUC2(line, i) + ...
                        (2 - results3(i, j) - results3(i, j-1)) * (motionStrength(1,j) - motionStrength(1, j-1)) /2;
                end
            end
        end

        line = line+1;
    end
    
    AUC = AUC / 2;
    figure(2)
    imagesc(AUC);
    colorbar
    xlabel({'跨模态整合抑制等级'; 'Multi-sensory Integration Inhibition Level'});
    ylabel({'决策灵敏度等级'; 'Decision Sensitivity Level'});
    set(gca,'YDir','normal');
    title('(a)');
%     title('Integration-Sensitivity combination');
    saveas(gcf, [path, 'Integration-Sensitivity Combination ', mode, ' multimodal.jpg']);
    
    figure(3)
    imagesc(AUC2);
    colorbar
    xlabel({'跨模态整合抑制等级'; 'Multi-sensory Integration Inhibition Level'});
    ylabel({'决策灵敏度等级'; 'Decision Sensitivity Level'});
    set(gca,'YDir','normal');
    title('(b)');
%     title('Integration-Sensitivity combination');
    saveas(gcf, [path, 'Integration-Sensitivity Combination ', mode, ' unimodal.jpg']);
    
    close all
end

