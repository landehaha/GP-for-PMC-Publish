clear;
clc;
P = 0.1:0.1:0.9;
T = 0.1:0.2:6;
[P,T] = meshgrid(P,T);
P = P(:);
T = T(:);
n = length(P);
f1 = @(p,T)((-862*p^9+(T+5174)*p^8-(6*T+13797)*p^7+(16*T+21705)*p^6-(24*T+22981)*p^5....
    +(22*T+18078)*p^4-(14*T+10769)*p^3+(8*T+4455)*p^2-(4*T+855)*p+T)...
    /(2*T*p^8-12*T*p^7+34*T*p^6-54*T*p^5+52*T*p^4-32*T*p^3+18*T*p^2-8*T*p+2*T));
f2 = @(p,T)((-1000*p^3+1035*p^2-355*p+T)/(p^3));
X = zeros(n,4);
X(:,1) = P;
X(:,2) = T;
for i = 1:n
    X(i,3) = log(log(f1(X(i,1),X(i,2)*10000)));
    X(i,4) = log(log(f2(X(i,1),X(i,2)*10000)));
end
Train_x = X(:,1:2);
Train_y1 = X(:,3);
Train_y2 = X(:,4);
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