function [ new_sel_idx ] = updateQueryIdx( strategy, classifier, sel_idx, num_select)
% updateQueryIdx
% Given a strategy, returns new data point index
%
% Syntax:  [ new_x ] = getNewX( s )
% Inputs:
%    strategy - query strategy: string
%    classifier - base classifier ultimately used for testing: string
%    sel_idx - logic vector of which indicies currently selected: vector
%    num_select - number of elements to select at this iteration
%
% Outputs:
%    new_sel_idx - new logic vector of selected indicies: vector
%------------- BEGIN CODE --------------

global TRAIN_X;

[train_n, ~] = size(TRAIN_X);
% verify that at least one sample given in training
% last batch selected randomly ex. 2,4...2048,2300 from 2048->2300 is random
if any(sel_idx) && num_select ~= train_n
    % call query strategy
    switch strategy
        case 'pureUS'
            new_sel_idx = pureUS(sel_idx, num_select, classifier);
        case 'mixedUS'
            new_sel_idx = mixedUS(sel_idx, num_select, classifier);
        case 'DWUS'
            new_sel_idx = DWUS(sel_idx, num_select, classifier);
        case 'DW'
            new_sel_idx = DW(sel_idx, num_select);          
        case 'pureEnsembleXOR'
            new_sel_idx = pureEnsembleXOR(sel_idx, num_select);
        case 'mixedEnsembleXOR'
            new_sel_idx = mixedEnsembleXOR(sel_idx, num_select);
        case 'pureEnsembleVE'
            new_sel_idx = pureEnsembleVE(sel_idx, num_select);
        case 'mixedEnsembleVE'
            new_sel_idx = mixedEnsembleVE(sel_idx, num_select);                               
        case 'random'
            new_sel_idx = RAND(sel_idx, num_select);
        otherwise
            error('Not a valid strategy')
    end % END SWITCH
else
    % call default random query strategy
    new_sel_idx = RAND(sel_idx, num_select);
end % END IF/ELSE
end % END FUNCTION

