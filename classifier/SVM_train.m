function [ svm_mdl ] = SVM_train( sel_idx)
% SVM Train
% Takes current state of model and returns a new one
%
% Syntax:  [ svm_mdl ] = DT_train( sel_idx )
% Inputs:
%    sel_idx - selected training points: train_n by 1
%
% Outputs:
%    svm_mdl - New SVM model: struct
%------------- BEGIN CODE --------------

global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);

% Train the model
svm_mdl = fitcsvm(trained_X,trained_Y,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');

end

