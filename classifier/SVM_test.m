function [ ccr ] = SVM_test( mdl, X, Y )
% SVM Test
% Takes test data X and corresponding labels Y and returns a CCR
%
% Syntax:  [ ccr ] = SVM_test( mdl, X, Y )
% Inputs:
%    mdl - SVM Model: struct
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%
% Outputs:
%    ccr - Correct Classification Rate: scalar
%------------- BEGIN CODE --------------


Y_hat = predict(mdl,X);
confmat = confusionmat(Y, Y_hat);
ccr = trace(confmat)/sum(sum(confmat));

end % END FUNCTION

