function [ kmean_idx, C, sel_idx ] = KMEANS_train( X, sel_idx)
% Kernel Ridge Regression
% Takes current state of model and returns a new one
%
% Syntax:  [ kmean_mdl ] = KMEANS_train( X, sel_idx, s, num_select)
% Inputs:
%    X - X data: num_samples by num_features
%    sel_idx - selected training points: train_n by 1
%
% Outputs:
%    kmean_mdl - 
%------------- BEGIN CODE --------------


% Ridge Regression centered around zero
trained_X = zeros(size(X));
trained_Y = zeros(size(Y));
% Reveal rows that were selected by the query
trained_X(sel_idx,:) = X(sel_idx,:);
trained_Y(sel_idx,:) = Y(sel_idx,:);

% Train the model
[kmean_idx,C] = kmeans(trained_X, 2);

end