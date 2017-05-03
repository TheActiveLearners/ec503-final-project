function [ ] = linearAUCPlot( x, y_s, in_legend)
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

strats = fieldnames(y_s);
for i = 1:numel(strats)
    y = y_s.(strats{i});
    mean_y = mean(y,1);
    [~,m] = size(mean_y);
    y_i = zeros(m,1);
    y_i(1) = mean_y(1);
    for p = 2:length(mean_y)
        y_i(p) = trapz(x(1:p),mean_y(1:p))/trapz(x(1:p), ones(p,1));
    end
    plot(x, y_i) % plot on linear scale
end


% TITLE
title('Plot of AUC for training size between 1 to max training size');
% LEGEND
legend(in_legend, 'location', 'southeastoutside');
% Y-AXIS LABEL
ylabel('AUC');
% X-AXIS LABEL
xlabel('Training Size'); % x-axis label

hold off;
end

