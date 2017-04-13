function [ sel_idx ] = UC(X, Y, sel_idx, num_to_select)
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
untrained_Y = Y(~sel_idx);


% Train a SVM on only trained data
% Alex - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
% IBN - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
mdl = fitcsvm(trained_X,trained_Y,...
                  'ClassNames',unique(Y),...
                  'KernelFunction','RBF',...
                  'Standardize',true);
% USING DISTANCE              
[~,d] = dsearchn(mdl.SupportVectors,untrained_X);
[min_dist, min_indicies] = sort(d);

% USING POSTERIOR
% compact_mdl = compact(mdl);
% % Get Posterior distribution for each untrained X
% [score_mdl,~] = fitPosterior(compact_mdl,...
%     untrained_X, untrained_Y);
% [~,post_dist] = predict(score_mdl,untrained_X);
% % 1st column - positive class posterior probabilities
% [cl_1_min,min_indicies_1] = sort(post_dist(:,2));
% % 2nd column - negative class posterior probabilities
% [cl_2_min,min_indicies_2] = sort(post_dist(:,2));
% 
% if cl_1_min > cl_2_min
%     min_indicies = min_indicies_1;
% else
%     min_indicies = min_indicies_2;
% end

% Find difference to account for aggregate selections
num_selected = numel(find(sel_idx));
% Get k smallest posteriors
k = num_to_select - num_selected;
i_s = min_indicies(1:k);
sel_idx(i_s) = true;
end

