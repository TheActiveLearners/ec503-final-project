function [ trained_indicies ] = getSortedUS( trained_X, trained_Y, untrained_X, classifier )
%SORTUS Summary of this function goes here
%   Detailed explanation goes here

switch classifier
    case 'dt'
        % Uncertainty Sampling for Decision Trees
        % Train a DT on only trained data
        dt_mdl = fitctree(trained_X, trained_Y);

        % Get Posterior distribution for each untrained X
        [~,post_dist,~,~] = predict(dt_mdl,untrained_X);

        % 1st column - positive class posterior probabilities
        cl_1_post = post_dist(:,1);
        cl_1_uncertain = abs(0.5 - cl_1_post);
        [all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');
        
    case 'nb'
        % Uncertainty Sampling for Naive Bayes
        % Train a NB on only trained data
        nb_mdl = fitcnb(trained_X, trained_Y,'Distribution','kernel');
        % Get Posterior distribution for each untrained X
        [~,post_dist,~] = predict(nb_mdl,untrained_X);
        % 1st column - positive class posterior probabilities
        cl_1_post = post_dist(:,1);
        cl_1_uncertain = abs(0.5 - cl_1_post);
        [all_dist, trained_indicies] = sort(cl_1_uncertain, 'ascend');
    otherwise
            error('Not a valid classifier')    
end % END SWITCH

end

