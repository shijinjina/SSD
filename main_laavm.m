
clc
clear
close all
load('data.mat')
X=MGdata_t60;
step=1;
k=1
[tau,m]=elmGetmt(X(k,:),step);
 tau =1;           % 重构时延
 m =2;              % 重构维数
%--------------------------------------------------
%划分训练样本和测试样本
[input,output] = PhaSpaRecon(X(k,:),tau,m,step);
[L,n]=size(input); 
pp=200;
M=n-pp;
train_x=input(1:L,1:M)'; %用于训练
train_y=output(1,1:M)';  %用于训练
test_x=input(1:L,M+1:n)';%借用训练好的模型，来预测数据
test_result=output(1,M+1:n)'
%% ***************建立模型******************
%-------------------------------------------------
SearchAgents_no=8; % Number of search agents  狼群的数量

Max_iteration=50; % Maximum numbef of iterations 最大迭代次数

[lb,ub,dim,fobj]=get_function('F2',train_x,train_y,test_x,test_result);            %修改参数
%调用GODLIKE
[Best_pos]=GODLIKE(fobj,lb,ub)
%% ***************建立模型******************
type='function estimate';
gam=Best_pos(1); %可变参数
sig2=Best_pos(2); %可变参数
kernel='RBF_kernel';
preprocess='preprocess';
model = initlssvm(train_x,train_y,type,gam,sig2,kernel, preprocess);
model = trainlssvm(model); 
%% ************对测试集进行预测*****************
ptest=simlssvm(model,test_x);
ptrain =simlssvm(model,train_x);  %lssvm训练得到的数据
ptest=ptest'                     %预测值
MGdata_t60_ptest=ptest;          %预测值
test_result=test_result'         %真实值
LSSVM_pre=MGdata_t60_ptest;

figure(1) 
plot(ptest')
hold on 
plot(test_result');
err = test_result - ptest;
legend('Real','Prediction result')
xlabel('Sampling points')
ylabel('The value')
%训练误差
error1=train_y'-ptrain';     
%测试集的误差
error2=test_result'-ptest';
MGdata_t60_error=[error1,error2']                       %预测误差
%%画图对比
N = max(length(test_result));
RMSE=sqrt(mse(test_result - ptest));
MAE=sum(abs(test_result - ptest))./N ;%   Calculate testing accuracy (RMSE) for regression case
MAPE=(sum(abs(err./test_result)))./N;
l=regstats(test_result,ptest,'quadratic','rsquare');
R = getfield(l,'rsquare');
sprintf('LSSVM:RMSE=%d,MAE=%d,MAPE=%d,R=%d',RMSE,MAE,MAPE,R)
