function [] = FilterVisulization()
% Visulize the four filters.
    
    % Copied from the function VisualStimAnalyser:
    %--------------------------------------------------------------------------
    %           STEP 1: Create component spatiotemporal filters 
    %--------------------------------------------------------------------------

    % Step 1a: Define the space axis of the filters
    nx=80;              %Number of spatial samples in the filter
    max_x =2.0;         %Half-width of filter (deg)
    dx = (max_x*2)/nx;  %Spatial sampling interval of filter (deg)

    % A row vector holding spatial sampling intervals
    x_filt=linspace(-max_x,max_x,nx);

    % Spatial filter parameters
    sx=0.5;   %standard deviation of Gaussian, in deg.
    sf=1.1;  %spatial frequency of carrier, in cpd

    % Spatial filter response
    gauss=exp(-x_filt.^2/sx.^2);          %Gaussian envelope
    even_x=cos(2*pi*sf*x_filt).*gauss;   %Even Gabor
    odd_x=sin(2*pi*sf*x_filt).*gauss;    %Odd Gabor

    % Step 1b: Define the time axis of the filters
    nt=100;         % Number of temporal samples in the filter
    max_t=0.5;      % Duration of impulse response (sec)
    dt = max_t/nt;  % Temporal sampling interval (sec)

    % A column vector holding temporal sampling intervals
    t_filt=linspace(0,max_t,nt)';

    % Temporal filter parameters
    k = 100;    % Scales the response into time units
    slow_n = 9; % Width of the slow temporal filter
    fast_n = 6; % Width of the fast temporal filter
    beta =0.9;  % Beta. Represents the weighting of the negative
                % phase of the temporal relative to the positive 
                % phase.

    % Temporal filter response (formula as in Adelson & Bergen, 1985, Eq. 1)
    slow_t=(k*t_filt).^slow_n .* exp(-k*t_filt).*(1/factorial(slow_n)-beta.*((k*t_filt).^2)/factorial(slow_n+2));
    fast_t=(k*t_filt).^fast_n .* exp(-k*t_filt).*(1/factorial(fast_n)-beta.*((k*t_filt).^2)/factorial(fast_n+2));

    % Step 1c: combine space and time to create spatiotemporal filters
    e_slow= slow_t * even_x;    %SE/TS
    %imshow(e_slow, [min(min(e_slow)) max(max(e_slow))])
    e_fast= fast_t * even_x ;   %SE/TF
    o_slow = slow_t * odd_x ;   %SO/TS
    o_fast = fast_t * odd_x ;   % SO/TF

    %--------------------------------------------------------------------------
    %         STEP 2: Create spatiotemporally oriented filters
    %--------------------------------------------------------------------------
    left_1=o_fast+e_slow;      % L1
    left_2=-o_slow+e_fast;     % L2
    right_1=-o_fast+e_slow;    % R1
    right_2=o_slow+e_fast;     % R2


    
    

    % Make the plot
    path = [pwd, '\Stim\'];

    left_1=left_1';      % L1
    left_2=left_2';     % L2
    right_1=right_1';    % R1
    right_2=right_2';     % R2

    if (~exist(path)) mkdir(path); end
    figure;
    minVal = min([min(min(left_1)), min(min(left_2)), min(min(right_1)), min(min(right_2))]);
    maxVal = max([max(max(left_1)), max(max(left_2)), max(max(right_1)), max(max(right_2))]);
    subplot(1, 5, 1);
    imshow(left_1, [minVal maxVal]);
          set(gca,'YDir','normal');  
    title('(a)');
    subplot(1, 5, 2);
    imshow(left_2, [minVal maxVal]);
          set(gca,'YDir','normal');  
    title('(b)');
    subplot(1, 5, 3);
    imshow(right_1, [minVal maxVal]);
          set(gca,'YDir','normal');  
    title('(c)');
    subplot(1, 5, 4);
    imshow(right_2, [minVal maxVal]);
          set(gca,'YDir','normal');  
    title('(d)');
    annotation(gcf,'arrow',[0.11 0.11],[0.45 0.58]);
    annotation(gcf,'arrow',[0.13 0.26],[0.41 0.41]);
    % The text needs to be set manually.
    % text(0.25,1,{'Œª÷√'; 'Space'},'Rotation',90)
    % text(0.13, 0.10, {' ±º‰'; 'Time'})

    saveas(gcf, [path, '\Filter.jpg']);

    close all
end