clc
clear all
%% 传递函数定义部分
ts=0.01;  %采样时间
sys=tf(50,[40,22,1]);   %建立被控对象传递函数
dsys=c2d(sys,ts,'z');      %离散化
[num,den]=tfdata(dsys,'v');   %'v'代表强制以向量的格式（默认为元胞数组）输出num和den
%%
%参数初始化
set0=200;      %设定温度期望值
y_1=100;   %初始环境温度设定
y_2=y_1;  %y_1=y_2,初始环境温度相等
y_3=y_2;
e_1=set0-y_1;   %上一时刻温差初始化，也是初始温度差
e=e_1;   %初始误差
ec=0;    %初始误差变化率
Ca_e=0;  %初始累计误差
u_1=0; u_2=0;  %开始控制前两个时刻的控制量，也是初始控制量
u_3=0;
T = 40000; %仿真时刻总数
time=zeros(1,T);%存储时刻点分配的内存
u= zeros(1,T); %存储控制量分配的内存
set = zeros(1,T); %存储设定温度的内存
y = zeros(1,T); %存储实际温度的内存
%PID参数
kp=0.6;    
ki=0.002;
kd=5;
%% 
%升温过程
for k=1:1:T
    time(k)=k*ts;   %时间参数
    set(k) = 200; 
    
    y(k)=-den(2)*y_1-den(3)*y_2+num(1)*u(k)+num(2)*u_1+num(3)*u_2; %系统响应输出序列   
    
    e=set(k)-y(k);    %误差信号
    ec=(e-e_1)/ts;        %误差变化率
    Ca_e=Ca_e+e;     %误差的累加和        
    %% 计算饱和限制
    f = den(2)*y_1 + (den(3)-den(2))*y_2 - den(3)*y_3 + (num(2)+num(3))*u_2 + num(3)*u_3;
    saturation_up = (2/ts+f)/num(2);  
    saturation_down = (f-2/ts)/num(2);
    %% 控制器设计
    u(k)=kp*e+ki*Ca_e*ts+kd*ec; %系统PID控制器输出序列   
    % 根据误差变化率对控制器u进行饱和限制
    if (u(k)<saturation_down)
        u(k) = saturation_down;
    elseif (u(k)>saturation_up)
        u(k) = saturation_up;
    else
    end
    %% 凭经验给出的饱和限制
%     if abs(u(k)) > 4
%         u(k) = sign(u(k))*4;
%     else
%     end
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
y_pid = y;
save('piddata.mat','y_pid')
%%
% 绘图
figure(1)
plot(time,set,'b-',time,y,'r-.');
xlabel('时间/s');ylabel( '实时温度曲线/℃');
legend('设定温度','模糊');
title('温度变化曲线图');

figure(2)
plot(time,u,'b-'); grid on;
xlabel('时间/s');ylabel( '控制量u');
title('控制量变化曲线');

figure(3)
plot(time,set-y,'b-'); grid on;
xlabel('时间/s');ylabel( '温度误差');
title('误差变化曲线');
%%
