clear;
clc;
% Generate the training set
a = [0.1,0.9];
n = length(a);
L = n^8;
l = L;
k = 1;
X = zeros(L,8);
for i = 1:8
    l = l/n;
    for j = 1:l
        for ii = 1:n
            X((n*(j-1)+ii-1)*k+1:(n*(j-1)+ii)*k,9-i) = a(ii);
        end
    end
    k = k * n;
end
for i = 1:L
    if X(i,1)+X(i,2)>1||X(i,3)+X(i,4)>1||X(i,5)+X(i,6)>1;
        X(i,:)= 0;        
    end
end
X(all(X==0,2),:)=[];
f11 = @(x1,x2,y1,y2,z1,z2,w1,k1)((160*y2*x1-77*z1*y1-77*z2*y1+160*y1)/160);
f12 = @(x1,x2,y1,y2,z1,z2,w1,k1)((-160*w1*y2*x1-160*w1*y2*x2+77*k1*z1*y1+160*y2*x1-77*z1*y1-77*z2*y1+160*w1*y2+160*y1)/160);
f13 = @(x1,x2,y1,y2,z1,z2,w1,k1)((508*y1+385*y1*(1-z1-z2)+1000*x1*y2+1000*y2*(1-x1-x2)*w1)/1000);
f14 = @(x1,x2,y1,y2,z1,z2,w1,k1)((-160*y2*x1-160*y2*x2+308*z1*y1+497*y1+320*y2)/160);
f15 = @(x1,x2,y1,y2,z1,z2,w1,k1)((-640*y2*x1-640*y2*x2+539*z1*y1+640*y2)/16);
L = length(X);
for i = 1:L
    X(i,9) = f11(X(i,1),X(i,2),X(i,3),X(i,4),X(i,5),X(i,6),X(i,7),X(i,8));
    X(i,10) = f12(X(i,1),X(i,2),X(i,3),X(i,4),X(i,5),X(i,6),X(i,7),X(i,8));
    X(i,11) = f13(X(i,1),X(i,2),X(i,3),X(i,4),X(i,5),X(i,6),X(i,7),X(i,8));
    X(i,12) = f14(X(i,1),X(i,2),X(i,3),X(i,4),X(i,5),X(i,6),X(i,7),X(i,8));
    X(i,13) = f15(X(i,1),X(i,2),X(i,3),X(i,4),X(i,5),X(i,6),X(i,7),X(i,8));
end
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







