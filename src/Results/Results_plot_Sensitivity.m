function Results_plot_Sensitivity()
% Merge the mean error rate curves together.

    path = [pwd, '\Results\Sensitivity\'];
    front = [path, 'Mean error rate '];

    f1=openfig([front, 'A multimodal', '.fig'],'reuse');
    % f2=openfig([front, 'V multimodal', '.fig'],'reuse');
    f3=openfig([front, 'A unimodal', '.fig'],'reuse');
    % f4=openfig([front, 'V unimodal', '.fig'],'reuse');

    x=get(findall(f1, 'type', 'line'),'xdata');
    y1=get(findall(f1, 'type', 'line'),'ydata');
    % y2=get(findall(f2, 'type', 'line'),'ydata');
    y3=get(findall(f3, 'type', 'line'),'ydata');
    % y4=get(findall(f4, 'type', 'line'),'ydata');

    figure
    plot(x, y1);
    hold on
    %plot(x, y2);
    plot(x, y3);
    %plot(x, y4);
    hold off
    xlabel({'决策灵敏度等级'; 'Decision Sensitivity Level'});
    ylabel({'平均误差率'; 'Mean Error Rate'});
    xlim([min(x) max(x)]);
    %ylim([0.059, 0.072]);
    %legend('跨模态视觉任务', '跨模态听觉任务', '单模态视觉任务', '单模态听觉任务');
    legend(['跨模态视觉任务', sprintf('\n'), 'Cross-modal Visual Tasks'], ['单模态视觉任务', sprintf('\n'), 'Unimodal Visual Tasks']);
    saveas(gcf, [path, 'mean error rate merge.jpg']);  

    close all;

end