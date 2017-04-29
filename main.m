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
    {'alex', 'alex.data', 'alex.label'},...
    {'ibn_sina', 'ibn_sina.data','ibn_sina.label'},...
    {'spambase', 'spambase.data','spambase.label'},...
    {'linSep', 'linSep_data.mat','linSep_label.mat'},...
    {'nonLinSep','nonLinSep_data.mat','nonLinSep_label.mat'},...
    {'nonLinSep2','nonLinSep_data2.mat','nonLinSep_label2.mat'}
    };

% MAKE SELECTION HERE
% Model Selection
% select_mdl = input('Which dataset (1) ALEX (2) IBN_SINA ?  ');
select_mdl = 1;
model_name = models{select_mdl}{1}
model_data  = models{select_mdl}{2};
model_label  = models{select_mdl}{3};

% SCALE
scales = {'log', 'linear'};

% Scale Selection
% select_strat = input('Which scale (1) log (2) linear ?  ');
select_scale = 1;
scale = scales{select_scale}


% QUERY STRATEGIES
strategies = {'vote_entropy', 'qbc',...
              'pureUS', 'mixedUS',....
              'pureCluster', 'mixedCluster',...
              'pureEnsemble', 'mixedEnsemble',...
              'random' };

% Strategy Selection
% select_strat = input('Which strategy (1) Vote (2) QBC (3) Uncertainty Sampling (4) Random ?  ');
select_strat = 8;
strategy = strategies{select_strat}

% Select number of trials
trials = 2;

%% DATA PROCESSING
% Format the data based on selections above

fname = fullfile(dir_data,model_data);
all_data = load(fname);
if(class(all_data) == 'struct')
    switch select_mdl
        case 5
            all_data = all_data.X_nonLinSep;
        case 4
            all_data = all_data.X_linSep;
        case 6
            all_data = all_data.X_nonLinSep2;
    end
end
[sample_steps,~] = size(all_data);
fname = fullfile(dir_data,model_label);
all_labels = load(fname);
if(class(all_labels) == 'struct')
    switch select_mdl
        case 5
            all_labels = all_labels.Y_nonLinSep;
        case 4
            all_labels = all_labels.Y_linSep;
        case 6
            all_labels = all_labels.Y_nonLinSep2;
    end
end

cv = cvpartition(sample_steps, 'Kfold', 2);

global TRAIN_X TEST_X TRAIN_Y TEST_Y;

TRAIN_X = all_data(training(cv, 2),:);
TEST_X  = all_data(test(cv, 2),:);
TRAIN_Y = all_labels(training(cv, 2),:);
TEST_Y  = all_labels(test(cv,2),:);


%% TRAIN and TEST
% Perform incremental tests on the data

% Data set sizes - n: samples, d: features
[train_n,train_d] = size(TRAIN_X);
[test_n,test_d] = size(TEST_X);

% Set the Scale for the tests
% set seed = 1/misclassication error ~ 8
seed = 8; % used for both linear and log
increment = 4; % used for linear only
max_sample = 100; % used for linear only
sample_steps = setScale(scale, train_n, seed, increment, max_sample);

% Load Random query data
% [dt_results_random, krr_results_random] = loadRandomData(select_mdl, scale, seed);

[ cl1_results_random, cl2_results_random,...
    cl1_results_strat, cl2_results_strat ] =...
    trainAndTest('random', strategy, sample_steps, trials);



%% PLOT
x = sample_steps;
y = horzcat(cl1_results_random', cl2_results_random',...
            cl1_results_strat', cl2_results_strat');


legend = {'dt_{random}', 'nb_{random}',...
           strcat('dt_{',strategy,'}'), strcat('nb_{',strategy,'}')};

if strcmp(scale, 'log')
    logCCRPlot(x,'Training Size',...
        y,'CCR',...
        legend,...
        'Plot of CCR for training size between 1 to max training size');
    
    logAUCPlot(x,'Training Size',...
        y,'AUC',...
        legend,...
        'Plot of AUC for training size between 1 to max training size');
else
    linearCCRPlot(x,'Training Size',...
        y,'CCR',...
        legend,...
        'Plot of CCR for training size between 1 to max training size');
    
    linearAUCPlot(x,'Training Size',...
        y,'AUC',...
        legend,...
        'Plot of AUC for training size between 1 to max training size');    
end
