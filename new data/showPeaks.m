
% show signal with found peaks

close all
clear;
clc;

dirPath  = 'C:\Users\User\Documents\project\DATA\new data\150\';
fileName = '0000150_1496373935344_NOM_PLETH_POST_DUCTAL.csv';      
mX       = csvread([dirPath, fileName]);
sig      = mX(:,2);
tm       = mX(:,1);

total_tm = (tm(end)-tm(1))/3600;


%%

% [BPmax,max_locs] = findpeaks(sig, 'MinPeakHeight', mean(sig), 'MinPeakDistance', 40);
% ecg 150
% [mins,~] = findpeaks(-sig, 'MinPeakHeight', mean(-sig), 'MinPeakDistance', 40);
% [mins_vals,min_locs] = findpeaks(-sig, 'MinPeakHeight', mean(mins), 'MinPeakDistance', 40);
% resp 150
[max_vals, max_locs] = findpeaks(sig, 'MinPeakHeight', median(sig)-100, 'MinPeakDistance', 30, 'MinPeakDistance', 50);

%ave_PP           = mean(BPmax)-mean(abs(BPmin)); %average peak to peak

plot(tm, sig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); grid on; hold on;
plot(tm(max_locs), sig(max_locs), 'ro'); hold on;  %max
%plot(tm(min_locs), sig(min_locs), 'go'); hold off; %min

title(fileName); 
hold off;

