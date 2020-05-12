addpath([pwd, '\src\Stim']);

% Gradient of the motion strength
motionStrengthList = [0, 0.10, 0.20, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.80, 0.90, 1.0];

% Generate the stimuli and calculate the motion energy
VisualStimGenerator(motionStrengthList);
AudioStimGenerator(motionStrengthList);

% Make the figures of the motion and the filter
FilterVisulization();
MotionVisulization();