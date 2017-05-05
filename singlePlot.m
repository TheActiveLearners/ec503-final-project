%% Replot the results
addpath('./helpers/')
dir_spam       = './results/spambase_data';
dir_ibn       = './results/ibnsina_data';

cur_dir = dir_ibn;
% lastp = 2300;
lastp = 10361;
strats = {};
files = dir(fullfile(cur_dir,'*.mat'));
for k = 1:length(files)
    fileName = files(k).name
    C = strsplit(fileName,'_');
    data = load(strcat(cur_dir,'/',fileName));
    strat = strcat(C{3});
    strats{k} = strat;
    y.(strat) = data.results.cl2_results_st2;
end

y.random = data.results.cl2_results_st1;
strats{k+1} = 'random';
[~,mlen] = size(y.random);
x = 2.^(5:mlen+5-2);
x(end+1) = lastp;
trials = strsplit(C{5}, '.');
trials = str2num(trials{1});
% legend = {...
%     strcat('qda_{',strats{1},'}'), strcat('qda_{',strats{2},'}'),...
%     strcat('qda_{',strats{3},'}'), strcat('qda_{',strats{4},'}')...
%     strcat('qda_{',strats{5},'}'),...
%     };
legend = {...
    strcat('svm_{',strats{1},'}'), strcat('svm_{',strats{2},'}'),...
    strcat('svm_{',strats{3},'}'), strcat('svm_{',strats{4},'}')...
    strcat('svm_{',strats{5},'}')...
    };
p1 = logCCRPlot(x, y, legend, C{1}, trials);
savename = strcat(C{1}, '_',C{2},'_',C{3}, '_',...
    C{4}, '_CCR_', num2str(trials));
savefig(p1,savename)
savename = [savename,'.jpg'];
saveas(p1,savename)