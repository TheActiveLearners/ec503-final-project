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
                  'KernelFunction','RBF',...
                  'Standardize',true);

% USING DISTANCE - PERFORMS BEST WITH ALEX AND IBN_SINA
[~,d_1] = dsearchn(svm_mdl.SupportVectors,untrained_X);
% finding points farther away works better with ALEX
[~, all_indicies_1] = sort(d_1, 'descend'); 

% USING KNN -- SAME AS dsearchn
% [~,d_2] = knnsearch(svm_mdl.SupportVectors,untrained_X);
% [~, all_indicies_2] = sort(d_2);


min_indicies = all_indicies_1;
% Find difference to account for aggregate selections
num_selected = numel(find(sel_idx));
% Get k smallest posteriors
k = num_to_select - num_selected;
i_s = min_indicies(1:k);
sel_idx(i_s) = true;
end

