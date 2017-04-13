function [ dt_results_random, krr_results_random ] = loadRandomData( model, scale )
%LOADRANDOMDATA Summary of this function goes here
%   Detailed explanation goes here

switch scale
    case 'log'
        switch model
            case 'alex'
                % Log scale for number of points to use in X
                steps = floor(log2(train_n));
                num_samples = 2.^(0:steps); % 1,2,4,8...4096,train_n
                num_samples(end + 1) = train_n;
            case 'ibn_sina'
                num_samples = (seed:inc:max_sample); % seed,seed+inc*1,seed+inc*2...,train_n
            otherwise
                disp('ERROR')
        end % END SWITCH
    case 'linear'
        num_samples = (seed:inc:max_sample); % seed,seed+inc*1,seed+inc*2...,train_n
    otherwise
        disp('ERROR')
end % END SWITCH

if select_mdl == 1
    dt_results_random = load('dt_results_log_all_random_alex_100');
    dt_results_random = dt_results_random.dt_results_strat;
    krr_results_random = load('krr_results_log_all_random_alex_100');
    krr_results_random = krr_results_random.krr_results_strat;
else
    dt_results_random = load('dt_results_log_all_random_ibn_100');
    dt_results_random = dt_results_random.dt_results_strat;
    krr_results_random = load('krr_results_log_all_random_ibn_100');
    krr_results_random = krr_results_random.krr_results_strat;
end

end

