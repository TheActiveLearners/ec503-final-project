function [ dt_mdl ] = DT_train(sel_idx)
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

global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);

% Train the model
dt_mdl = fitctree(trained_X,trained_Y);

end

