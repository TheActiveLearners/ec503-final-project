%% Active Learning with Kernel Ridge Regresssion and Decision Trees
% Authors:
% Connor Flynn
% Dor Rubin
% Jenna Warren
% Boston University EC503- Learning From Data
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

% QUERY STRATEGIES
strategies = {'random', 'vote_entropy', 'qbc'};

% MAKE SELECTION HERE
% Model Selection
mdl_select = 2; % CURRENTLY: ALEX
model_data  = models{mdl_select}{1}
model_label  = models{mdl_select}{2}
training_size  = models{mdl_select}{3}

% Strategy Selection
strat_select = 1; % CURRENTLY: RANDOM
s = strategies{strat_select};


%% DATA PROCESSING
% Format the data based on selections above

if ~exist('all_data', 'var')
    fname = fullfile(data_dir,model_data);
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

% Save selected data points used in training
krr_sel_point = false(train_n,1);
dt_sel_point = false(train_n,1);

% Log scale for number of points to use in X
increments = floor(log2(train_n));
num_samples = 2.^(0:increments); % 1,2,4,8...4096,5000
num_samples(end + 1) = train_n;

% Store results of Classifier
dt_results = zeros(length(num_samples), 1);
krr_results = ones(length(num_samples), 1) * .5;

% For each remaining training point
for iter_samples = num_samples
    i = find(iter_samples == num_samples);
    % TRAIN
    % *_sel_point is redefined after each iteration
    [dt_mdl, dt_sel_point] = DT_train(train_X, train_Y, dt_sel_point, s, iter_samples);
    [krr_mdl, krr_sel_point] = KRR_train(train_X, train_Y, krr_sel_point, s, iter_samples);
    
    % TEST
    dt_results(i)  = DT_test(dt_mdl, test_X, test_Y);
    krr_results(i) = KRR_test(krr_mdl, test_X, test_Y);
    
end % END FOR - training loop


%% PLOT
close all;
x = num_samples;
y = horzcat(dt_results, krr_results);
legend = {'dt_{rand}', 'krr_{rand}'};
logScalePlot(x,'Training Size',...
             y,'CCR',...
             legend,...
             'Plot of CCR for training size between 2^{-5} to 2^{15}');

