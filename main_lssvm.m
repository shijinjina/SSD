
clc
clear
close all
load('data.mat')
X=MGdata_t60;
step=1;
k=1
[tau,m]=elmGetmt(X(k,:),step);
 tau =1;           % �ع�ʱ��
 m =2;              % �ع�ά��
%--------------------------------------------------
%����ѵ�������Ͳ�������
[input,output] = PhaSpaRecon(X(k,:),tau,m,step);
[L,n]=size(input); 
pp=200;
M=n-pp;
train_x=input(1:L,1:M)'; %����ѵ��
train_y=output(1,1:M)';  %����ѵ��
test_x=input(1:L,M+1:n)';%����ѵ���õ�ģ�ͣ���Ԥ������
test_result=output(1,M+1:n)'
%% ***************����ģ��******************
%-------------------------------------------------
SearchAgents_no=8; % Number of search agents  ��Ⱥ������

Max_iteration=50; % Maximum numbef of iterations ����������

[lb,ub,dim,fobj]=get_function('F2',train_x,train_y,test_x,test_result);            %�޸Ĳ���
%����GODLIKE
[Best_pos]=GODLIKE(fobj,lb,ub)
%% ***************����ģ��******************
type='function estimate';
gam=Best_pos(1); %�ɱ����
sig2=Best_pos(2); %�ɱ����
kernel='RBF_kernel';
preprocess='preprocess';
model = initlssvm(train_x,train_y,type,gam,sig2,kernel, preprocess);
model = trainlssvm(model); 
%% ************�Բ��Լ�����Ԥ��*****************
ptest=simlssvm(model,test_x);
ptrain =simlssvm(model,train_x);  %lssvmѵ���õ�������
ptest=ptest'                     %Ԥ��ֵ
MGdata_t60_ptest=ptest;          %Ԥ��ֵ
test_result=test_result'         %��ʵֵ
LSSVM_pre=MGdata_t60_ptest;

figure(1) 
plot(ptest')
hold on 
plot(test_result');
err = test_result - ptest;
legend('Real','Prediction result')
xlabel('Sampling points')
ylabel('The value')
%ѵ�����
error1=train_y'-ptrain';     
%���Լ������
error2=test_result'-ptest';
MGdata_t60_error=[error1,error2']                       %Ԥ�����
%%��ͼ�Ա�
N = max(length(test_result));
RMSE=sqrt(mse(test_result - ptest));
MAE=sum(abs(test_result - ptest))./N ;%   Calculate testing accuracy (RMSE) for regression case
MAPE=(sum(abs(err./test_result)))./N;
l=regstats(test_result,ptest,'quadratic','rsquare');
R = getfield(l,'rsquare');
sprintf('LSSVM:RMSE=%d,MAE=%d,MAPE=%d,R=%d',RMSE,MAE,MAPE,R)
