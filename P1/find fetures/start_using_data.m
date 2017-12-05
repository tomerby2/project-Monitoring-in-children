close all;
clear;
clc;

% AWAY_CO2 = load('C:\Users\User\Documents\project\3-53_3\MDC_AWAY_CO2.csv');
% figure; plot(AWAY_CO2(:,1),AWAY_CO2(:,2));
% title('ECG cardio beat');
% xlabel('time');
% ylabel('beats per minute');

% ECG_CARD_BEAT_RATE = load('C:\Users\User\Documents\project\3-53_3\MDC_ECG_CARD_BEAT_RATE.csv');
% figure; plot(ECG_CARD_BEAT_RATE(:,1),ECG_CARD_BEAT_RATE(:,2));
% title('ECG cardio beat');
% xlabel('time');
% ylabel('beats per minute');
% average_ECG_CARD_BEAT_RATE = mean(ECG_CARD_BEAT_RATE(:,2));

ECG_ELEC_POTL_II_250hz = csvread('C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II_250hz\ECG_ELEC_POTL_II_250hz_part_1.csv');
figure; plot(ECG_ELEC_POTL_II_250hz(1:end,1),ECG_ELEC_POTL_II_250hz(1:end,2));
title('ELEC POTL II 250hz');
xlabel('time');
ylabel('amplitude');
[R_pks,R_loc] = findpeaks(ECG_ELEC_POTL_II_250hz(1:end,2),ECG_ELEC_POTL_II_250hz(1:end,1),'MinPeakHeight',8500);
hold on;
scatter(R_loc,R_pks);
R_diffs =  diff(R_loc);
R_mean = mean(R_diffs);
R_var = var(R_diffs);
hold off;
figure; R_hist = histogram(R_diffs);

% ECG_ELEC_POTL_II_250hz = load('C:\Users\User\Documents\project\3-53_3\MDC_ECG_ELEC_POTL_II_250hz.csv');
% figure; plot(ECG_ELEC_POTL_II_250hz(:,1),ECG_ELEC_POTL_II_250hz(:,2));
% title('???');
% xlabel('time');
% ylabel('???');

% FLOW_AWAY = load('C:\Users\User\Documents\project\3-53_3\MDC_FLOW_AWAY.csv');
% figure; plot(FLOW_AWAY(:,1),FLOW_AWAY(:,2));
% title('???');
% xlabel('time');
% ylabel('???');

% PLETH_PULS_RATE = load('C:\Users\User\Documents\project\3-53_3\MDC_PLETH_PULS_RATE.csv');
% figure; plot(PLETH_PULS_RATE(:,1),PLETH_PULS_RATE(:,2));
% title('???');
% xlabel('time');
% ylabel('???');

% PULS_RATE = load('C:\Users\User\Documents\project\3-53_3\MDC_PULS_RATE.csv');
% figure; plot(PULS_RATE(:,1),PULS_RATE(:,2));
% title('???');
% xlabel('time');
% ylabel('???');

