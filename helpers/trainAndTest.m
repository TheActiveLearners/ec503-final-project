function [ final_results ] = trainAndTest(st1, st2, sample_steps, trials)
% trainAndTest
% Runs train and test depending on the strategy
%
% Syntax:  [ dt_results, krr_results ] = trainAndTest(strategy, num_samples,...
%                                                     train_X, train_Y,...
%                                                     test_X, test_Y)
% Inputs:
%    strategy - query strategy: string
%    num_samples - X data: num_samples by num_features
%    train_X - X data for the training set: train_n x train_m
%    train_Y - Y labels for the training set: train_n by 1
%    test_X - X data for the test set: test_n x test_m
%    test_Y - Y labels for the test set: test_n by 1
%
% Outputs:
%    dt_result - CCR for each num training samples: tmax x num_samples
%    krr_result - CCR for each num training samples: tmax x num_samples
%    kmeans_results - CCR for each num training samples: tmax x num_samples

%------------- BEGIN CODE --------------

global TRAIN_X;

% Data set sizes - n: samples, d: features
[train_n,~] = size(TRAIN_X);

% Initialize temporary array to hold results
final_results.cl1_results_st1 = zeros(trials, length(sample_steps));
final_results.cl2_results_st1 = zeros(trials, length(sample_steps));

final_results.cl1_results_st2 = zeros(trials, length(sample_steps));
final_results.cl2_results_st2 = zeros(trials, length(sample_steps));

% For each trial
for t = 1:trials
    t
    % Reset all the selected indicies to false
    % cl1 == 'dt'     
    cl1_sel_idx_st1 = false(train_n,1);
    cl2_sel_idx_st1 = false(train_n,1);
    
    % cl2 == 'svm'
    cl1_sel_idx_st2 = false(train_n,1);
    cl2_sel_idx_st2 = false(train_n,1);
    
    % iter_samples is the max number of training points
    for iter_samples = sample_steps
        i = find(iter_samples == sample_steps);
        % Updates the selection vector given the strategy
        cl1_sel_idx_st1 = updateQueryIdx(st1, 'qda', cl1_sel_idx_st1, iter_samples);
        % if first iteration, copy seed from dt_sel to nb_sel - both start at same place
        if i == 1
            cl2_sel_idx_st1 = cl1_sel_idx_st1;
            cl1_sel_idx_st2 = cl1_sel_idx_st1;
            cl2_sel_idx_st2 = cl1_sel_idx_st1;
        else
            cl1_sel_idx_st2 = updateQueryIdx(st2, 'qda', cl1_sel_idx_st2, iter_samples);
            cl2_sel_idx_st1 = updateQueryIdx(st1, 'svm', cl2_sel_idx_st1, iter_samples);
            cl2_sel_idx_st2 = updateQueryIdx(st2, 'svm', cl2_sel_idx_st2, iter_samples);
        end
        
        % TRAIN
        % *_sel_point is redefined after each iteration
        cl1_mdl_st1  = QDA_train(cl1_sel_idx_st1);
        cl2_mdl_st1  = SVM_train(cl2_sel_idx_st1);
        
        cl1_mdl_st2  = QDA_train(cl1_sel_idx_st2);
        cl2_mdl_st2  = SVM_train(cl2_sel_idx_st2);
        
        % TEST
        final_results.cl1_results_st1(t,i) = QDA_test(cl1_mdl_st1);
        final_results.cl2_results_st1(t,i) = SVM_test(cl2_mdl_st1);
        
        final_results.cl1_results_st2(t,i) = QDA_test(cl1_mdl_st2);
        final_results.cl2_results_st2(t,i) = SVM_test(cl2_mdl_st2);
        
    end % END FOR - training loop
    
end % END FOR - trial loops

end % END FUNCTION

