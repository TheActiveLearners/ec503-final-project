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

% DATA SETS
datasets = {
    {'alex', 'alex.data', 'alex.label', 8},... % 1
    {'ibn_sina', 'ibn_sina.data','ibn_sina.label', 32},... % 2
    {'spambase', 'spambase.data','spambase.label', 16},... % 3
    {'linSep', 'linSep_data.mat','linSep_label.mat', 4},... % 4
    {'nonLinSep','nonLinSep_data.mat','nonLinSep_label.mat', 4},... % 5
    {'nonLinSep2','nonLinSep_data2.mat','nonLinSep_label2.mat', 4} % 6
    };

% MAKE SELECTION HERE
% Model Selection
% select_mdl = input('Which dataset (1) ALEX (2) IBN_SINA ?  ');
select_dataset = 1;
dataset_name = datasets{select_dataset}{1}
dataset_data  = datasets{select_dataset}{2};
dataset_label  = datasets{select_dataset}{3};

% SCALE
scales = {'log', 'linear'};

% Scale Selection
% select_strat = input('Which scale (1) log (2) linear ?  ');
select_scale = 2;
scale = scales{select_scale}
seed = datasets{select_dataset}{4}; % used for both linear and log
increment = 4; % used for linear only
max_sample = 100; % used for linear only


% QUERY STRATEGIES
strategies = {...
              'pureUS', 'mixedUS',....
              'pureDensity', 'mixedDensity',...
              'pureEnsembleXOR','mixedEnsembleXOR',...
              'pureEnsembleVE','mixedEnsembleVE',...
              'random'...
              };

% Strategy Selection
% select_strat = input('Which strategy (1) Vote (2) QBC (3) Uncertainty Sampling (4) Random ?  ');
select_strat = 3;
strategy = strategies{select_strat}

% Select number of trials
trials = 3;

%% DATA PROCESSING
% Format the data based on selections above

fname = fullfile(dir_data,dataset_data);
all_data = load(fname);
if(class(all_data) == 'struct')
    switch select_dataset
        case 5
            all_data = all_data.X_nonLinSep;
        case 4
            all_data = all_data.X_linSep;
        case 6
            all_data = all_data.X_nonLinSep2;
    end
end
[sample_steps,~] = size(all_data);
fname = fullfile(dir_data,dataset_label);
all_labels = load(fname);
if(class(all_labels) == 'struct')
    switch select_dataset
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

sample_steps = setScale(scale, train_n, seed, increment, max_sample);


[ cl1_results_random, cl2_results_random,...
    cl1_results_strat, cl2_results_strat ] =...
    trainAndTest('random', strategy, sample_steps, trials);



%% PLOT
x = sample_steps;
y = horzcat(cl1_results_random', cl2_results_random',...
            cl1_results_strat', cl2_results_strat');


legend = {'qda_{random}', 'svm_{random}',...
           strcat('qda_{',strategy,'}'), strcat('svm_{',strategy,'}')};

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
