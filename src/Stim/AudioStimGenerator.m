function [] = AudioStimGenerator(motionStrengthList)
% Generate auditory stimuli and calculate the motion energy
   
    path = [pwd, '\Stim\'];
    if (~exist(path))
        mkdir(path);
    end
    path = [path, 'a_'];
    
    %***************** Create input files *************
    sec2Row = 200;

    % The sound should be at a logrithmic scale. So I'm going to build an
    % evelope to make the sound.
    xEnvelope = (-10:10);
    audioStrength = 0.25;
    yEnvelope = audioStrength .* exp(-xEnvelope.^2/2.^2);
    audioVecRight = zeros(sec2Row, sec2Row+40);
    audioVecLeft = zeros(sec2Row, sec2Row+40);
    for t=1:1:sec2Row
        audioVecRight(t, t+10:t+30) = yEnvelope; 
        audioVecLeft(t, sec2Row+1-t+10:sec2Row+1-t+30) = yEnvelope; 
    end

    %********** Superimpose the two movements ***********
    save([path, 'motionStrength.mat'], 'motionStrengthList');
    motionEnergy = zeros(1, size(motionStrengthList, 2));
    motionEnergy2 = zeros(2, size(motionStrengthList, 2));
    t_i = 1;
    for motionRightStrength = motionStrengthList    
        audio = audioVecRight*motionRightStrength + audioVecLeft*(1-motionRightStrength);
        % save([path, num2str(motionRightStrength), '.mat'], 'audio')
        [motionEnergy(1, t_i), motionEnergy2(1, t_i), motionEnergy2(2, t_i)] = AudioStimAnalyser(audio);
        t_i = t_i + 1;
    end

    % 听觉运动能量与相对运动强度的关系图
    plot(motionStrengthList, motionEnergy2(1,:), 'linewidth', 1);
    hold on
    plot(motionStrengthList, motionEnergy2(2,:), 'linewidth', 1);
    hold off
    xlabel({'运动强度'; 'Motion Strength'});
    ylabel({'运动能量'; 'Motion Energy'});
    legend(['向下运动的能量', sprintf('\n'), 'Downward Motion Energy'], ['向上运动的能量', sprintf('\n'), 'Upward Motion Energy'], 'Location', 'NorthOutside', 'Orientation','horizontal');
    saveas(gcf, [path, 'energy.jpg']);
    save([path, 'energy.mat'], 'motionEnergy2');

    %************ Create sound files *************
%   % Generate the actual sound files.
%     fs=15000;
%     
%     sec2Row = 200;
%     deltaT = 1/200;
%     t = 0:1/fs:deltaT-1/fs;
%     lengthT = fs/sec2Row;
%     
%     frequency = 200;
%     step = 1.013;
%     Store = zeros(sec2Row+40, lengthT);
%     for i=20:1:sec2Row+40
%         Store(i, :) = sin(2*pi*frequency*t);
%         frequency = frequency * step;
%     end
%     frequency = 200;
%     for i=20:-1:1
%         Store(i, :) = sin(2*pi*frequency*t);
%         frequency = frequency / step;
%     end
%     
%     upwardSound = zeros(1, fs);
%     downwardSound = zeros(1, fs);
%     for i=1:1:sec2Row
%         for j=1:1:sec2Row+40
%             if audioVecRight(i, j) ~= 0
%                 upwardSound(1, (i-1)*lengthT+1:i*lengthT) = ...
%                     upwardSound(1, (i-1)*lengthT+1:i*lengthT) + audioVecRight(i, j) * Store(j, :);
%             end
%             if audioVecLeft(i, j) ~= 0
%                 downwardSound(1, (i-1)*lengthT+1:i*lengthT) = ...
%                     downwardSound(1, (i-1)*lengthT+1:i*lengthT) + audioVecLeft(i, j) * Store(j, :);
%             end
%         end
%     end
%     
%     for motionRightStrength = motionStrengthList    
%         audioOut = upwardSound*motionRightStrength + downwardSound*(1-motionRightStrength);
%         for i=1:1:0.02*fs
%             audioOut(1,i) = audioOut(1,i)*i/0.02/fs;
%             audioOut(1,fs+1-i) = audioOut(1,fs+1-i)*i/0.02/fs;
%         end
%         audiowrite([path, num2str(motionRightStrength), '.wav'], audioOut, fs)
%     end

    close all
end