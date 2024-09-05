clc
clear all;
%%
load fuzzydata
load fuzzypiddata
load piddata
%% 温度响应曲线
figure(1)
plot(time,set,'g-.',time,y_pid,'r--','Linewidth',1)
hold on
plot(time,y_fuzzy,'b--','Linewidth',1)
plot(time,y_fuzzypid,'k--','Linewidth',1)
ylim([0 300])
xlabel('时间/s')
ylabel( '实时温度曲线/℃')
legend('设定温度','y-pid','y-fuzzy','y-fuzzypid');
title('温度变化曲线图');
hold off
%% 误差曲线
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
xlabel('时间/s')
ylabel( '温度误差曲线/℃')
legend('e-pid','e-fuzzy','e-fuzzypid','0');
title('温度误差变化曲线图');
hold off
%%