function [ sel_idx ] = pureDensity(sel_idx, num_to_select)
% Uncertainty Sampling
% Takes test data X and returns a single data point
%
% Syntax:  [ sel_idx ] = UC(X, Y, sel_idx);
% Inputs:
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%    num_select - number of data points to train on X: scalar
%
% Outputs:
%    new_sel_idx - logical array of selected indicies: num_sample x 1
%------------- BEGIN CODE --------------

global TRAIN_X;

% Get only those rows from X and Y
untrained_X = TRAIN_X(~sel_idx,:);
% untrained_Y = Y(~sel_idx); % Should not be using untrained_Y


sorted_indicies = getSortedDensity(sel_idx);


% Match the global all_indicies to the trained_indicies to the 
[untrain_n, ~] = size(untrained_X);
% [all_indicies, trained_indicies] 
untrained_indicies = horzcat(find(~sel_idx), (1:untrain_n)');

% for each of the remaining untrained indicies
for k = sorted_indicies'
    % find the matching index from all the indicies     
    idx_tuple = untrained_indicies(untrained_indicies(:,2) == k,:);
    % isolate only the "global" index     
    global_idx = idx_tuple(1);
    % if this index hasn't been selected already
    if ~sel_idx(global_idx)
        % select it         
        sel_idx(global_idx) = 1;
        % if reached the target number to select, break early         
        if sum(sel_idx) == num_to_select
            break;
        end
    end
    
end

% ERROR CHECKING
if sum(sel_idx) ~= num_to_select
    error('Number of selected indicies do not match in this iteration');
end

end

