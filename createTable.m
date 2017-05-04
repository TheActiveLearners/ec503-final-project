

%% 

dir_spam       = './results/spambase_data';
dir_ibn       = './results/ibnsina_data';

cur_dir = dir_spam;

files = dir(fullfile(cur_dir,'*.mat'));
for k = 1:length(files)
    fileName = files(k).name
    data = load(strcat(cur_dir,'/',fileName));
    results = data.results;
    m1 = mean(results.cl1_results_st1);
    m2 = mean(results.cl1_results_st2);
    combo = vertcat(m1,m2);
    qda_avg_ccr_diff = mean(m2 - m1);
    
    combo_sort = vertcat(a,c);
    difference_index = zeros(size(m1));
    for curr_ccr = m1_sort
        i = find(curr_ccr == m1);
        j = min(find(curr_ccr >= m2));
        difference_index(i) = j-i;
    end
    
    differnce_index;
    
    
    
    
    m1 = mean(results.cl2_results_st1);
    m2 = mean(results.cl2_results_st2);
    svm_avg_ccr_diff = mean(m2 - m1)
end