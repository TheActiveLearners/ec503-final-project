function [ num_samples ] = setScale(scale, train_n, seed, inc, max_sample)
% getNewX
% Given a strategy, returns new data point index
%
% Syntax:  [ new_x ] = getNewX( s )
% Inputs:
%    scale - scale strategy: string
% Outputs:
%    new_x - data point index: scalar
%------------- BEGIN CODE --------------

% verify that at least one sample given in training

% call query strategy
switch scale
    case 'log'
        % Log scale for number of points to use in X
        steps = floor(log2(train_n));
        num_samples = 2.^(1:steps); % 1,2,4,8...4096,train_n
        num_samples(end + 1) = train_n;
    case 'linear'
        num_samples = (seed:inc:max_sample); % seed,seed+inc*1,seed+inc*2...,train_n
    otherwise
        disp('ERROR')
end % END SWITCH


end % END FUNCTION
