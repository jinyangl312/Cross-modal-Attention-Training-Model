function [] = MotionVisulization()
% Visulize the x-t plot of a visual motion.

    % Most code is copied from the function VisualStimGenerator
    path = [pwd, '\Stim\'];

    if (~exist(path))
        mkdir(path);
    end

    % Make the visual stimulus
    deg2Col = 20;
    visAngle = 20;
    space = linspace(0, visAngle, deg2Col * visAngle+1);

    spatialFreq = 0.3;
    gridStrength = 0.091;
    space = sin(2 * pi * spatialFreq * space);
    space = space * gridStrength;

    x_filt=linspace(-visAngle/2,visAngle/2,deg2Col * visAngle+1);
    sx=4.45;
    gauss=exp(-x_filt.^2/sx.^2); 

    sec2Row = 200;
    speedFreq = 9;
    imageVecRight = zeros(2*sec2Row, deg2Col*visAngle+1);
    imageVecRight(1,:) = space;
    offsetStep = speedFreq / spatialFreq * deg2Col / sec2Row;
    for t=0:1:sec2Row-2
        imageVecRight(2*t+1, :) = circshift(space, offsetStep*t);
        imageVecRight(2*t+2, :) = circshift(space, offsetStep*t);
    end
    imageVecRight = imageVecRight .* gauss;
    imageVecRight = imageVecRight';

    
    
    
    
    % Make the x-t plot
    figure;
    imshow(imageVecRight, [-1 1]);
    set(gca,'YDir','normal');  
    ylabel({'位置'; 'Position'});      
    xlabel({'时间(ms)'; 'Time(ms)'});
    annotation1 = annotation(gcf,'arrow',[0.179 0.179],[0.185 0.975]);
    annotation2 = annotation(gcf,'arrow',[0.179 0.87],[0.185 0.185]);
    saveas(gcf, [path, 'imageVecRight.jpg']);

    % Make the auditory stimulus and make its plot
    % sec2Row = 200;
    % 
    % xEnvelope = (-10:10);
    % audioStrength = 0.25;
    % yEnvelope = audioStrength .* exp(-xEnvelope.^2/2.^2);
    % audioVecRight = zeros(sec2Row, sec2Row+40);
    % for t=1:1:sec2Row
    %     audioVecRight(t, t+10:t+30) = yEnvelope; 
    % end
    % 
    % audioVecRight = audioVecRight';
    % imshow(audioVecRight, [-1 1]);
    % ylabel({'对数频率'; 'Logarithm Frequency'});
    % set(gca,'YDir','normal');  
    % xlabel({'时间(ms)'; 'Time(ms)'});
    % annotation1 = annotation(gcf,'arrow',[0.265 0.265],[0.26 0.96]);
    % annotation2 = annotation(gcf,'arrow',[0.265 0.8],[0.26 0.26]);
    % saveas(gcf, [path, 'audioVecRight.jpg']);
    % saveas(gcf, [path, 'audioVecRight.fig']);

    close all;
end