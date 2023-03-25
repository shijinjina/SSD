clear;
clear all;
close all
load('fa.mat')
y=fa(1,:);
avarage=mean(y);
SSC=SAM_SSD1(y,1);
figure
k=size(SSC,1);
for m = 1:k;
    subplot(k,1,m)
    plot(1:size(SSC,2),SSC(m,:));
  
    set(gca,'FontName','Time New Roman','FontSize',10,'YTickLabelRotation',0)
 
    ylabel(['SSC',num2str(m)])
  

end
    set(gca,'FontName','Time New Roman','FontSize',10  )
    xlabel('t');
zongfenjie = sum(SSC,1)
avarage1=mean(zongfenjie);
figure
plot(1:400,y,'b');
    set(gca,'FontName','Time New Roman','FontSize',10  )
    xlabel('Sample points');
    ylabel('Daily new case data');
hold on 

figure     
fs=1;
u=SSC;
K=size(SSC,1)
for i=1:K
subplot(K+1,1,i)
[cc,y_f,]=hua_fft1(u(i,:),fs,1);
plot(y_f,cc,'b');
    set(gca,'FontName','Time New Roman','FontSize',10)
ylabel(['FFT of IMF',num2str(i)]);
axis tight
end
   





