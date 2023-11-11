clc
clear
close all


load BP_err
load ELM_err
load RNN_err
load KELM_err
load STOAKELM_err


load EMD_STOAKELM_err
load EEMD_STOAKELM_err
load CEEMDAN_STOAKELM_err
load CEEMDAN_NNetEn_VMD_STOAKELM_err
load CEEMDAN_NNetEn_STOAVMD_STOAKELM_err
load CEEMDAN_NNetEn_STOAVMD_STOAKELM_EC_err

figure(1)
plot(BP_err-BP_err,'k','linewidth',2);hold on;
plot(BP_err ,'-.');hold on;
plot(ELM_err ,'-.');hold on;
plot(RNN_err ,'-.');hold on;
plot(KELM_err ,'-.');hold on;
plot(STOAKELM_err,'-.');hold on;

plot(EMD_STOAKELM_err,'y:.');hold on;
plot(EEMD_STOAKELM_err,'g:.');hold on;
plot(CEEMDAN_STOAKELM_err,'c:.');hold on;
plot(CEEMDAN_NNetEn_VMD_STOAKELM_err,'m:.');hold on;
plot(CEEMDAN_NNetEn_STOAVMD_STOAKELM_err,'b:.');hold on;
plot(CEEMDAN_NNetEn_STOAVMD_STOAKELM_EC_err,'r:.','linewidth',2);hold on;

lgd = legend('真实值','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11');lgd.NumColumns = 6;
% ylim([-1.6,2]);
ylabel('误差');xlabel('样本点');set(gca,'fontsize',40.0);
% set(gcf,'Position',[347,162,600,250]);
 legend boxoff;
 



 


