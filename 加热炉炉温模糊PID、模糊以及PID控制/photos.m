clc
clear all;
%%
load fuzzydata
load fuzzypiddata
load piddata
%% �¶���Ӧ����
figure(1)
plot(time,set,'g-.',time,y_pid,'r--','Linewidth',1)
hold on
plot(time,y_fuzzy,'b--','Linewidth',1)
plot(time,y_fuzzypid,'k--','Linewidth',1)
ylim([0 300])
xlabel('ʱ��/s')
ylabel( 'ʵʱ�¶�����/��')
legend('�趨�¶�','y-pid','y-fuzzy','y-fuzzypid');
title('�¶ȱ仯����ͼ');
hold off
%% �������
figure(2)
e_pid = y_pid - set;
e_fuzzy = y_fuzzy - set;
e_fuzzypid = y_fuzzypid - set;
plot(time,e_pid,'r--','Linewidth',1)
hold on
plot(time,e_fuzzy,'b--','Linewidth',1)
plot(time,e_fuzzypid,'k--','Linewidth',1)
plot(time,set-set,'g--','Linewidth',1)
ylim([-200,50])
xlabel('ʱ��/s')
ylabel( '�¶��������/��')
legend('e-pid','e-fuzzy','e-fuzzypid','0');
title('�¶����仯����ͼ');
hold off
%%