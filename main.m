clear all 
clc
t1=clock;
% SearchAgents_no=1 % Number of search agents
% 
 Function_name='F2'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)
% 
% Max_iteration=1; % Maximum numbef of iterations
% 
%  load data_spring.mat
% z=data;
data=xlsread('IMF4567.xlsx','Sheet1','E1:E1000');
%  load('IMF1.mat')
z=data;
% load demo1.mat
% z=demo1;
% z=IMF1;
% z=water(1:1048,1);
%����ѵ�������Ͳ�������
n=length(z);
a=z(:);
L=5;%��5��Ԥ��һ��
a_n=zeros(L+1,n-L); 
for i=1:n-L
    a_n(:,i)=a(i:i+L);%����n-L������
end

input=a_n(1:L,:);%��������
output=a_n(L+1,:); %���
% 
% P_train=a_n(1:5,1:800);
% P_test=a_n(1:5,801:end);
% 
% T_train=a_n(6,1:800);
% T_test=a_n(6,801:end);

%������n-L��������
%��n-L��*80%��Ϊѵ������  
%��n-L��*20%��ΪԤ������ 
% %% ��һ��
% [input0,inputps] = mapminmax(P_train);
% TVP = mapminmax('apply',P_test,inputps);
% [output0,outputps] = mapminmax(T_train);
% TVT = mapminmax('apply',T_test,outputps);

%-------------------------------------------------------------------------


%[Best_score,Best_pos,WOA_cg_curve]=WOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
%  [score,Best_pos]=Jaya(lb',ub',fobj,SearchAgents_no,dim,Max_iteration);
%Draw objective space
% Best_pos(end,:)
% score(1,end)
Regularization_coefficient=3500;         %�ɵ�����
 Kernel_type='RBF_kernel';      
 Kernel_para=20;                        %�ɵ�����
[test_simu,output_test]= KELM(input,output, Regularization_coefficient, Kernel_type, Kernel_para);
kelm = test_simu;


% RMSE=sqrt(mse(output_test - test_simu))
N = max(length(output_test));
err=(output_test - test_simu);
% KELM_err=output_test - test_simu;
% save KELM_err;
% preKELM=test_simu;
% save preKELM
RMS=sqrt(sum(err.^2)/N)
RMSE=sqrt(mse(output_test - test_simu))
MAE=sum(abs(output_test - test_simu))/N %   Calculate testing accuracy (RMSE) for regression case
 MAPE=sum(abs((output_test - test_simu)./(output_test))) /N
  MAAPE=sum(atan(abs((output_test - test_simu)./(output_test)))) /N
% MAPE=sum(abs(((output_test - test_simu))./(output_test - test_simu)))./N
R2=(N*sum(test_simu.*output_test)-sum(test_simu)*sum(output_test))^2/((N*sum((test_simu).^2)-(sum(test_simu))^2)*(N*sum((output_test).^2)-(sum(output_test))^2))
% l=regstats(output_test,test_simu,'quadratic','rsquare');
% R = getfield(l,'rsquare')
% sprintf('BP:RMSE=%d,MAE=%d,R2=%d',RMSE,MAE,R2)

figure(3)
plot(output_test,'b-d')
hold on
plot(test_simu,'r:*')
legend('��ʵֵ','Ԥ��ֵ')
xlabel('ʱ��')
ylabel('��ֵ')

t2=clock;
etime(t2,t1)



