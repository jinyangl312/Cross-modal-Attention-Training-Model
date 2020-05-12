addpath([pwd, '\src\Results']);

% load the motion strength and the motion energy
motionStrength = cell2mat(struct2cell(load([pwd, '\Stim\v_motionStrength.mat'])));
stimGradientA = cell2mat(struct2cell(load([pwd, '\Stim\v_energy.mat'])))';
% stimGradientV = cell2mat(struct2cell(load([pwd, '\Stim\a_energy.mat'])))';
strength = 3;

% Strength levels
attentionList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
integrationList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
sensitivityList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

% Cross-modal and unimodal visual attention switching tasks. 'A' means the
% unrelated input is auditory motion.
% Results when changing only one factor
Results_Attention(stimGradientA, 'A', strength, attentionList, motionStrength);
Results_plot_Attention();
Results_Integration(stimGradientA, 'A', strength, integrationList, motionStrength);
Results_plot_Integration();
Results_Sensitivity(stimGradientA, 'A', strength, sensitivityList, motionStrength);
Results_plot_Sensitivity();
% Results when changing two factors
Results_Attention_Integration(stimGradientA, 'A', strength, attentionList, integrationList, motionStrength);
Results_Attention_Sensitivity(stimGradientA, 'A', strength, attentionList, sensitivityList, motionStrength);
Results_Integration_Sensitivity(stimGradientA, 'A', strength, integrationList, sensitivityList, motionStrength);

% Auditory attention switching tasks
% Results_Attention(stimGradientV, 'V', strength, attentionList, motionStrength);
% Results_Integration(stimGradientV, 'V', strength, integrationList, motionStrength);
% Results_Sensitivity(stimGradientV, 'V', strength, sensitivityList, motionStrength);
% Results_Attention_Integration(stimGradientV, 'V', strength, attentionList, integrationList, motionStrength);
% Results_Attention_Sensitivity(stimGradientV, 'V', strength, attentionList, sensitivityList, motionStrength);
% Results_Integration_Sensitivity(stimGradientV, 'V', strength, integrationList, sensitivityList, motionStrength);
