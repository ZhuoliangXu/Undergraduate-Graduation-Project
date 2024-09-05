clc;
%% ���ݺ������岿��
ts=0.01;  %��������
s=tf('s');
sys=tf(50,[40,22,1]);  %���ݺ������ʽ
dsys=c2d(sys,ts,'z');  %��������ʱ��ģ��ת������ɢ��ʱ��ģ��
[num,den]=tfdata(dsys,'v');  %�����ɢ����ģ�͵ķ��ӷ�ĸ����
%% ģ��PID������ʼ��
set0=200; %�趨�¶�����ֵ 
y_1=100;  %��ʼ�����¶��趨
y_2=y_1;  %y_1=y_2,��ʼ�����¶����
y_3=y_2;
e_1=set0-y_1;   %��һʱ���²��ʼ��
e=e_1;      %����ʼ��
ec=0;       %���仯�ʳ�ʼ��
Ca_e=0;     %�ۼ�����ʼ��
u_1=0; u_2=0; %��ʼ����ǰ����ʱ�̵Ŀ�������Ҳ�ǳ�ʼ������
u_3=0;
T= 40000; %����ʱ������
time =zeros(1,T);%�洢ʱ�̵������ڴ�
u = zeros(1,T); %�洢������������ڴ�
set = zeros(1,T); %�洢�趨�¶ȵ��ڴ�
y = zeros(1,T); %�洢ʵ���¶ȵ��ڴ�
kp = zeros(1,T);
ki = zeros(1,T);
kd = zeros(1,T);
%% PID������ֵ��ʼֵ
kp0=1;
ki0=0.005;
kd0=5;
%%
%��ģ������
%fuzzypid=readfis('fuzzypid2');%��ʼ�¶�Ϊ����ʱʹ��
fuzzypid=readfis('fuzzypid1');%��ʼ�¶ȴ���100ʱʹ��
%% ���¹���
for k=1:1:T
    time(k)=k*ts;   %ʱ�����
    set(k)=200;
    y(k)=-den(2)*y_1-den(3)*y_2+num(1)*u(k)+num(2)*u_1+num(3)*u_2; %z�任�����ɢϵͳ
    
    %PID�����������Ƶ���������
    e=set(k)- y(k); %�¶����
    ec=(e-e_1)/ts;   %���仯��
    Ca_e=Ca_e + e;  %�ۼ����        

    k_pid=evalfis(fuzzypid,[e ec]);  %����ģ���������KP.KI.KD��������
    kp(k)=kp0+k_pid(1); %Kp��ģ�����
    ki(k)=ki0+k_pid(2); %Ki��ģ�����
    kd(k)=kd0+k_pid(3); %Kd��ģ�����     
%% ���㱥������
    f = den(2)*y_1 + (den(3)-den(2))*y_2 - den(3)*y_3 + (num(2)+num(3))*u_2 + num(3)*u_3;
    saturation_up = (2/ts+f)/num(2);  
    saturation_down = (f-2/ts)/num(2);
    %% ���������
    u(k)=kp(k)*e+kd(k)*ec+ki(k)*Ca_e*ts; %���������ֵ  
    % �������仯�ʶԿ�����u���б�������
    if (u(k)<saturation_down)
        u(k) = saturation_down;
    elseif (u(k)>saturation_up)
        u(k) = saturation_up;
    else
    end
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
y_fuzzypid = y;
save('fuzzypiddata.mat','y_fuzzypid')
%% ��ͼ����
figure(1)
plot(time,set,'b',time,y,'r');
ylim([0 300])
xlabel('ʱ��/s');ylabel( 'ʵʱ�¶�����/��');
legend('�趨�¶�','ģ��PID');
title('�¶ȱ仯����ͼ');
grid on;

figure(2)
plot(time,kp,'r');
xlabel('ʱ��/s');ylabel( 'Kpֵ ');
title('Kp�仯����ͼ');
grid on;

figure(3)
plot(time,ki,'g');
xlabel('ʱ��/s');ylabel( 'Kiֵ ');
title('Ki�仯����ͼ')
grid on;

figure(4)
plot(time,kd,'b');
xlabel('ʱ��/s');ylabel( 'Kdֵ ');
title('Kd�仯����ͼ')
grid on;

figure(5)
plot(time,u,'m');
xlabel('ʱ��/s');ylabel( '������u');
title('������')
grid on;

%%
figure(6)
plot(time,kp,'g');
xlabel('ʱ��/s');ylabel( 'Kiֵ ');
title('Kp,Ki,Kd�仯����ͼ')
grid on;
hold on
plot(time,ki,'b--','Linewidth',1)
plot(time,kd,'k--','Linewidth',1)
xlabel('ʱ��/s')
ylabel( 'Kp,Ki,Kd')
legend('Kp','Ki','Kd');
hold off
%%

%showrule(fuzzypid);
% figure(7);
% plotfis(fuzzypid);%����ģ������ϵͳ��������̽ṹ��ͼ
% fuzzy fuzzypid.fis
%%

    
