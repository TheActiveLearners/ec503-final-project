function [fig] = linearCCRPlot( x, y_s, in_legend, dataset, trials)
% linearScalePlot
% Plots CCR on a linear scale
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

