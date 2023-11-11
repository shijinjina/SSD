
clc;
close all;
clear all
K=xlsread('一次+二次结果.xlsx');


Z1=(K(1,:));
Z2=(K(2,:));
Z3=(K(3,:));
Z4=(K(4,:));
Z5=(K(5,:));
%  Z6=(K(6,:));
%  Z7=(K(7,:));
% Z8=(K(8,:));
%  Z9=(K(9,:));

Z=Z1+Z2+Z3+Z4+Z5;


C1=(K(11,:));
C2=(K(12,:));
C3=(K(13,:));
C4=(K(14,:));
C5=(K(15,:));
%  C6=(K(16,:));
%  C7=(K(17,:));
%  C8=(K(18,:));
%  C9=(K(19,:));
C=C1+C2+C3+C4+C5;

%% IV. 鎬ц兘璇勪环
% 误差
CEEMDAN_NNetEn_STOAVMD_STOAKELM_err=C-Z;
% save CEEMDAN_NNetEn_STOAVMD_STOAKELM_err;
preCEEMDAN_NNetEn_STOAVMD_STOAKELM=C;
% save preCEEMDAN_NNetEn_STOAVMD_STOAKELM;
YC=Z-C;
% save YC;
% save C;
% save Z;
data=Z;
% save data;
RMSE=sqrt(mse(C -Z))
N = max(length(C));
MAAPE=sum(atan(abs((C-Z)./Z))) /N
MSE = (sqrt(sum((abs(C-Z)).^2)))/N
MAE=sum(abs(C - Z))/N %   Calculate testing accuracy (RMSE) for regression case
l=regstats(C,Z,'quadratic','rsquare');
R = getfield(l,'rsquare')
SDE = sqrt(sum((C - Z).^2)/(N-1)) % 误差标准差sde
% sprintf('BP:RMSE=%d,MAE=%d,MSE=%d,R=%d,SDE=%d',RMSE,MAE,MSE,R,SDE)

figure(2)
plot(C,'b-d')
hold on
plot(Z,'r:*')
% legend('VMD-PSOELM预测值','真实')
xlabel('采样点')
ylabel('功率')