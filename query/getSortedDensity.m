function [ trained_indicies ] = getSortedDensity(sel_idx)
%SORTUS Summary of this function goes here
%   Detailed explanation goes here

% Train the model
[~,cluster_centers] = kmeans(untrained_X, 2);


[k,d] = dsearchn(cluster_centers, untrained_X);


end

