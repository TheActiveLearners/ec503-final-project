function [ krr_mdl,  ] = KRR_train( X, Y, x_s, s)
% Kernel Ridge Regression Train
% Takes current state of model and returns a new one
% 
% Syntax:  [ krr_mdl ] = KRR_train( X, Y, x_s, s)
% Inputs:
%    X - X data: train_n by num_features
%    Y - Y labels: num_samples by 1
%    x_s - selected training points: train_n by 1
%    s - query strategy: string
%
% Outputs:
%    krr_mdl - New KRR model: struct
%------------- BEGIN CODE --------------

% Find the zero entry in x_s -> the jth data point selected for training
xj = find(~x_s, 1, 'first'); % returns index
x_s(xj) = getNewX(s); % assign new x index value at next available spot


krr_mdl = length(X) + length(Y);


end

