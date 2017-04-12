function [ dt_results, krr_results ] = trainAndTest(strategy, num_samples, train_X, train_Y, test_X, test_Y)
%TRAINANDTEST Summary of this function goes here
%   Detailed explanation goes here

% Data set sizes - n: samples, d: features
[train_n,train_d] = size(train_X);
[test_n,test_d] = size(test_X);

% Store results of Classifier
dt_results = zeros(length(num_samples), 1);
krr_results = ones(length(num_samples), 1);

% Save selected data points used in training
krr_sel_point = false(train_n,1);
dt_sel_point = false(train_n,1);

for iter_samples = num_samples
    i = find(iter_samples == num_samples);
    % TRAIN
    % *_sel_point is redefined after each iteration
    [dt_mdl, dt_sel_point] = DT_train(train_X, train_Y, dt_sel_point, strategy, iter_samples);
    [krr_mdl, krr_sel_point] = KRR_train(train_X, train_Y, krr_sel_point, strategy, iter_samples);
    
    % TEST
    dt_results(i)  = DT_test(dt_mdl, test_X, test_Y);
    krr_results(i) = KRR_test(krr_mdl, test_X, test_Y);
    
end % END FOR - training loop

end

