function [ sel_idx ] = RAND( sel_idx )
% Random Selection
% Takes test data X and returns a single data point
% 
% Syntax:  [ x ] = RAND( sel_idx )
% Inputs:
%    sel_idx - logical array of selected indicies: num_sample x 1
%
% Outputs:
%    new_sel_idx - logical array of selected indicies: num_sample x 1
%------------- BEGIN CODE --------------

pool = find(~sel_idx);
i = randsample(pool,1);
sel_idx(i) = true;
end

