addpath([pwd, '\src\Network Simulation']);

% Make the figure of the mean error rate
Mean_error_rate_Visulization();

% load the motion strength and the motion energy
motionStrength = cell2mat(struct2cell(load([pwd, '\Stim\v_motionStrength.mat'])));
stimGradientA = cell2mat(struct2cell(load([pwd, '\Stim\v_energy.mat'])))';
stimGradientV = cell2mat(struct2cell(load([pwd, '\Stim\a_energy.mat'])))';
strength = 3;

% Cross-modal and unimodal visual attention switching task. 'A' means the
% unrelated input is auditory motion.
% Visulize the simulation process
NetworkSimulation_Simulation('A', 3, stimGradientA, motionStrength);
% Combine different process together
NetworkSimulation_Simulation_Plot('A', 3, stimGradientA, motionStrength);
        
% Cross-modal and unimodal auditory attention switching task
NetworkSimulation_Simulation_Plot('V', 3, stimGradientV, motionStrength);

% Check the convergence of the model, or whether the model generates
% different results under the same input.
% Actually, since there is no stochastic process in the simulation, the
% error between two simulation with the same input is 0.
% turns = 20;
% threshold = 0;
% NetworkSimulation_Convergence('A', strength, stimGradientA, turns, threshold);
% NetworkSimulation_Convergence('A', -strength, stimGradientA, turns, threshold);
% NetworkSimulation_Convergence('V', strength, stimGradientV, turns, threshold);
% NetworkSimulation_Convergence('V', -strength, stimGradientV, turns, threshold);