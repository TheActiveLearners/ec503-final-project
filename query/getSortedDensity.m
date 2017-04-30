function [ trained_indicies ] = getSortedDensity(sel_idx)
%getSortedDensity Summary of this function goes here
%   Detailed explanation goes here


global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
untrained_X = TRAIN_X(~sel_idx,:);


% Train the model
[~,cluster_centers] = kmeans(untrained_X, 2);

[foo,dist] = dsearchn(cluster_centers, untrained_X);

[all_dist, trained_indicies] = sort(dist, 'ascend');

end

