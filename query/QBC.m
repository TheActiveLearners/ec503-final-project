function [ sel_idx ] = QBC(X, Y, sel_idx, num_to_select)
% Uncertainty Sampling
% Takes test data X and returns a single data point
%
% Syntax:  [ sel_idx ] = UC(X, Y, sel_idx);
% Inputs:
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%    num_select - number of data points to train on X: scalar
%
% Outputs:
%    new_sel_idx - logical array of selected indicies: num_sample x 1
%------------- BEGIN CODE --------------

% Get only those rows from X and Y
trained_X = X(sel_idx,:);
trained_Y = Y(sel_idx,:);
untrained_X = X(~sel_idx,:);
untrained_Y = Y(~sel_idx);


% Train a SVM on only trained data
% Alex - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
% IBN - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
mdl = fitcsvm(trained_X,trained_Y,...
                  'ClassNames',unique(Y),...
                  'KernelFunction','RBF',...
                  'Standardize',true);

% USING DISTANCE - PERFORMS BEST WITH ALEX AND IBN_SINA      
[~,d] = dsearchn(mdl.SupportVectors,untrained_X);
[all_dist_1, all_indicies_1] = sort(d);


% Find the points that are furthest away from regression line
% lambda = exp(3); 
% scaled = 0;
% W = ridge(trained_Y,trained_X, 0, 1);
% b = W(1);
% w = W(2:end);
% r = untrained_X * W;
% [all_dist_1, all_indicies_1] = sort(abs(r), 'ascend'); 


% USING DISTANCE - PERFORMS BEST WITH ALEX AND IBN_SINA
% [~,d_1] = dsearchn(svm_mdl.SupportVectors,untrained_X);
% finding points farther away works better with ALEX
% [all_dist_2, all_indicies_2] = sort(d_1, 'ascend'); 



% USING POSTERIOR
% compact_mdl = compact(mdl);
% % Get Posterior distribution for each untrained X
% [score_mdl,~] = fitPosterior(compact_mdl,...
%     untrained_X, untrained_Y);
% [~,post_dist] = predict(score_mdl,untrained_X);
% % 1st column - positive class posterior probabilities
% cl_1_post = post_dist(:,1);
% cl_1_uncertain = abs(0.5 - cl_1_post);
% [all_dist_2, all_indicies_2] = sort(cl_1_uncertain, 'ascend');

% COMBINE -- DOES NOT WORK
% min_indicies_1 = all_indicies_1(min(all_dist_1) == all_dist_1);
% min_indicies_2 = all_indicies_2(min(all_dist_2) == all_dist_2);
% both = intersect(min_indicies_1, min_indicies_2);
% min_indicies = vertcat(both,...
%                 setdiff(min_indicies_2, both),...
%                 setdiff(min_indicies_1, both),...
%                 setdiff(all_indicies_2, union(min_indicies_1,min_indicies_2)));


min_indicies = all_indicies_1;
% Find difference to account for aggregate selections
num_selected = numel(find(sel_idx));
% Get k smallest posteriors
k = num_to_select - num_selected;
i_s = min_indicies(1:k);
sel_idx(i_s) = true;
end

