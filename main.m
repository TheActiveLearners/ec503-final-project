%% Active Learning with Kernel Ridge Regresssion and Decision Trees
% Authors:
% Connor Flynn
% Dor Rubin
% Jenna Warren
% Boston University EC503- Learning From Data
%
% Last revised: May 3, 2017
% MATLAB R2016B, Statistics and Machine Learning Toolbox

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
    {'alex', 'alex.data', 'alex.label'},... % 1
    {'ibn_sina', 'ibn_sina.data','ibn_sina.label'},... % 2
    {'spambase', 'spambase.data','spambase.label'} % 3
    };

% MAKE SELECTION HERE
% Model Selection
% select_mdl = input('Which dataset (1) ALEX (2) IBN_SINA ?  ');
select_dataset = 2;
dataset_name = datasets{select_dataset}{1}
dataset_data  = datasets{select_dataset}{2};
dataset_label  = datasets{select_dataset}{3};

% SCALE
scales = {'log', 'linear'};

% Scale Selection
% select_strat = input('Which scale (1) log (2) linear ?  ');
select_scale = 1;
scale = scales{select_scale}


% QUERY STRATEGIES
strategies = {...
              'pureUS', 'mixedUS',...
              'pureEnsembleXOR','mixedEnsembleXOR',...
              'pureEnsembleVE','mixedEnsembleVE',...
              'DWUS', 'DW',...
              'random'...
              };

% Strategy Selection
% select_strat = input('Which strategy (1) Vote (2) QBC (3) Uncertainty Sampling (4) Random ?  ');
select_strat_1 = 9;
select_strat_2 = 7;
strategy = {strategies{select_strat_1},strategies{select_strat_2}}

% Select number of trials
trials = 2;

%% DATA PROCESSING
% Format the data based on selections above

fname = fullfile(dir_data,dataset_label);
all_labels = load(fname);

fname = fullfile(dir_data,dataset_data);
all_data = load(fname);

[all_n,~] = size(all_data);
cv = cvpartition(all_n, 'Kfold', 2);

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

% via PAC learning model 1/E; E desired misclassification rate
% E = .05; 1/.05 = 20 ~ 32
seed = 32; % used for both linear and log
increment = 4; % used for linear only
max_sample = 100; % used for linear only

sample_steps = setScale(scale, train_n, seed, increment, max_sample);

tic
[ results ] = trainAndTest(strategy{1}, strategy{2}, sample_steps, trials);
toc

save(strcat(dataset_name, '_',strategy{1},'_',strategy{2}, '_',...
     scale, '_', num2str(trials)), 'results')

%% PLOT
x = sample_steps;
y = results;

legend = {...
          strcat('qda_{',strategy{1},'}'), strcat('svm_{',strategy{1},'}'),...
          strcat('qda_{',strategy{2},'}'), strcat('svm_{',strategy{2},'}')...
         };

if strcmp(scale, 'log')
    p1 = logCCRPlot(x, y, legend, dataset_name);
%     p2 = logAUCPlot(x, y, legend);
else
    p1 = linearCCRPlot(x, y, legend, dataset_name);
%     p2 = linearAUCPlot(x, y, legend);   
end


savefig(p1, strcat(dataset_name, '_',strategy{1},'_',strategy{2}, '_',...
     scale, '_CCR_', num2str(trials)))

% savefig(p2, strcat(dataset_name, '_',strategy{1},'_',strategy{2}, '_',...
%      scale, '_AUC_', num2str(trials)))