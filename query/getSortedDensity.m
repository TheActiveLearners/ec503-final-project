function [ trained_indicies ] = getSortedDensity(sel_idx)
%getSortedDensity Summary of this function goes here
%   Detailed explanation goes here


global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);
untrained_X = TRAIN_X(~sel_idx,:);

% Clustering Kmeans
% unique_untrained_X = setdiff(untrained_X, trained_X, 'rows');
% [u_n, u_t] = size(unique_untrained_X);
% [idx,C,sumd,D] = kmeans(untrained_X,u_n);
% [foo, bar] = sort(sumD, 'ascend');


% Uncertainty Sampling for QDA
% Train a NB on only trained data
% trained_Y = repmat(trained_Y,2,1);
% trained_X = repmat(trained_X,2,1);
% qda_mdl = fitcdiscr(trained_X, trained_Y, 'DiscrimType', 'pseudoQuadratic');
% % Get Posterior distribution for each untrained X
% [label,post_dist, cost] = predict(qda_mdl,untrained_X);
% % 1st column - positive class posterior probabilities
% cl_1_post = post_dist(:,1);
% cl_1_uncertain = abs(0.5 - cl_1_post);
% [all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');



end

