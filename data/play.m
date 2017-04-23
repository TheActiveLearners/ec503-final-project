load linSep_data
load nonLinSep_data2
load nonLinSep_data
X_data = X_nonLinSep;
[kmean_idx , C] = kmeans(X_data,2);
%plot(X_data(:,1), X_data(:,2),'.')
figure; plot(X_data(kmean_idx==1,1), X_data(kmean_idx==1,2),'r.'); hold on;
plot(X_data(kmean_idx == 2,1),X_data(kmean_idx == 2,2),'b.')
plot(C(:,1),C(:,2),'kx','MarkerSize',15, 'LineWidth',3)