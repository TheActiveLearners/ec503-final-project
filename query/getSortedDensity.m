function [ trained_indicies ] = getSortedDensity(sel_idx)
%getSortedDensity Summary of this function goes here
%   Detailed explanation goes here


global TRAIN_X;

% Get only those rows from X and Y
untrained_X = TRAIN_X(~sel_idx,:);
[untrain_n, ~] = size(untrained_X);

sigma = std(untrained_X(:));
D = squareform( pdist(untrained_X, 'squaredeuclidean') );       %'# euclidean distance between columns of I
S = exp(-(D./(2 * sigma^2)));             %# similarity matrix between columns of I
phi_X = (1-(1/untrain_n)*sum(S,2));
[~, trained_indicies] = sort(phi_X, 'ascend');

end

