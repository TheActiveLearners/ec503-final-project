
rng(1);
%% 
% Edit mu and sigma values to create a new dataset.
mu1 = [2 3]; mu2 = [-1 0];
sigma1 = [2 0;0 3]; sigma2 = [1 0;0 2];
%%
X1 = mvnrnd(mu1,sigma1, 1000);
X2 = mvnrnd(mu2, sigma2, 1000);
Y1 = -1*ones(1000,1);
Y2 = ones(1000,1);
X_data = [X1; X2]; 
Y_data = [Y1; Y2];
% plot new data to inspect
gscatter(X_data(:,1), X_data(:,2), Y_data)

%% 
% Change variable and file names to save new dataset to a mat file
X_nonLinSep2 = X_data;
Y_nonLinSep2 = Y_data;
save('nonLinSep_data2', 'X_nonLinSep2');
save('nonLinSep_label2','Y_nonLinSep2');