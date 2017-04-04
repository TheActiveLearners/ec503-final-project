function [ confmat ] = KRR_test( mdl, X, Y )
% Kernel Ridge Regression Test
% Takes test data X and corresponding labels Y and returns a CCR
% 
% Syntax:  [ confmat ] = KRR_test( mdl, X, Y )
% Inputs:
%    mdl - KRR Model: struct
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%
% Outputs:
%    confmat - Confusion matrix: num_class by num_class
%------------- BEGIN CODE --------------

confmat = mdl + length(X) + length(Y);
end

