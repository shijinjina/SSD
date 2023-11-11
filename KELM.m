function [TY,TV1,Y]= KELM(input,output, Regularization_coefficient, Kernel_type, Kernel_para)
%%
[L,n]=size(input); %n对应于样本数
M=floor(n*0.8);%选取80%作为训练样本数
P1=input(1:L,1:M); %用于训练
T1=output(1,1:M);  %用于训练

TVP1=input(1:L,M+1:n);%借用训练好的模型，来预测数据
TV1=output(1,M+1:n);%待预测数据，用来和P_test预测出来的数据做比较
%% 数据归一化
% 训练集
[P,inputps] = mapminmax(P1);
[T,outputps] = mapminmax(T1);

% 测试集
TVP = mapminmax('apply',TVP1,inputps);
% TVT = mapminmax('apply',TV1,outputps);

%%
C = Regularization_coefficient;  %正则化系数
% NumberofTrainingData=size(P1,2); %训练样本的列数
% NumberofTestingData=size(TVP1,2); %测试样本的列数

%%%%%%%%%%% Training Phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic;
n = size(T,2);
Omega_train = kernel_matrix(P',Kernel_type, Kernel_para);
OutputWeight=((Omega_train+speye(n)/C)\(T')); 
% TrainingTime=toc

%%%%%%%%%%% Calculate the training output
Y=(Omega_train * OutputWeight)';                             %   Y: the actual output of the training data
Y = mapminmax('reverse',Y,outputps);  %反归一化得到训练出来的数据
%%%%%%%%%%% Calculate the output of testing input
% tic;
Omega_test = kernel_matrix(P',Kernel_type, Kernel_para,TVP');
TY=(Omega_test' * OutputWeight)';                            %   TY: the actual output of the testing data
TY = mapminmax('reverse',TY,outputps);  %反归一化得到测试出来的数据
% TestingTime=toc;

end

%%%%%%%%%%%%%%%%%% Kernel Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % --------------------调用核函数选择---------------------------
function omega = kernel_matrix(Xtrain,kernel_type, kernel_pars,Xt)

nb_data = size(Xtrain,1);


if strcmp(kernel_type,'RBF_kernel')
    if nargin<4
        XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        omega = exp(-omega./kernel_pars(1));
    else
        XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
        XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*Xtrain*Xt';
        omega = exp(-omega./kernel_pars(1));
    end
    
elseif strcmp(kernel_type,'lin_kernel')
    if nargin<4
        omega = Xtrain*Xtrain';
    else
        omega = Xtrain*Xt';
    end
    
elseif strcmp(kernel_type,'poly_kernel')
    if nargin<4
        omega = (Xtrain*Xtrain'+kernel_pars(1)).^kernel_pars(2);
    else
        omega = (Xtrain*Xt'+kernel_pars(1)).^kernel_pars(2);
    end
    
elseif strcmp(kernel_type,'wav_kernel')
    if nargin<4
        XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        
        XXh1 = sum(Xtrain,2)*ones(1,nb_data);
        omega1 = XXh1-XXh1';
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
        
    else
        XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
        XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*(Xtrain*Xt');
        
        XXh11 = sum(Xtrain,2)*ones(1,size(Xt,1));
        XXh22 = sum(Xt,2)*ones(1,nb_data);
        omega1 = XXh11-XXh22';
        
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
    end
end
end

