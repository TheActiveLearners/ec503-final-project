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
dir_data       = './data';
dir_results    = './results';
dir_classifier = './classifier';
dir_query      = './query';
dir_helper     = './helpers';
addpath(dir_data, dir_results, dir_classifier, dir_query, dir_helper);

% MODELS
models = {
    {'alex', 'alex.data', 'alex.label', 5000},...
    {'ibn_sina', 'ibn_sina.data','ibn_sina.label', 10361}
    };

% MAKE SELECTION HERE
% Model Selection
select_mdl = input('Which dataset (1) ALEX (2) IBN_SINA ?  ');
model_name = models{select_mdl}{1}
model_data  = models{select_mdl}{2};
model_label  = models{select_mdl}{3};
training_size  = models{select_mdl}{4};

% Load Random query data
% addpath(strcat('./results/', model_name));
% files = dir(strcat('./results/', model_name, '/*.mat'));
% for i=1:length(files)
%     eval(['load ' files(i).name]);
% end


% QUERY STRATEGIES
strategies = {'vote_entropy', 'qbc', 'uc', 'random'};


% Strategy Selection
select_strat = input('Which strategy (1) Vote (2) QBC (3) Uncertainty Sampling (4) Random ?  ');
strategy = strategies{select_strat}


%% DATA PROCESSING
% Format the data based on selections above

if ~exist('all_data', 'var')
    fname = fullfile(dir_data,model_data);
    all_data = load(fname);
    fname = fullfile(dir_data,model_label);
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


% Log scale for number of points to use in X
increments = floor(log2(train_n));
num_samples = 2.^(0:increments); % 1,2,4,8...4096,train_n
num_samples(end + 1) = train_n;


% For each remaining training point
[ dt_results_strat, krr_results_strat ] =...
    trainAndTest(strategy, num_samples,train_X, train_Y,test_X, test_Y);


%% PLOT
close all;
x = num_samples;
y = horzcat(dt_results_random', krr_results_random',...
              dt_results_strat', krr_results_strat');

        
legend = {'dt_{random}', 'krr_{random}',...
          strcat('dt_{',strategy,'}'), strcat('krr_{',strategy,'}')};
logScalePlot(x,'Training Size',...
    y,'CCR',...
    legend,...
    'Plot of CCR for training size between 1 to max training size');
