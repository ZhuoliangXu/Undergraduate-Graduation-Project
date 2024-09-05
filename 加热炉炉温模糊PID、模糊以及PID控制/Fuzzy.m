clc;
clear all;
%% ���ݺ������岿��
ts=0.01;  %��������
s=tf('s');
sys=tf(50,[40,22,1]);   %���ݺ������ʽ
dsys=c2d(sys,ts,'z');  %��������ʱ��ģ��ת������ɢ��ʱ��ģ��
[num,den]=tfdata(dsys,'v');  %�����ɢ����ģ�͵ķ��ӷ�ĸ����
%% ������ʼ��
set0=200;      %�趨�¶�ֵ
y_1=100;       %��ʼ�����¶��趨
y_2=y_1;      %y_1=y_2,��ʼ�����¶����
y_3=y_2;
e_1=set0-y_1;  %��һʱ���²��ʼ��
e=e_1;        %����ʼ��
ec=0;         %���仯�ʳ�ʼ��
u_1=0; u_2=0;  %��ʼ����ǰ����ʱ�̵Ŀ�������Ҳ�ǳ�ʼ������
u_3=0; 
T = 40000;       %����ʱ������
time=zeros(1,T); %�洢ʱ�̵������ڴ�
u=zeros(1,T);    %�洢������������ڴ�
set = zeros(1,T); %�洢�趨�¶ȵ��ڴ�
y = zeros(1,T); %�洢ʵ���¶ȵ��ڴ�
%%
%��ģ������
%fuzzy=readfis('fuzzy2');%��ʼ�¶�Ϊ����ʱʹ��
fuzzy=readfis('fuzzy1');%��ʼ�¶ȴ���100ʱʹ��
%% ���¹���
for k=1:1:T
    time(k)=k*ts;   %ʱ�����
    set(k)=200;
    y(k)=-den(2)*y_1-den(3)*y_2+num(1)*u(k)+num(2)*u_1+num(3)*u_2; %z�任�����ɢϵͳ��Ӧ

    e=set(k)-y(k);  %�¶����
    ec=(e-e_1)/ts;    %���仯�� 
    %% ���㱥������
    f = den(2)*y_1 + (den(3)-den(2))*y_2 - den(3)*y_3 + (num(2)+num(3))*u_2 + num(3)*u_3;
    saturation_up = (2/ts+f)/num(2);
    saturation_down = (f/ts-2)/num(2);
    %% 
    u(k)=evalfis(fuzzy,[e,ec]);  %����ģ���������u
    % �������仯�ʶԿ�����u���б�������
    if (u(k)<saturation_down)
        u(k) = saturation_down;
    elseif (u(k)>saturation_up)
        u(k) = saturation_up;
    else
    end
    %% ��Ͼ��������仯�ʣ��Կ�����u���б�������
%     if abs(u(k)) > 4          % 4�Ǿ���ֵ
%         u(k) = sign(u(k))*4;
%     else
%     end
    %%    
    % ��������ǰһʱ�̵��²�ֵ��ǰ������ʱ�̵�ϵͳ������������
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
y_fuzzy = y;
save('fuzzydata.mat','set','time','y_fuzzy')
%%
% ��ͼ
figure(1)
plot(time,set,'b-',time,y,'r--');
ylim([50 250])
xlabel('ʱ��/s');ylabel( 'ʵʱ�¶�����/��');
legend('�趨�¶�','ģ��');
title('�¶ȱ仯����ͼ');

figure(2)
plot(time,u,'b-'); grid on;
xlabel('ʱ��/s');ylabel( '������u');
title('�������仯����');

figure(3)
plot(time,(set-y),'b-'); grid on;
xlabel('ʱ��/s');ylabel( '�¶����');
title('���仯����');
%%
    
