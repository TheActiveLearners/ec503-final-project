function [ svm_mdl ] = SVM_train( X, Y, sel_idx)
% Decision Tree Train
% Takes current state of model and returns a new one
%
% Syntax:  [ dt_mdl ] = DT_train( X, Y, sel_idx, s, num_select)
% Inputs:
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%    sel_idx - selected training points: train_n by 1
%
% Outputs:
%    dt_mdl - New DT model: struct
%------------- BEGIN CODE --------------


% Get only those rows from X and Y
trained_X = X(sel_idx,:);
trained_Y = Y(sel_idx,:);

% Train the model
svm_mdl = fitcsvm(trained_X,trained_Y,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');

end

