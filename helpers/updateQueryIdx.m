function [ new_sel_idx ] = updateQueryIdx( strategy, classifier, sel_idx, num_select, X, Y )
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
[train_n, ~] = size(X);
% verify that at least one sample given in training
if any(sel_idx) && num_select ~= train_n
    % call query strategy
    switch strategy
        case 'pureUS'
            new_sel_idx = pureUS(X, Y, sel_idx, num_select, classifier);
        case 'mixedUS'
            new_sel_idx = mixedUS(X, Y, sel_idx, num_select, classifier);
        case 'pureCluster'
            new_sel_idx = pureCluster(X, Y, sel_idx, num_select, classifier);
        case 'mixedCluster'
            new_sel_idx = mixedCluster(X, Y, sel_idx, num_select, classifier);            
        case 'random'
            new_sel_idx = RAND(sel_idx, num_select);
        case 'vote_entropy'
            new_sel_idx = VE(X, Y, sel_idx);
        case 'qbc'
            new_sel_idx = QBC(X, Y, sel_idx);
        otherwise
            error('Not a valid strategy')
    end % END SWITCH
else
    % call default random query strategy
    new_sel_idx = RAND(sel_idx, num_select);
end % END IF/ELSE
end % END FUNCTION

