
% show ECG signal with found peaks

close all
clear;
clc;

dirPath = 'C:\Users\Ifat Abramovich\Documents\project\new data\0000135_1488712397544\';
fileName = '0000135_1488712397544_MDC_ECG_ELEC_POTL_I.csv';     
mX       = csvread([dirPath, fileName]);
ecgsig   = mX(:,2);
tm       = mX(:,1);
t0 =tm(1);
tf= tm(end);
total_tm = (tm(end)-tm(1))/60;

wt           = modwt(ecgsig,5);
wtrec        = zeros(size(wt));
wtrec(4:5,:) = wt(4:5,:);
y            = imodwt(wtrec,'sym4');
y            = abs(y).^2;

[ypeaks,ylocs]  = findpeaks(y,'MinPeakHeight', mean(y), 'MinPeakDistance', 100);
[qrspeaks,locs] = findpeaks(y,'MinPeakHeight', mean(ypeaks)/2, 'MinPeakDistance', 100);
rr_locs         = locs(ecgsig(locs)> mean(ecgsig));

figure;
subplot(1,2,1); 
plot(tm, ecgsig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); grid on; hold on;
plot(tm(rr_locs), ecgsig(rr_locs), 'ro'); grid on;   hold off;
subplot(1,2,2); plot(y); hold on; plot(locs,y(locs), 'ro'); hold off;

title(fileName); 


