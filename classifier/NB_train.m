function [ nb_mdl ] = NB_train( X, Y, sel_idx)
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
%    nb_mdl - New NB model: struct
%------------- BEGIN CODE --------------


% Get only those rows from X and Y
trained_X = X(sel_idx,:);
trained_Y = Y(sel_idx,:);

% Train the model
nb_mdl = fitcnb(trained_X, trained_Y,'Distribution','kernel');

end

