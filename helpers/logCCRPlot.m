function [fig] = logCCRPlot( x, y_s, in_legend, dataset )
% logScalePlot
% Plots
%
% Syntax:  [  ] = logScalePlot(...
%              x,'Training Size',...
%              y,'CCR',...
%              legend,...
%              'Plot of CCR for training size between 2^{-5} to 2^{15}');
% Inputs:
%    x - log scale vector of x values: |X| x 1
%    x_label - x axis label: string
%    y - y values to corresponding x values: |X| x |Y| ex. 14 x 2 -> 2 samples 
%    y_label - x axis label: string
%    in_legend - cell array of strings
%    in_title - string
%
% Outputs:
%    N/A
%------------- BEGIN CODE --------------
fig = figure;
hold on;
grid on;

strats = fieldnames(y_s);
for i = 1:numel(strats)
    y = y_s.(strats{i});
    err = std(y)./5;
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

