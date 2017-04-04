function [ new_x ] = getNewX( s )
% getNewX
% Given a strategy, returns new data point index
% 
% Syntax:  [ new_x ] = getNewX( s )
% Inputs:
%    s - query strategy: string
%
% Outputs:
%    new_x - data point index: scalar
%------------- BEGIN CODE --------------

switch s
    case 'random'
        new_x = RAND(X, Y);
    case 'vote_entropy'
        new_x = VE(X, Y);
    case 'qbc'
        new_x = QBC(X, Y);
    otherwise
        disp('ERROR')
end % END SWITCH

end % END FUNCTION

