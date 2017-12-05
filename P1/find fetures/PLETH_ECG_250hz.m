close all;
clc;
clear;

cut_info_ecg = fetures_ECG_250Hz();
cut_info_ppg = fetures_PPG();

%% plot
figure; hold on; title('ECG 250Hz & PPG');
xlabel('time [hour]'); 
ylabel('beats per minute'); 
plot(mean(cut_info_ecg(:,3:4),2), cut_info_ecg(:,5), 'LineWidth', 2); 
set(gca, 'FontSize', 24);
plot(mean(cut_info_ppg(:,3:4),2), cut_info_ppg(:,5), 'LineWidth', 2); 
legend('avarege distances between R pulses in time intervals from ecg','avarege distances between peaks of PPG during time intervalas');