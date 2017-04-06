function [ krr_mdl, sel_idx ] = KRR_train( X, Y, sel_idx, s , num_select)
% Kernel Ridge Regression
% Takes current state of model and returns a new one
%
% Syntax:  [ krr_mdl ] = KRR_train( X, Y, sel_idx, s, num_select)
% Inputs:
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%    x_s - selected training points: train_n by 1
%    s - query strategy: string
%    num_select - number of data points to train on X: scalar
%
% Outputs:
%    krr_mdl - New DT model: struct
%------------- BEGIN CODE --------------

% Updates the selection vector given the strategy, s
sel_idx = updateQueryIdx(s, sel_idx, num_select);

% Get only those rows from X and Y
trained_X = X(sel_idx,:);
trained_Y = Y(sel_idx,:);

trained_X_tilde = trained_X - mean(trained_X, 2);

% Train the model
k = 0;
krr_mdl = ridge(trained_Y,trained_X_tilde, k);

end

