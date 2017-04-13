function [ krr_mdl, sel_idx ] = KRR_train( X, Y, sel_idx)
% Kernel Ridge Regression
% Takes current state of model and returns a new one
%
% Syntax:  [ krr_mdl ] = KRR_train( X, Y, sel_idx, s, num_select)
% Inputs:
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%    sel_idx - selected training points: train_n by 1
%
% Outputs:
%    krr_mdl - Vector of feature coefficients: num_features x 1
%------------- BEGIN CODE --------------


% Ridge Regression centered around zero
trained_X = zeros(size(X));
trained_Y = zeros(size(Y));
% Reveal rows that were selected by the query
trained_X(sel_idx,:) = X(sel_idx,:);
trained_Y(sel_idx,:) = Y(sel_idx,:);

% Train the model
lambda = exp(3); 
scaled = 0;
krr_mdl = ridge(trained_Y,trained_X, lambda, scaled);

end

