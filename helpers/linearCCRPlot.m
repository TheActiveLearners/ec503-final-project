function [fig] = linearCCRPlot( x, y_s, in_legend, dataset)
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
    err = std(y);
    y_i = mean(y,1);
    errorbar(x,y_i,err);
end

% TITLE
title(strcat('CCR as a function of training size for ', dataset));
% LEGEND
legend(in_legend, 'location', 'southeastoutside');
% Y-AXIS LABEL
ylabel('CCR');
% X-AXIS LABEL
xlabel('Training Size'); % x-axis label


hold off;
end

