addpath([pwd, '\src']);

% Generate the visual and auditory stimuli and calculate the motion energy
run GenerateStim;

% The dynamics of the cross-modal attention switching model
run NetworkSimulation

% The dynamics of the model when changing different factors
run Results