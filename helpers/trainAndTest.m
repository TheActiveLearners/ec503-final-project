function [ dt_results, krr_results ] = trainAndTest(strategy, sample_steps, train_X, train_Y, test_X, test_Y, select_mdl, scale)
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
%------------- BEGIN CODE --------------

% Set the max number of trials -- must be greater than 1
trials = 1;

% Data set sizes - n: samples, d: features
[train_n,~] = size(train_X);

% Initialize temporary array to hold results
dt_temp_results = zeros(trials, length(sample_steps));
krr_temp_results = zeros(trials, length(sample_steps));

% For each trial
for t = 1:trials
    t
    % Reset all the selected indicies to false
    sel_idx = false(train_n,1);
    
    % iter_samples is the max number of training points
    for iter_samples = sample_steps
        i = find(iter_samples == sample_steps);
        % Updates the selection vector given the strategy, s
        sel_idx = updateQueryIdx(strategy, sel_idx, iter_samples, train_X, train_Y);
        % TRAIN
        % *_sel_point is redefined after each iteration
        dt_mdl  = DT_train(train_X, train_Y, sel_idx);
        krr_mdl = KRR_train(train_X, train_Y, sel_idx);
        
        % TEST
        dt_temp_results(t,i)  = DT_test(dt_mdl, test_X, test_Y);
        krr_temp_results(t,i) = KRR_test(krr_mdl, test_X, test_Y);
        
    end % END FOR - training loop
    
end % END FOR - repetition loops

if trials > 1
    dt_results = mean(dt_temp_results);
    krr_results = mean(krr_temp_results);
else
    dt_results = dt_temp_results;
    krr_results = krr_temp_results;
end


end % END FUNCTION

