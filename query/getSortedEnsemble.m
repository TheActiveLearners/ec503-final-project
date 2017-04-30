function [ trained_indicies ] = getSortedEnsemble( sel_idx )
%getSortedEnsemble Summary of this function goes here
%   Detailed explanation goes here

global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);
untrained_X = TRAIN_X(~sel_idx,:);
% untrained_Y = TRAIN_Y(~sel_idx,:);


% Decision Trees Classifier
% Train a DT on only trained data
% boost_mdl = fitensemble(trained_X,trained_Y,'Subspace',50,'Discriminant','Type','classification');
boost_mdl = fitensemble(trained_X,trained_Y,'AdaBoostM1',100,'Tree','Type','classification');

[labels,scores] = predict(boost_mdl, untrained_X);

% foo = confusionmat(labels_1, untrained_Y);
% bar = confusionmat(labels_2, untrained_Y);

cl_1_post = scores(:,1);
cl_1_uncertain = abs(cl_1_post);

[all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');


end

