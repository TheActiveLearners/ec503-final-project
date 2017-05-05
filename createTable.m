%% Create final Table of Results

dir_spam       = './results/spambase_data';
dir_ibn       = './results/ibnsina_data';

cur_dir = dir_ibn;
% lastp = 2300;
lastp = 10361;

files = dir(fullfile(cur_dir,'*.mat'));
for k = 1:length(files)
    fileName = files(k).name
    data = load(strcat(cur_dir,'/',fileName));
    results = data.results;
    
    m_1 = mean(results.cl1_results_st1);
    m_2 = mean(results.cl1_results_st2);
    [qda_area, qda_min] = getAreaAndMin(m_1, m_2, lastp)
    
    m_1 = mean(results.cl2_results_st1);
    m_2 = mean(results.cl2_results_st2);
    [svm_area, svm_min] = getAreaAndMin(m_1, m_2, lastp)

end