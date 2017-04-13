function [ new_x ] = updateQueryIdx( strategy, sel_idx, num_select, X, Y )
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

% verify that at least one sample given in training
if any(sel_idx)
    % call query strategy
    switch strategy
        case 'uc'
            new_x = UC(X, Y, sel_idx, num_select);
        case 'random'
            new_x = RAND(sel_idx, num_select);
        case 'vote_entropy'
            new_x = VE(X, Y, sel_idx);
        case 'qbc'
            new_x = QBC(X, Y, sel_idx);
        otherwise
            disp('ERROR')
    end % END SWITCH
else
    % call default random query strategy
    new_x = RAND(sel_idx, num_select);
end % END IF/ELSE
end % END FUNCTION

