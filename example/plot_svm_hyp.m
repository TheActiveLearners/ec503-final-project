function [] = plot_svm_hyp(svmModel, X_data)

bias = svmModel.Bias;
supp_vecs = X_data(svmModel.IsSupportVector,:);

% parameters from svmMdl
% w1 = dot(svmModel.Alpha, supp_vecs(1,:));
% w2 = dot(svmModel.Alpha, supp_vecs(2,:));

w1 = svmModel.Beta(1);
w2 = svmModel.Beta(2);

% y = a*x + b
a = -w1/w2;
b = -bias/w2;
X = -6:.1:8;
Y = a*X + b;
plot(X,Y, 'LineWidth', 3, 'Color',[103/255 54/255 188/255]);
end
