clear;
clc;
% Generate the training set
% a = [0.1,0.9]; % size-108
X = xlsread('HttpTraining_samples108.xlsx');
% a = [0.1,0.6,0.9]; % size-1125
% X = xlsread('HttpTraining_samples1125.xlsx');
% Define the Gaussian Process
meanfunc = {@meanSum, {@meanLinear, @meanConst}}; hyp.mean = [0;0;0;0;0;0;0;0;0];
covfunc = {@covMaternard, 5}; 
likfunc = @likGauss;
sn = 0.001;
hyp.lik = log(sn);
Train_x = X(:,1:8);
Train_y1 = X(:,9);
Train_y2 = X(:,10);
Train_y3 = X(:,11);
Train_y4 = X(:,12);
Train_y5 = X(:,13);
% Read the Testing Set
Test = xlsread('TestX10000.xlsx');
LL = 10000;
Test = Test(1:LL,:);
Test_x = Test(:,1:8);
True_y = Test(:,9:13);
n = length(True_y);
Test_y = zeros(n,5);
% Training and Testing
tic;
ell = 32; sf = 16; hyp.cov = log([ell;ell;ell;ell;ell;ell;ell;ell;sf]);
[Test_y1, Test_cov1] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, Train_x, Train_y1, Test_x);
ell = 32; sf = 16; hyp.cov = log([ell;ell;ell;ell;ell;ell;ell;ell;sf]);
[Test_y2, Test_cov2] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, Train_x, Train_y2, Test_x);
ell = 32; sf = 16; hyp.cov = log([ell;ell;ell;ell;ell;ell;ell;ell;sf]);
[Test_y3, Test_cov3] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, Train_x, Train_y3, Test_x);
ell = 32; sf = 16; hyp.cov = log([ell;ell;ell;ell;ell;ell;ell;ell;sf]);
[Test_y4, Test_cov4] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, Train_x, Train_y4, Test_x);
ell = 32; sf = 16; hyp.cov = log([ell;ell;ell;ell;ell;ell;ell;ell;sf]);
[Test_y5, Test_cov5] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, Train_x, Train_y5, Test_x);
t = toc;
Test_y(:,1) = Test_y1;
Test_y(:,2) = Test_y2;
Test_y(:,3) = Test_y3;
Test_y(:,4) = Test_y4;
Test_y(:,5) = Test_y5;
ER = 1-(abs(Test_y-True_y)./abs(True_y));
P = zeros(10,1);
for i = 1:5
    P(2*i-1) = length(find(ER(:,i)>0.99))/LL;
    P(2*i) = length(find(ER(:,i)>0.95))/LL;
end
disp(P);







