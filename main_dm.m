clear all
clc
load ¶íÂÞË¹error
dm=error;
dm1 = dm';
[m,n]=size(dm1);
dm=[];
p=[];
for i=1:7
    [DM,value]= dmtest(dm1(:,i), dm1(:,8));
    dm=[dm;DM];
    p=[p,value];
    
end
