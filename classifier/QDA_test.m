function [ ccr ] = QDA_test( mdl )
% QDA Test
% Takes test data X and corresponding labels Y and returns a CCR
%
% Syntax:  [ ccr ] = QDA_test( mdl)
% Inputs:
%    mdl - QDA Model: struct
%
% Outputs:
%    ccr - Correct Classification Rate: scalar
%------------- BEGIN CODE --------------

global TEST_X TEST_Y;

Y_hat = predict(mdl,TEST_X);
confmat = confusionmat(TEST_Y, Y_hat);
ccr = trace(confmat)/sum(sum(confmat));

end % END FUNCTION

