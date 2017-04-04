function [ confmat ] = DT_test( mdl, X, Y )
% Decision Tree Test
% Takes test data X and corresponding labels Y and returns a CCR
% 
% Syntax:  [ ccr ] = DT_test( mdl, X, Y )
% Inputs:
%    mdl - Decision Tree Model: struct
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%
% Outputs:
%    confmat - Confusion matrix: num_class by num_class
%------------- BEGIN CODE --------------

Y_hat = predict(mdl,X);
confmat = confusionmat(Y, Y_hat);

end

