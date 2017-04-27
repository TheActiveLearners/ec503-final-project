function [ trained_indicies ] = getSortedCluster( trained_X,untrained_X, classifier )
%SORTUS Summary of this function goes here
%   Detailed explanation goes here

% Train the model
[~,cluster_centers] = kmeans(untrained_X, 2);


[k,d] = dsearchn(cluster_centers, untrained_X);


end

