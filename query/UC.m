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
% untrained_Y = Y(~sel_idx); % Should not be using untrained_Y


% METHOD 1 - USE K NEAREST
% [~,d] = dsearchn(svm_mdl.SupportVectors,untrained_X);
% [all_dist_1, all_indicies_1] = sort(d, 'descend');

% METHOD 2 - POSTERIOR 
% Train a SVM on only trained data
% Alex - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
% IBN - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
% svm_mdl = fitcsvm(trained_X,trained_Y,...
%                   'ClassNames',unique(Y),...
%                   'Standardize',true,...
%                   'OutlierFraction',0.05);
% 
% 
% Get Posterior distribution for each untrained X
% [score_mdl,unselected_indicies] = fitSVMPosterior(svm_mdl);
% [i_select,post_dist] = predict(score_mdl,untrained_X);
% % 1st column - positive class posterior probabilities
% cl_1_post = post_dist(:,1);
% cl_1_uncertain = abs(0.5 - cl_1_post);
% [all_dist_2, all_indicies_2] = sort(cl_1_uncertain, 'ascend');
 

% METHOD 3 - USING MOST DEVIATED
k = exp(4);
scaled = 0;
W = ridge(trained_Y, trained_X, k, scaled);
b = W(1);
w = W(2:end);

y_hat = untrained_X * w + b;
[all_dist_3,all_indicies_3] = sort(abs(y_hat), 'descend'); 

[~,d] = dsearchn(w',untrained_X);
[all_dist_1, all_indicies_1] = sort(d, 'ascend');


min_indicies = all_indicies_1;
% min_indicies_2 = all_indicies_2;
% Find difference to account for aggregate selections
num_selected = sum(sel_idx);
% Get k smallest posteriors
k = num_to_select - num_selected;
i_from_untrained = min_indicies(1:k);
unselected_indicies = find(~sel_idx);
i_select = unselected_indicies(i_from_untrained);
sel_idx(i_select) = true;
end

