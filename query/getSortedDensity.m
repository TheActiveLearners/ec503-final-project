function [ trained_indicies ] = getSortedDensity(sel_idx)
%getSortedDensity Summary of this function goes here
%   Detailed explanation goes here


global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);
untrained_X = TRAIN_X(~sel_idx,:);
[untrain_n, untrain_m] = size(untrained_X);
% Clustering Kmeans
% D = pdist(untrained_X, 'squaredeuclidean');
% D = squareform( pdist(I') );       %'# euclidean distance between columns of I
% M = exp(-(1/10) * D);


% Train a NB on only trained data
svm_mdl = fitcsvm(trained_X,trained_Y,'Standardize',true,'KernelFunction','RBF',...
                'KernelScale','auto');
% Get Posterior distribution for each untrained X
[~,dist_to_decision] = predict(svm_mdl,untrained_X);
% 1st column - positive class posterior probabilities
cl_1_dist = dist_to_decision(:,1);
cl_1_uncertain = abs(cl_1_dist).^-1;

sigma = std(trained_X(:));
D = squareform( pdist(untrained_X, 'squaredeuclidean') );       %'# euclidean distance between columns of I
S = exp(-(D./(2 * sigma^2)));              %# similarity matrix between columns of I
phi_X = ((1/untrain_n)*sum(S,2)).^3;
[all_dist, trained_indicies] = sort(cl_1_uncertain.*phi_X, 'ascend');

end

