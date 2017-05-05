function [ trained_indicies ] = getSortedUS( sel_idx, classifier )
%SORTUS Summary of this function goes here
%   Detailed explanation goes here

global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);
untrained_X = TRAIN_X(~sel_idx,:);

switch classifier
    case 'dt'
        % Uncertainty Sampling for Decision Trees
        % Train a DT on only trained data
        dt_mdl = fitctree(trained_X, trained_Y);

        % Get Posterior distribution for each untrained X
        [~,dist_to_hyp,~,~] = predict(dt_mdl,untrained_X);

        % 1st column - positive class posterior probabilities
        cl_1_dist = dist_to_hyp(:,1);
        cl_1_uncertain = abs(0.5 - cl_1_dist);
        [all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');
        
    case 'nb'
        % Uncertainty Sampling for Naive Bayes
        % Train a NB on only trained data
        nb_mdl = fitcnb(trained_X, trained_Y,'Distribution','RBF');
        % Get Posterior distribution for each untrained X
        [~,dist_to_hyp,~] = predict(nb_mdl,untrained_X);
        % 1st column - positive class posterior probabilities
        cl_1_dist = dist_to_hyp(:,1);
        cl_1_uncertain = abs(0.5 - cl_1_dist);
        [~, trained_indicies] = sort(cl_1_uncertain, 'ascend');
        
    case 'svm'
        % Uncertainty Sampling for KRR
        % Train a NB on only trained data
        svm_mdl = fitcsvm(trained_X,trained_Y,'Standardize',true,'KernelFunction','rbf',...
                        'KernelScale','auto');
        % Get Posterior distribution for each untrained X
        [~,dist_to_hyp] = predict(svm_mdl,untrained_X);
        % 1st column - positive class posterior probabilities
        cl_1_dist = dist_to_hyp(:,1);
        cl_1_uncertain = abs(cl_1_dist);
        [all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');
    case 'qda'
        % Uncertainty Sampling for QDA
        % Train a NB on only trained data
        trained_Y = repmat(trained_Y,2,1);
        trained_X = repmat(trained_X,2,1);
        qda_mdl = fitcdiscr(trained_X, trained_Y, 'DiscrimType', 'pseudoQuadratic');
        % Get Posterior distribution for each untrained X
        [label,post_dist, ml] = predict(qda_mdl,untrained_X);
        % 1st column - positive class posterior probabilities
        cl_1_dist = ml(:,1);
        cl_1_uncertain = abs(0.5 - cl_1_dist);
        [all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');        
        
    otherwise
            error('Not a valid classifier')    
end % END SWITCH

end

