function [ ccr ] = KRR_test( W, X, Y )
% Kernel Ridge Regression Test
% Takes test data X and corresponding labels Y and returns a CCR
%
% Syntax:  [ ccr ] = KRR_test( W, X, Y )
% Inputs:
%    W - vector of coefficients: struct
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%
% Outputs:
%    ccr - Correct Classification Rate: scalar
%------------- BEGIN CODE --------------

% Plug into Ridge Function
b = W(1);
w = W(2:end);
r = X * w + b;

% Determine which label it refers to
Y_hat = sign(r);

confmat = confusionmat(Y, Y_hat);
ccr = trace(confmat)/sum(sum(confmat));

end

