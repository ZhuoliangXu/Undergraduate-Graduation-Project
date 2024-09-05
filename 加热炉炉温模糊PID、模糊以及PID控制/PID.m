clc
clear all
%% ���ݺ������岿��
ts=0.01;  %����ʱ��
sys=tf(50,[40,22,1]);   %�������ض��󴫵ݺ���
dsys=c2d(sys,ts,'z');      %��ɢ��
[num,den]=tfdata(dsys,'v');   %'v'����ǿ���������ĸ�ʽ��Ĭ��ΪԪ�����飩���num��den
%%
%������ʼ��
set0=200;      %�趨�¶�����ֵ
y_1=100;   %��ʼ�����¶��趨
y_2=y_1;  %y_1=y_2,��ʼ�����¶����
y_3=y_2;
e_1=set0-y_1;   %��һʱ���²��ʼ����Ҳ�ǳ�ʼ�¶Ȳ�
e=e_1;   %��ʼ���
ec=0;    %��ʼ���仯��
Ca_e=0;  %��ʼ�ۼ����
u_1=0; u_2=0;  %��ʼ����ǰ����ʱ�̵Ŀ�������Ҳ�ǳ�ʼ������
u_3=0;
T = 40000; %����ʱ������
time=zeros(1,T);%�洢ʱ�̵������ڴ�
u= zeros(1,T); %�洢������������ڴ�
set = zeros(1,T); %�洢�趨�¶ȵ��ڴ�
y = zeros(1,T); %�洢ʵ���¶ȵ��ڴ�
%PID����
kp=0.6;    
ki=0.002;
kd=5;
%% 
%���¹���
for k=1:1:T
    time(k)=k*ts;   %ʱ�����
    set(k) = 200; 
    
    y(k)=-den(2)*y_1-den(3)*y_2+num(1)*u(k)+num(2)*u_1+num(3)*u_2; %ϵͳ��Ӧ�������   
    
    e=set(k)-y(k);    %����ź�
    ec=(e-e_1)/ts;        %���仯��
    Ca_e=Ca_e+e;     %�����ۼӺ�        
    %% ���㱥������
    f = den(2)*y_1 + (den(3)-den(2))*y_2 - den(3)*y_3 + (num(2)+num(3))*u_2 + num(3)*u_3;
    saturation_up = (2/ts+f)/num(2);  
    saturation_down = (f-2/ts)/num(2);
    %% ���������
    u(k)=kp*e+ki*Ca_e*ts+kd*ec; %ϵͳPID�������������   
    % �������仯�ʶԿ�����u���б�������
    if (u(k)<saturation_down)
        u(k) = saturation_down;
    elseif (u(k)>saturation_up)
        u(k) = saturation_up;
    else
    end
    %% ƾ��������ı�������
%     if abs(u(k)) > 4
%         u(k) = sign(u(k))*4;
%     else
%     end
    %%
    % ��������ǰһʱ�̵��²�ֵ��ǰ����ʱ�̵�ϵͳ������������
    e_1=e;		    %����˿�������һʱ�̵����仯�ʼ���ʹ��
    u_3=u_2;
    u_2=u_1;    	%ǰ�ڶ���ʱ�̵Ŀ��������ֵ
    u_1=u(k);    	%ǰһ���Ŀ��������ֵ
    y_3=y_2;
    y_2=y_1;        %ǰ�ڶ���ʱ�̵�ϵͳ��Ӧ���ֵ
    y_1=y(k);    	%ǰһ����ϵͳ��Ӧ���ֵ  
end
%%
% ��������
y_pid = y;
save('piddata.mat','y_pid')
%%
% ��ͼ
figure(1)
plot(time,set,'b-',time,y,'r-.');
xlabel('ʱ��/s');ylabel( 'ʵʱ�¶�����/��');
legend('�趨�¶�','ģ��');
title('�¶ȱ仯����ͼ');

figure(2)
plot(time,u,'b-'); grid on;
xlabel('ʱ��/s');ylabel( '������u');
title('�������仯����');

figure(3)
plot(time,set-y,'b-'); grid on;
xlabel('ʱ��/s');ylabel( '�¶����');
title('���仯����');
%%
