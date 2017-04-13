function [ dt_results, krr_results ] = trainAndTest(strategy, num_samples, train_X, train_Y, test_X, test_Y)
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

tmax = 1;
if strcmp('random', strategy)
    tmax = 10;
end

% Data set sizes - n: samples, d: features
[train_n,~] = size(train_X);
% [~,~] = size(test_X);

% Initialize temporary array to hold results     
    dt_temp_results = zeros(tmax, length(num_samples));
    krr_temp_results = zeros(tmax, length(num_samples));

for t = 1:tmax
    % Print tmax to console
    t
    
    % Save selected data points used in training
    sel_idx = false(train_n,1);
    
    for iter_samples = num_samples
        i = find(iter_samples == num_samples);
        
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

% Return results for each Classifier
dt_results = mean(dt_temp_results);
krr_results = mean(krr_temp_results);

end % END FUNCTION

