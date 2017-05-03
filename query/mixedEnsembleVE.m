function [ sel_idx ] = mixedEnsembleVE(sel_idx, num_to_select)
% Mixed - Uncertainty Sampling
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

% RANDOM SAMPLE
random_fraction = 1 - num_to_select/length(TRAIN_X);
sel_idx = RAND(sel_idx, floor(num_to_select * random_fraction));

% Get only those rows from X and Y
untrained_X = TRAIN_X(~sel_idx,:);

sorted_indicies = getSortedEnsembleVE( sel_idx );
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


% RANDOM SAMPLE HALF
sel_idx = RAND(sel_idx,num_to_select);


% ERROR CHECKING
if sum(sel_idx) ~= num_to_select
    error('Number of selected indicies do not match in this iteration');
end

end

