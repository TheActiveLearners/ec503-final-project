function [ new_sel_idx ] = updateQueryIdx( strategy, classifier, sel_idx, num_select)
% getNewX
% Given a strategy, returns new data point index
%
% Syntax:  [ new_x ] = getNewX( s )
% Inputs:
%    strategy - query strategy: string
%    sel_idx - logical array of selected indicies: num_sample x 1
%    num_select - number of data points to train on X: scalar
%    X - X data: num_samples by num_features
%    Y - Y labels: num_samples by 1
%
% Outputs:
%    new_x - data point index: scalar
%------------- BEGIN CODE --------------

global TRAIN_X;

[train_n, ~] = size(TRAIN_X);
% verify that at least one sample given in training
if any(sel_idx) && num_select ~= train_n
    % call query strategy
    switch strategy
        case 'pureUS'
            new_sel_idx = pureUS(sel_idx, num_select, classifier);
        case 'mixedUS'
            new_sel_idx = mixedUS(sel_idx, num_select, classifier);
        case 'pureCluster'
            new_sel_idx = pureCluster(sel_idx, num_select, classifier);
        case 'mixedCluster'
            new_sel_idx = mixedCluster(sel_idx, num_select, classifier);            
        case 'random'
            new_sel_idx = RAND(sel_idx, num_select);
        case 'vote_entropy'
            new_sel_idx = VE(sel_idx);
        case 'qbc'
            new_sel_idx = QBC(sel_idx);
        otherwise
            error('Not a valid strategy')
    end % END SWITCH
else
    % call default random query strategy
    new_sel_idx = RAND(sel_idx, num_select);
end % END IF/ELSE
end % END FUNCTION

