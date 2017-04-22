function [ dt_results_random, krr_results_random ] = loadRandomData( dataset, scale, seed )
%LOADRANDOMDATA Summary of this function goes here
%   Detailed explanation goes here
addpath('results')
switch scale
    case 'log'
        start_id = log2(seed) + 1;
        if dataset == 1 %ALEX
            dt_results_random = load('dt_results_log_all_random_alex_100');
            dt_results_random = dt_results_random.dt_results_strat(start_id:end);
            krr_results_random = load('krr_results_log_all_random_alex_100');
            krr_results_random = krr_results_random.krr_results_strat(start_id:end);
        elseif dataset == 2 %IBN
            dt_results_random = load('dt_results_log_all_random_ibn_100');
            dt_results_random = dt_results_random.dt_results_strat;
            krr_results_random = load('krr_results_log_all_random_ibn_100');
            krr_results_random = krr_results_random.krr_results_strat;
        else
            dt_results_random = [];
            krr_results_random = [];
        end
    case 'linear'
        if dataset == 1 % ALEX
            dt_results_random = load('dt_results_linear_2_2_100_random_alex_100');
            dt_results_random = dt_results_random.dt_results_strat;
            krr_results_random = load('krr_results_linear_2_2_100_random_alex_100');
            krr_results_random = krr_results_random.krr_results_strat;
        elseif dataset == 2 % IBN
            dt_results_random = load('dt_results_linear_8_8_500_random_ibn_10');
            dt_results_random = dt_results_random.dt_results_strat;
            krr_results_random = load('krr_results_linear_8_8_500_random_ibn_10');
            krr_results_random = krr_results_random.krr_results_strat;
        else
            dt_results_random = [];
            krr_results_random = [];
        end
    otherwise
        disp('ERROR')
end % END SWITCH


end

