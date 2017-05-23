
% show BP signal with found peaks

close all
clear;
clc;

dirPath = 'C:\Users\User\Documents\project\DATA\MDC_PRESS_BLD_ART_ABP\';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);

figure;
for ii       = 1 : L
    fileName = Files(ii).name;     
    mX       = csvread([dirPath, fileName]);
    BPsig   = mX(:,2);
    tm       = mX(:,1);

    [BPpeaks,max_locs] = findpeaks(BPsig, 'MinPeakHeight', mean(BPsig), 'MinPeakDistance', 40);
    
    plot(tm, BPsig); hold on;
    plot(tm(max_locs), BPsig(max_locs), 'ro'); hold off;
    
    title(fileName); 
    drawnow; pause(0.3); %keyboard;
    hold off;
end
