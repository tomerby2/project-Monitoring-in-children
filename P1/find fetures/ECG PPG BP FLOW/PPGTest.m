
% show PPG signal with found peaks

close all
clear;
clc;

dirPath = 'C:\Users\User\Documents\project\clean data\MDC_PULS_OXIM_PLETH_cleaned/';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);

figure;
for ii       = 1 : L
    fileName = Files(ii).name;     
    mX       = csvread([dirPath, fileName]);
    PPGsig   = mX(:,2);
    tm       = mX(:,1);

    [PPGpeaks,locs] = findpeaks(PPGsig, 'MinPeakHeight', mean(PPGsig), 'MinPeakDistance', 40);
    
    plot(tm, PPGsig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); set(gca, 'FontSize', 24); grid on; hold on;
%     plot(tm(locs), PPGsig(locs), 'ro'); hold off;
    
    title(fileName); 
    drawnow; pause(1); %keyboard;
    hold off;
end
