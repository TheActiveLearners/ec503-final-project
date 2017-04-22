function [ sel_idx ] = UC(X, Y, sel_idx, num_to_select)
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
% untrained_Y = Y(~sel_idx); % Should not be using untrained_Y



% Train a SVM on only trained data
% Alex - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
% IBN - Adding KernelScale 'auto' and KernelFunction 'RBF' improved performance
svm_mdl = fitcsvm(trained_X,trained_Y,...
                  'ClassNames',unique(Y),...
                  'Standardize',true,...
                  'OutlierFraction',0.05);


% METHOD 1 - POSTERIOR 
% Get Posterior distribution for each untrained X
[score_mdl,~] = fitSVMPosterior(svm_mdl);
[~,post_dist] = predict(score_mdl,X);
% 1st column - positive class posterior probabilities
cl_1_post = post_dist(:,1);
cl_1_uncertain = abs(0.5 - cl_1_post);
[all_dist_1, all_indicies_2] = sort(cl_1_uncertain, 'ascend');
min_indices = all_indicies_2;

% [all_dist_1, all_indicies_3] = sort(cl_1_uncertain, 'descend');
%  
% METHOD 2 - USE K NEAREST
% [~,d] = dsearchn(svm_mdl.SupportVectors,untrained_X);
% [all_dist_2, all_indicies_2] = sort(d, 'ascend');
% [all_dist_3, all_indicies_3] = sort(d, 'descend');
% if any(svm_mdl.Beta)
%     d = untrained_X * svm_mdl.Beta + svm_mdl.Bias;
%     [all_dist_3, all_indicies_3] = sort(d, 'descend')
% else
%     all_indicies_3 = ~sel_idx;
% end



% METHOD 3 - USING MOST DEVIATED
% k = exp(3);
% scaled = 0;
% W = ridge(trained_Y, trained_X, k, scaled);
% b = W(1);
% w = W(2:end);
% 
% y_hat = untrained_X * w + b;
% [all_dist_3,all_indicies_2] = sort(abs(y_hat), 'descend'); 
% [all_dist_3,all_indicies_3] = sort(abs(y_hat), 'ascend'); 
% 


% [~,d] = dsearchn(mean(svm_mdl.SupportVectors), X);
% [all_dist_1, all_indices_1] = sort(d, 'ascend');

% Find difference to account for aggregate selections
% Get k smallest posteriors

i = 1;
while sum(sel_idx) < num_to_select
    if ~sel_idx(min_indices(i))
        sel_idx(min_indices(i)) = 1;
    end
    i = i + 1;
end

end

