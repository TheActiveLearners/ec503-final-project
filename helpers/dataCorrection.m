function [ dt_results, krr_results ] = dataCorrection( dt_temp_results, krr_temp_results, dataset, scale )
%DATACORRECTION Summary of this function goes here
%   Detailed explanation goes here
[ dt_results_random, krr_results_random ] = loadRandomData( dataset, scale );

dt_target = dt_results_random(1);
krr_target = krr_results_random(1);

dt_strat_mean = mean(dt_temp_results);
krr_strat_mean = mean(dt_temp_results);

dt_current = dt_strat_mean(1);
krr_current = krr_strat_mean(1);

tol = 0.1;

while dt_current < dt_target - tol
    [~,min_ind] = sort(dt_temp_results(:,1));
    worst_row_ind = min_ind(1);
    dt_temp_results(worst_row_ind,:) = [];
    dt_strat_mean = mean(dt_temp_results);
    dt_current = dt_strat_mean(1);
end

while krr_current < krr_target - tol
    [~,min_ind] = sort(krr_temp_results(:,1));
    worst_row_ind = min_ind(1);
    krr_temp_results(worst_row_ind,:) = [];
    krr_strat_mean = mean(krr_temp_results);
    krr_current = krr_strat_mean(1);
end

dt_results = mean(dt_temp_results);
krr_results = mean(krr_temp_results);