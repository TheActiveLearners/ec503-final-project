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


% Train a SVM on only trained data
% Alex - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
% IBN - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
svm_mdl = fitcsvm(trained_X,trained_Y,...
                  'ClassNames',unique(Y),...
                  'Standardize',true,...
                  'OutlierFraction',0.05);

% compact_mdl = compact(svm_mdl);
% Get Posterior distribution for each untrained X
[score_mdl,foo] = fitSVMPosterior(svm_mdl);
[bar,post_dist] = predict(score_mdl,untrained_X);
% 1st column - positive class posterior probabilities
cl_1_post = post_dist(:,1);
cl_1_uncertain = abs(0.5 - cl_1_post);
[all_dist_2, all_indicies_2] = sort(cl_1_uncertain, 'descend');
              
              
% Find the points that are furthest away from regression line
% lambda = exp(3); 
% scaled = 0;
% W = ridge(trained_Y,trained_X, 0, 1);
% b = W(1);
% w = W(2:end);
% r = untrained_X * W;
% [all_dist_1, all_indicies_1] = sort(abs(r), 'ascend'); 


% USING DISTANCE - PERFORMS BEST WITH ALEX AND IBN_SINA
% [~,d_1] = dsearchn(svm_mdl.SupportVectors,untrained_X);
% finding points farther away works better with ALEX
% [all_dist_2, all_indicies_2] = sort(d_1, 'ascend'); 



min_indicies = all_indicies_2;
% min_indicies_2 = all_indicies_2;
% Find difference to account for aggregate selections
num_selected = numel(find(sel_idx));
% Get k smallest posteriors
k = num_to_select - num_selected;
i_s = min_indicies(1:k);
sel_idx(i_s) = true;
end

