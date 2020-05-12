function [] =  VisualStimGenerator (motionStrengthList)
% Generate visual stimuli and calculate the motion energy

    path = [pwd, '\Stim\'];
    if (~exist(path))
        mkdir(path);
    end
    path = [path, 'v_'];
    
    %************** Grating Generation ******************
    % 1 degree is represented by 20 columns and 1 second is represented by
    % 200 rows.
    % The visual stimulus is set to be 20 degrees or 400 columns in width. 
    % Duration is set as 1 second or 200 rows in length.
    deg2Col = 20;
    visAngle = 20;
    sec2Row = 200;
    
    % First, generate the row pattern
    space = linspace(0, visAngle, deg2Col * visAngle+1);

    % The grid has a spatial frequency of 0.3 cycles/degree or 0.3 cycles/20
    % columns. If there are 400 columns, 6 cycles are expected.
    spatialFreq = 0.3; % cycles/degree
    space = sin(2 * pi * spatialFreq * space);
    gridStrength = 0.091; % to increase ambiguity. equals to Michelson contrast.
    space = space * gridStrength;

    % Gauss envelope
    x_filt=linspace(-visAngle/2,visAngle/2,deg2Col * visAngle+1);
    sx=4.45;
    gauss=exp(-x_filt.^2/sx.^2); 

    %*********** Movement of the grating ****************
    % 1 deg/sec = 0.1 col/row.
    % The temporal frequency was set to be 9 cycles/sec.
    speedFreq = 9; % cycles/sec
    imageVecRight = zeros(sec2Row, deg2Col*visAngle+1);
    imageVecLeft = zeros(sec2Row, deg2Col*visAngle+1);
    imageVecRight(1,:) = space;
    imageVecLeft(1,:) = space;
    offsetStep = speedFreq / spatialFreq * deg2Col / sec2Row; % col/row
    for t=1:1:sec2Row-1
        imageVecRight(t+1, :) = circshift(space, offsetStep*t);
        imageVecLeft(t+1, :) = circshift(space, -offsetStep*t);
    end
    imageVecRight = imageVecRight .* gauss;
    imageVecLeft = imageVecLeft .* gauss;

    %********** Superimpose the two movements ***********
    save([path, 'motionStrength.mat'], 'motionStrengthList');
    motionEnergy = zeros(1, size(motionStrengthList, 2));
    motionEnergy2 = zeros(2, size(motionStrengthList, 2));
    t_i = 1;
    for motionRightStrength = motionStrengthList    
        image = imageVecRight*motionRightStrength + imageVecLeft*(1-motionRightStrength);
        % save([path, num2str(motionRightStrength), '.mat'], 'image');
%       %************ Create the gif file *************
%       % https://blog.csdn.net/lusongno1/article/details/78632457
%       % Generate the moving grating as gif files.       
%         for t=1:1:sec2Row
%             t_SpaceShow = repmat(image(t,:).*gauss, deg2Col*visAngle+1, 1);
%             imshow(t_SpaceShow, [-1 1]);     
%             F=getframe(gcf);
%             I=frame2im(F);
%             [I,map]=rgb2ind(I,256);
%             Noise occurs in the generated output. The imwrite function is not suitable.
%             if t == 1
%                 imwrite(I,map,[path, num2str(motionRightStrength), '.gif'],'gif', 'Loopcount',inf,'DelayTime',0.005);
%             else
%                 imwrite(I,map,[path, num2str(motionRightStrength), '.gif'],'gif','WriteMode','append','DelayTime',0.005);
%             end
%         end
        [motionEnergy(1, t_i), motionEnergy2(1, t_i), motionEnergy2(2, t_i)] = VisualStimAnalyser(image);
        t_i = t_i + 1;
    end    

    % Plot the energy
    % 视觉运动能量与视觉相对运动强度的关系图
    plot(motionStrengthList, motionEnergy2(1,:), 'linewidth', 1);
    hold on
    plot(motionStrengthList, motionEnergy2(2,:), 'linewidth', 1);
    hold off
    xlabel({'运动强度'; 'Motion Strength'});
    ylabel({'运动能量'; 'Motion Energy'});
    legend(['向下运动的能量', sprintf('\n'), 'Downward Motion Energy'], ['向上运动的能量', sprintf('\n'), 'Upward Motion Energy'], 'Location', 'NorthOutside', 'Orientation','horizontal');
    saveas(gcf, [path, 'energy.jpg']);
    save([path, 'energy.mat'], 'motionEnergy2');

    close all
end