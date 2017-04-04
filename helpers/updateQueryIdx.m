function [ new_x ] = updateQueryIdx( s, sel_idx )
% getNewX
% Given a strategy, returns new data point index
% 
% Syntax:  [ new_x ] = getNewX( s )
% Inputs:
%    s - query strategy: string
%    sel_idx - logical array of selected indicies: num_sample x 1
%
% Outputs:
%    new_x - data point index: scalar
%------------- BEGIN CODE --------------

switch s
    case 'random'
        new_x = RAND(sel_idx);
    case 'vote_entropy'
        new_x = VE(X, Y, sel_idx);
    case 'qbc'
        new_x = QBC(X, Y, sel_idx);
    otherwise
        disp('ERROR')
end % END SWITCH

end % END FUNCTION

