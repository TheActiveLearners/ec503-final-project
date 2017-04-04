% Authors: Connor Flynn, Dor Rubin, Jenna Warren
% Boston University EC503- Learning From Data
% Active Learning, Kernel Ridge Regresssion, Decision Trees
%
% Last revised: May 3, 2017

%% INITIALIZATION
% Set all the script settings
clear; close all; clc;
rng('default');
my_root     = '.'; % Change this to the directory where you put your code and data
data_dir    = [my_root '/data'];
results_dir = [my_root '/results'];
classifier_dir    = [my_root '/classifier'];
query_dir    = [my_root '/query'];
helper_dir    = [my_root '/helpers'];
addpath(data_dir, results_dir, classifier_dir, query_dir, helper_dir);

% MODELS
models = {
    {'alex.data', 'alex.label', 5000},...
    {'ibn_sina.data','ibn_sina.label', 10361},...
    {'B.data', 'B.label' 25000} % B.data may be unnecessary
    };

% MAKE SELECTION HERE
selection = 1; % CURRENTLY: ALEX
model_data  = models{selection}{1}
model_label  = models{selection}{2}
training_size  = models{selection}{3}

% QUERY STRATEGIES
strategies = {'random', 'vote_entropy', 'qbc'};

%% DATA PROCESSING
% Format the data based on selections above

if ~exist('all_data', 'var')
    fname = fullfile(data_dir,model_name);
    all_data = load(fname);
    fname = fullfile(data_dir,model_label);
    all_labels = load(fname);
    train_X = all_data(1:training_size,:);
    test_X  = all_data(training_size+1:end,:);
    train_Y = all_labels(1:training_size,:);
    test_Y  = all_labels(training_size+1:end,:);
end

%% TRAIN and TEST
% Perform incremental tests on the data

% Data set sizes - n: samples, d: features
[train_n,train_d] = size(train_X);
[test_n,test_d] = size(test_X);

% For each query strategy
for s = strategies
    % Save selected data points used in training
    krr_sel_point = zeros(train_n,1);
    dt_sel_point = zeros(train_n,1);

    % Randomly select the first point to be part of the training set
    krr_sel_point(1) = 1;
    dt_sel_point(1) = 1;   
    
    % For each remaining training point
    for j = 2:train_n
        
        % Train         
        krr_mdl = KRR_train(train_X, train_Y, krr_sel_point, s);
        dt_mdl = DT_train(train_X, train_Y, dt_sel_point, s);

        % Test
        krr_res = KRR_test(krr_mdl, test_X, test_Y);
        dt_res = DT_test(dt_mdl, test_X, test_Y);
        
    end % END FOR - training loop
    
end % END FOR - strategy loop




%% PLOT
