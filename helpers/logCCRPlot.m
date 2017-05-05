function [fig] = logCCRPlot( x, y_s, in_legend, dataset, trials )
% logScalePlot
% Plots CCR on a log scale
%
% Syntax:  [ fig ] = linearScalePlot(...
%                                    x, y_s,...
%                                    in_legend,trial);
% Inputs:
%    x - scale for which vector of x values: |X| x 1
%    y_s - struct containting 
%    in_legend - cell array of strings
%    dataset - string
%    trials - number of trials
%
% Outputs:
%    fig - the figure of the plot
%------------- BEGIN CODE --------------
fig = figure;
hold on;
grid on;

strats = fieldnames(y_s);
for i = 1:numel(strats)
    y = y_s.(strats{i});
    err = std(y)./sqrt(trials);
    y_i = mean(y,1);
    errorbar(log2(x),y_i,err);
end
set(gca, 'XTickLabel',[]); % suppress current x-labels
xt = get(gca, 'XTick');
yl = get(gca, 'YLim');

% TITLE
title(['CCR as a function of training size for ', dataset]);
% LEGEND
legend(in_legend, 'location', 'southeastoutside');
% Y-AXIS LABEL
ylabel('CCR');
% X-AXIS LABEL
xlabel('Training Size'); % x-axis label
xlabh = get(gca,'XLabel');
% to move x-axis label down
set(xlabh,'Position',get(xlabh,'Position') - [0 .025 0])
str = cellstr( num2str(xt(:),'2^{%d}') ); % replace with 2^d
text(xt, yl(ones(size(xt))), str, 'Interpreter','tex', ...
    'VerticalAlignment','top', 'HorizontalAlignment','center');

hold off;
end

