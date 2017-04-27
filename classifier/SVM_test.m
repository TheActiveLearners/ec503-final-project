function [ ccr ] = SVM_test( mdl )
% SVM Test
% Takes test data X and corresponding labels Y and returns a CCR
%
% Syntax:  [ ccr ] = SVM_test( mdl, X, Y )
% Inputs:
%    mdl - SVM Model: struct
%
% Outputs:
%    ccr - Correct Classification Rate: scalar
%------------- BEGIN CODE --------------

global TEST_X TEST_Y;

Y_hat = predict(mdl,TEST_X);
confmat = confusionmat(TEST_Y, Y_hat);
ccr = trace(confmat)/sum(sum(confmat));

end % END FUNCTION

