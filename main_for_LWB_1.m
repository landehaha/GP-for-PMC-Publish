clear;
clc;
% X = xlsread('LWBTraining_samples60.xlsx');
% Above is size-60
% X = xlsread('LWBTraining_samples108.xlsx');
% Above is size-108
% X = xlsread('LWBTraining_samples135.xlsx');
% Above is size-135
% X = xlsread('LWBTraining_samples180.xlsx');
% Above is size-180
X = xlsread('LWBTraining_samples270.xlsx');
% Above is size-270
Train_x = X(:,1:2);
Train_y1 = log(log(X(:,3)));
Train_y2 = log(log(X(:,4)));
True = xlsread('LWBTestX10000.xlsx');
l = length(True);
Test_x = True(:,1:2);
True_y = True(:,3:4);
Test_y = zeros(l,2);
meanfunc = {@meanSum, {@meanLinear, @meanConst}}; hyp.mean = [0;0;0];
covfunc = {@covMaternard, 5}; 
likfunc = @likGauss;
sn = 0.001;
hyp.lik = log(sn);
ell = 1; sf = 1; hyp.cov = log([ell;ell;sf]);
[Test_y1, Test_cov1] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, Train_x, Train_y1, Test_x);
Test_y(:,1) = exp(exp(Test_y1));
ell = 1; sf = 1; hyp.cov = log([ell;ell;sf]);
[Test_y2, Test_cov2] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, Train_x, Train_y2, Test_x);
Test_y(:,2) = exp(exp(Test_y2));
ER = 1-(abs(Test_y-True_y)./abs(True_y));
P = zeros(6,1);
for i = 1:2
    P(3*i-2) = length(find(ER(:,i)>0.99))/l;
    P(3*i-1) = length(find(ER(:,i)>0.95))/l;
    P(3*i) = length(find(ER(:,i)>0.90))/l;
end
disp(P);