function [ dt_mdl, sel_idx ] = DT_train( X, Y, sel_idx, s , num_select)
% Decision Tree Train
% Takes current state of model and returns a new one
% 
% Syntax:  [ krr_mdl ] = KRR_train( X, Y, x_s, s)
% Inputs:
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%    x_s - selected training points: train_n by 1
%    s - query strategy: string
%    num_select - number of data points to train on X: scalar
%
% Outputs:
%    dt_mdl - New DT model: struct
%------------- BEGIN CODE --------------


% Updates the selection vector given the strategy, s
sel_idx = updateQueryIdx(s, sel_idx, num_select);

% Get only those rows from X and Y
trained_X = X(sel_idx,:);
trained_Y = Y(sel_idx,:);

% Train the model
dt_mdl = fitctree(trained_X,trained_Y);

end

