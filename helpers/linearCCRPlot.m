function [ ] = linearCCRPlot( x, x_label, y, y_label, in_legend, in_title )
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
figure
hold on;
grid on;
[~, y_s] = size(y);
for i = 1:y_s
    y_i = y(:,i);
    plot(x, y_i) % plot on linear scale
end

% TITLE
title(in_title);
% LEGEND
legend(in_legend, 'location', 'southeastoutside');
% Y-AXIS LABEL
ylabel(y_label);
% X-AXIS LABEL
xlabel(x_label); % x-axis label


hold off;
end

