function [ ccr ] = DT_test( mdl )
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
%    ccr - Correct Classification Rate: scalar
%------------- BEGIN CODE --------------

global TEST_X TEST_Y;

Y_hat = predict(mdl,TEST_X);
confmat = confusionmat(TEST_Y, Y_hat);
ccr = trace(confmat)/sum(sum(confmat));

end % END FUNCTION

