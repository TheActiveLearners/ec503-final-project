function [ trained_indicies ] = getSortedDensityUS(sel_idx, classifier)
%getSortedDensity Summary of this function goes here
%   Detailed explanation goes here


global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);
untrained_X = TRAIN_X(~sel_idx,:);
[untrain_n, ~] = size(untrained_X);

switch classifier
    case 'svm'
        % Train a SVM on only trained data
        svm_mdl = fitcsvm(trained_X,trained_Y,'Standardize',true,'KernelFunction','RBF',...
            'KernelScale','auto');
        % Get Posterior distribution for each untrained X
        [~,dist_to_decision] = predict(svm_mdl,untrained_X);
        % 1st column - positive class posterior probabilities
        cl_1_dist = dist_to_decision(:,1);
        cl_1_uncertain = abs(cl_1_dist);
    case 'qda'
        trained_Y = repmat(trained_Y,2,1);
        trained_X = repmat(trained_X,2,1);
        qda_mdl = fitcdiscr(trained_X, trained_Y, 'DiscrimType', 'pseudoQuadratic');
        % Get Posterior distribution for each untrained X
        [label,post_dist, ml] = predict(qda_mdl,untrained_X);
        % 1st column - positive class posterior probabilities
        cl_1_dist = ml(:,1);
        % 1st column - positive class posterior probabilities
        cl_1_uncertain = abs(cl_1_dist - 0.5);
    otherwise
        error('Not a valid classifier')
end

% low = min(pre_cl_1_uncertain);
% high = max(pre_cl_1_uncertain);
% cl_1_uncertain = (pre_cl_1_uncertain - low)/(high - low);

cl_1_uncertain = abs(cl_1_uncertain).^-1;
sigma = std(untrained_X(:));
D = squareform( pdist(untrained_X, 'squaredeuclidean') );       %'# euclidean distance between columns of I
S = exp(-(D./(2 * sigma^2)));             %# similarity matrix between columns of I
phi_X = (1-(1/untrain_n)*sum(S,2)).^3;
[all_dist, trained_indicies] = sort(cl_1_uncertain.*phi_X, 'ascend');

end

