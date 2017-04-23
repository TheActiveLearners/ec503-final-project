function [ ccr ] = KMEANS_test(k_idx, c, X, Y)
% Kmeans clustering Test
% Takes test data X and corresponding labels Y and returns a CCR
%
% Syntax:  [ ccr ] = KMEANS_test( idx,c, X, Y )
% Inputs:
%    idx - cluster that each data point has been assigned to
%    c - center of clusters
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%
% Outputs:
%    ccr - Correct Classification Rate: scalar
%------------- BEGIN CODE --------------


% Determine which label it refers to
distances = zeros(length(X),2);
for i = 1:length(X)
    this_point_c1 = [X(i,:); c(1,:)];
    this_point_c2 = [X(i,:); c(2,:)];
distances(i,1) = pdist(this_point_c1,'euclidean');
distances(i,2) = pdist(this_point_c2, 'euclidean');
end
[~,Y_hat] = min(distances,[],2);

Y_hat(Y_hat == 1) = -1; 
Y_hat(Y_hat == 2) = 1;

confmat = confusionmat(Y, Y_hat);
ccr = trace(confmat)/sum(sum(confmat));

end

