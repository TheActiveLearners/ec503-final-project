function [ disc_mdl ] = QDA_train(sel_idx)
% QDA Train
% Takes selection indicies and returns a model
%
% Syntax:  [ disc_mdl ] = QDA_train(sel_idx)
% Inputs:
%    sel_idx - selected training points: train_n by 1
%
% Outputs:
%    dt_mdl - New QDA model: struct
%------------- BEGIN CODE --------------

global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);

trained_Y = repmat(trained_Y,2,1);
trained_X = repmat(trained_X,2,1);
disc_mdl = fitcdiscr(trained_X, trained_Y, 'DiscrimType', 'pseudoQuadratic');

end

