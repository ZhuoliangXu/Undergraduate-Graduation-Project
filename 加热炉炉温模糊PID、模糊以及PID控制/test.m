clc;
%% 传递函数定义部分
ts=0.1; 
s=tf('s');
H=1.8*exp(-30*s);
K=150*s+1;
sys=tf(H/K);  
dsys=c2d(sys,ts,'z');  %将连续的时间模型转换成离散的时间模型
[num,den]=tfdata(dsys,'v');  %获得离散还建模型的分子分母矩阵
