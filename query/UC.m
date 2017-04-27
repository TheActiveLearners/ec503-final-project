function [ sel_idx ] = UC(X, Y, sel_idx, num_to_select, classifier)
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

% Get only those rows from X and Y
trained_X = X(sel_idx,:);
trained_Y = Y(sel_idx,:);
untrained_X = X(~sel_idx,:);
% untrained_Y = Y(~sel_idx); % Should not be using untrained_Y

switch classifier
    case 'dt'
        % Uncertainty Sampling for Decision Trees
        % Train a DT on only trained data
        dt_mdl = fitctree(trained_X, trained_Y);

        % Get Posterior distribution for each untrained X
        [~,post_dist,~,~] = predict(dt_mdl,untrained_X);

        % 1st column - positive class posterior probabilities
        cl_1_post = post_dist(:,1);
        cl_1_uncertain = abs(0.5 - cl_1_post);
        [all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');
        
    case 'nb'
        % Uncertainty Sampling for Naive Bayes
        % Train a NB on only trained data
        nb_mdl = fitcnb(trained_X, trained_Y,'Distribution','kernel');
        % Get Posterior distribution for each untrained X
        [~,post_dist,~] = predict(nb_mdl,untrained_X);
        % 1st column - positive class posterior probabilities
        cl_1_post = post_dist(:,1);
        cl_1_uncertain = abs(0.5 - cl_1_post);
        [all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');
    otherwise
            error('Not a valid classifier')    
end % END SWITCH

% Match the global all_indicies to the trained_indicies to the 
[untrain_n, ~] = size(untrained_X);
% [all_indicies, trained_indicies] 
untrained_indicies = horzcat(find(~sel_idx), (1:untrain_n)');

% for each of the remaining untrained indicies
for k = trained_indicies'
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

