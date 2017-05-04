

%% 

dir_spam       = './results/spambase_data';
dir_ibn       = './results/ibnsina_data';

cur_dir = dir_ibn;

files = dir(fullfile(cur_dir,'*.mat'));
for k = 1:length(files)
    fileName = files(k).name
    data = load(strcat(cur_dir,'/',fileName));
    results = data.results;
    m1 = mean(results.cl1_results_st1);
    m2 = mean(results.cl1_results_st2);
    qda_avg_ccr_diff = mean(m2 - m1)
    train_points = length(m1);
    
    m1_interp = interp(m1,4);
    m2_interp = interp(m2,4)
    [a,b] = sort(m1_interp, 'ascend')
    [c,d] = sort(m2_interp, 'ascend')
    
    
    
    
    m1 = mean(results.cl2_results_st1);
    m2 = mean(results.cl2_results_st2);
    svm_avg_ccr_diff = mean(m2 - m1)
end