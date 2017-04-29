function [ trained_indicies ] = getSortedEnsemble( sel_idx )
%getSortedEnsemble Summary of this function goes here
%   Detailed explanation goes here

global TRAIN_X TRAIN_Y;

% Get only those rows from X and Y
trained_X = TRAIN_X(sel_idx,:);
trained_Y = TRAIN_Y(sel_idx,:);
untrained_X = TRAIN_X(~sel_idx,:);


% Decision Trees Classifier
% Train a DT on only trained data
dt_mdl = fitctree(trained_X, trained_Y);

% Get Guess for DT
label_1 = predict(dt_mdl,untrained_X);


% SVM Classifier
% Train a SVM on only trained data
svm_mdl = fitcsvm(trained_X,trained_Y,'Standardize',true,'KernelFunction','RBF',...
                'KernelScale','auto');
% Get Guess for SVM
label_2 = predict(svm_mdl,untrained_X);


% Logistic Regression Classifier
% Train a log regression on only trained data
% copy trained in case less than 2 in each class 
trained_Y = repmat(trained_Y,2,1);
trained_X = repmat(trained_X,2,1);
disc_mdl = fitcdiscr(trained_X, trained_Y, 'DiscrimType', 'pseudoQuadratic');
% Get Guess for SVM

label_3 = predict(disc_mdl,untrained_X);

all_label = horzcat(label_1, label_2, label_3);
label_abs_sums = abs(sum(all_label,2));

[all_dist, trained_indicies] = sort(label_abs_sums, 'ascend');
end

