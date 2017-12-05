
% show signal with found peaks

close all
clear;
clc;

dirPath  = 'C:\Users\User\Documents\project\DATA\new data\151\clean\';
fileName = '0000151_1494256534256_MDC_PRESS_BLD_ART_clean.csv';      
mX       = csvread([dirPath, fileName]);
sig      = mX(:,2);
tm       = mX(:,1);

total_tm = (tm(end)-tm(1))/3600;


%%

 [BPmax,max_locs] = findpeaks(sig, 'MinPeakHeight', mean(sig), 'MinPeakDistance', 40);
% ecg 150
% [~,min_locs]        = findpeaks(-sig, 'MinPeakHeight', mean(-1*sig)/1.01, 'MinPeakDistance', 60);
% [mins,~] = findpeaks(-sig, 'MinPeakHeight', mean(-sig), 'MinPeakDistance', 40);
% [mins_vals,min_locs] = findpeaks(-sig, 'MinPeakHeight', mean(mins), 'MinPeakDistance', 40);

%   [max_vals, max_locs] = findpeaks(sig, 'MinPeakHeight', median(sig)-100, 'MinPeakDistance', 30);
%  [max_vals, max_locs] = findpeaks(sig, 'MinPeakHeight', mean(sig), 'MinPeakDistance', 50);% ecg151
%ave_PP           = mean(BPmax)-mean(abs(BPmin)); %average peak to peak

plot(tm, sig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); grid on; hold on;
plot(tm(max_locs), sig(max_locs), 'ro'); hold on;  %max
% plot(tm(min_locs), -sig(min_locs), 'go'); hold off; %min

title(fileName); 
hold off;

