clear;
clc;
X = xlsread('LWBTraining_samples60');
X(:,2) = X(:,2)./10;
Train_x = X(:,1:2);
Train_y1 = log(log(X(:,3)));
Train_y2 = log(log(X(:,4)));
P1 = 0.1:0.01:0.99;
T1 = 0.15;
[P1,T1] = meshgrid(P1,T1);
P1 = P1(:);
T1 = T1(:);
Test_x(:,1) = P1;
Test_x(:,2) = T1;
m = length(P1);
True_y = zeros(m,2);
f1 = @(p,T)((-862*p^9+(T+5174)*p^8-(6*T+13797)*p^7+(16*T+21705)*p^6-(24*T+22981)*p^5....
    +(22*T+18078)*p^4-(14*T+10769)*p^3+(8*T+4455)*p^2-(4*T+855)*p+T)...
    /(2*T*p^8-12*T*p^7+34*T*p^6-54*T*p^5+52*T*p^4-32*T*p^3+18*T*p^2-8*T*p+2*T));
f2 = @(p,T)((-1000*p^3+1035*p^2-355*p+T)/(p^3));
for i = 1:m
    True_y(i,1) = f1(Test_x(i,1),Test_x(i,2)*100000);
    True_y(i,2) = f2(Test_x(i,1),Test_x(i,2)*100000);
end
l = length(True_y);
Test_y = zeros(l,2);
Test_cov = zeros(l,4);
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
a = [P1, abs(Test_y(:,1)), True_y(:,1)];
b = [P1, abs(Test_y(:,2)), True_y(:,2)];
csvwrite('figure7.csv',a);
csvwrite('figure8.csv',b);
figure(1)
hold on;
plot(P1,abs(Test_y(:,1)),'--','LineWidth',1.2);
plot(P1,True_y(:,1),'LineWidth',1.2);
line([0.1 1],[0.05 0.05],'linestyle',':');
line([0.62 0.62],[0 0.05],'linestyle',':');
legend('Estimated value','Actual value','Threhold','Location','North','orientation','horizontal');
xlabel('P_s');
ylabel('R1','position',[0.02 0.3],'Rotation',0);
figure(2)
hold on;
plot(P1,log10(abs(Test_y(:,2))./1000),'--','LineWidth',1.2);
plot(P1,log10(True_y(:,2)./1000),'LineWidth',1.2);
line([0.1 1],[log10(40) log10(40)],'linestyle',':');
line([0.73 0.73],[0.5 log10(40)],'linestyle',':');
legend('Estimated value','Actual value','Threhold','Location','North','orientation','horizontal');
xlabel('P_s');
ylabel('log(R2)','position',[0.02 2.7],'Rotation',0);





