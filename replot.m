%% Replot the results
addpath('./helpers/')
dir_spam       = './results/spambase_data';
dir_ibn       = './results/ibnsina_data';

cur_dir = dir_spam;
lastp = 2300;
% lastp = 10361;

files = dir(fullfile(cur_dir,'*.mat'));
for k = 1:length(files)
    fileName = files(k).name
    data = load(strcat(cur_dir,'/',fileName));
    y = data.results;
    [~,mlen] = size(y.cl1_results_st1);
    x = 2.^(1:mlen-1);
    x(end+1) = lastp;
    C = strsplit(fileName,'_');
    trials = strsplit(C{5}, '.');
    trials = str2num(trials{1});
    legend = {...
          strcat('qda_{',C{2},'}'), strcat('svm_{',C{2},'}'),...
          strcat('qda_{',C{3},'}'), strcat('svm_{',C{3},'}')...
         };
    p1 = logCCRPlot(x, y, legend, C{1}, trials);  
    savename = strcat(C{1}, '_',C{2},'_',C{3}, '_',...
     C{4}, '_CCR_', num2str(trials));
    savefig(p1,savename)
    savename = [savename,'.jpg'];
    saveas(p1,savename)
end