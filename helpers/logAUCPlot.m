function [ ] = logAUCPlot( x, x_label, y, y_label, in_legend, in_title )
% aucPlot
% Plots
%
% Syntax:  [  ] = logAUCPlot(...
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
figure
hold on;
grid on;
[y_p, y_s] = size(y);
y_i = zeros(y_p,1);
for i = 1:y_s
    raw_y = y(:,i);
    y_i(1) = raw_y(1);
    for p = 2:length(raw_y)
        y_i(p) = trapz(x(1:p),raw_y(1:p))/trapz(x(1:p), ones(p,1));
    end
    plot(log2(x), y_i) % plot on log2 x-scale
end
set(gca, 'XTickLabel',[]); % suppress current x-labels
xt = get(gca, 'XTick');
yl = get(gca, 'YLim');

% TITLE
title(in_title);
% LEGEND
legend(in_legend, 'location', 'southeastoutside');
% Y-AXIS LABEL
ylabel(y_label);
% X-AXIS LABEL
xlabel(x_label); % x-axis label
xlabh = get(gca,'XLabel');
% to move x-axis label down
set(xlabh,'Position',get(xlabh,'Position') - [0 .025 0])
str = cellstr( num2str(xt(:),'2^{%d}') ); % replace with 2^d
text(xt, yl(ones(size(xt))), str, 'Interpreter','tex', ...
    'VerticalAlignment','top', 'HorizontalAlignment','center');

hold off;
end

