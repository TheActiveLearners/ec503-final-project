function [ sel_idx ] = RAND( sel_idx, num_to_select )
% Random Selection
% Takes test data X and returns a single data point
% 
% Syntax:  [ x ] = RAND( sel_idx )
% Inputs:
%    sel_idx - logical array of selected indicies: num_sample x 1
%    num_select - number of data points to train on X: scalar
%
% Outputs:
%    new_sel_idx - logical array of selected indicies: num_sample x 1
%------------- BEGIN CODE --------------

pool = find(~sel_idx);
num_selected = numel(find(sel_idx));
% Find difference to allow for multiple selections
i_s = randsample(pool,(num_to_select - num_selected));
sel_idx(i_s) = true;
end

