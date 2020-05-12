function [] =  NetworkSimulation_resultsVisulization(records)
% Visulize the developement of firing rate.

    width = 1.5;
    plot(records(7,:), records(1,:), 'linewidth', width);
    hold on
    plot(records(7,:), records(2,:), 'linewidth', width);
    plot(records(7,:), records(3,:), 'linewidth', width);
    plot(records(7,:), records(4,:), 'linewidth', width);
    plot(records(7,:), records(5,:), 'linewidth', width);
    plot(records(7,:), records(6,:), 'linewidth', width);
    hold off
    grid on
    set(gca, 'GridLineStyle', ':');
    set(gca, 'GridAlpha', 1); 
    legend('V_D', 'V_U', 'A_D', 'A_U', 'SC_D', 'SC_U');
    xlabel({'时间(ms)'; 'Time(ms)'});
    ylabel({'放电频率（次·min^{-1}）'; 'Firing Rate(min^{-1})'});    
    xlim([0, records(7, size(records, 2))]);
    ylim([0, 300]);
    %title('Network simulation results');
end