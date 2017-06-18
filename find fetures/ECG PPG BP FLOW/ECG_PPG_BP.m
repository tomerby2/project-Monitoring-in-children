close all;
clc;
% clear;

% cut_info_ecg = fetures_ECG_250Hz();
% cut_info_ppg = fetures_PPG();
% cut_info_BP = fetures_BP();

%% plot
figure; hold on; title('avarege distances between peaks of ECG & PPG & BP during time intervalas');
set(gca, 'FontSize', 24);
xlabel('time [hour]'); 
ylabel('beats per minute'); 
plot(mean(cut_info_ecg(:,3:4),2), cut_info_ecg(:,5), 'LineWidth', 1.5); 
plot(mean(cut_info_ppg(:,3:4),2), cut_info_ppg(:,5), 'LineWidth', 1.5); 
plot(mean(cut_info_BP(:,3:4),2), cut_info_BP(:,5), 'LineWidth', 1.5);
legend('ECG', 'PPG', 'BP');
set(gca, 'FontSize', 24);
grid on;
hold off;