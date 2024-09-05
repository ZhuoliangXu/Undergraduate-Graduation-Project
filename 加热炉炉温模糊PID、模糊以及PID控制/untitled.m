clc;
%% 传递函数定义部分
ts=0.1; 
s=tf('s');
H=1.8*exp(-30*s);
K=150*s+1;
sys=tf(H/K);  
dsys=c2d(sys,ts,'z');  %将连续的时间模型转换成离散的时间模型
[num,den]=tfdata(dsys,'v');  %获得离散还建模型的分子分母矩阵
%% 模糊PID参数初始化
set0=200; %设定温度期望值 
y_1=25;  %初始环境温度设定
y_2=y_1;  %y_1=y_2,初始环境温度相等
y_3=y_2;
e_1=set0-y_1;   %上一时刻温差初始化
e=e_1;      %误差初始化
ec=0;       %误差变化率初始化
Ca_e=0;     %累计误差初始化
u_1=0; u_2=0; %开始控制前两个时刻的控制量，也是初始控制量
u_3=0;
T=20000; %仿真时刻总数
time =zeros(1,T);%存储时刻点分配的内存
u = zeros(1,T); %存储控制量分配的内存
set = zeros(1,T); %存储设定温度的内存
y = zeros(1,T); %存储实际温度的内存
kp = zeros(1,T);
ki = zeros(1,T);
kd = zeros(1,T);
%% PID参数初值初始值
kp0=1;
ki0=0.005;
kd0=5;
%% 解模糊部分
fuzzypid=readfis('fuzzypid2');
%% 升温过程
for k=2:1:T
    time(k)=k*ts;   %时间参数
    set(k)=200;
    y(k)=0.9993*y(k-1)+0.0012*u(k-1); %z变换后的离散系统

    %PID控制器所控制的三个参数
    e=set(k)- y(k); %温度误差
    ec= (e-e_1)/ts;   %误差变化率
    Ca_e=Ca_e + e;  %累计误差        

    k_pid=evalfis(fuzzypid,[e ec]);  %计算模糊推理输出KP.KI.KD参数增量
    kp(k)=kp0+k_pid(1); %Kp解模糊结果
    ki(k)=ki0+k_pid(2); %Ki解模糊结果
    kd(k)=kd0+k_pid(3); %Kd解模糊结果     
    %% 控制器设计
    u(k)=kp(k)*e+kd(k)*ec+ki(k)*Ca_e*ts; %控制器输出值  
%%        
    % 迭代保存前一时刻的温差值和前两个时刻的系统输出量与控制量
    e_1=e;		    %保存此刻误差，给下一时刻的误差变化率计算使用
    u_3=u_2;
    u_2=u_1;    	%前第二个时刻的控制器输出值
    u_1=u(k);    	%前一个的控制器输出值
    y_3=y_2;
    y_2=y_1;        %前第二个时刻的系统响应输出值
    y_1=y(k);    	%前一个的系统响应输出值  
end
%%
% 保存数据
y_fuzzypid = y;
save('fuzzypiddata.mat','y_fuzzypid')
%% 画图部分
figure(1)
plot(time,set,'b',time,y,'r');
ylim([0 300])
xlabel('时间/s');ylabel( '实时温度曲线/℃');
legend('设定温度','模糊PID');
title('温度变化曲线图');
grid on;

figure(2)
plot(time,kp,'r');
xlabel('时间/s');ylabel( 'Kp值 ');
title('Kp变化曲线图');
grid on;

figure(3)
plot(time,ki,'g');
xlabel('时间/s');ylabel( 'Ki值 ');
title('Ki变化曲线图')
grid on;

figure(4)
plot(time,kd,'b');
xlabel('时间/s');ylabel( 'Kd值 ');
title('Kd变化曲线图')
grid on;

figure(5)
plot(time,u,'m');
xlabel('时间/s');ylabel( '控制量u');
title('控制量')
grid on;

%%
figure(6)
plot(time,kp,'g');
xlabel('时间/s');ylabel( 'Ki值 ');
title('Kp,Ki,Kd变化曲线图')
grid on;
hold on
plot(time,ki,'b--','Linewidth',1)
plot(time,kd,'k--','Linewidth',1)
xlabel('时间/s')
ylabel( 'Kp,Ki,Kd')
legend('Kp','Ki','Kd');
hold off
%%

%showrule(fuzzypid);
% figure(7);
% plotfis(fuzzypid);%绘制模糊推理系统的推理过程结构框图
% fuzzy fuzzypid.fis
%%

    

