
% show BP signal with found peaks

close all
clear;
clc;

dirPath = 'C:\Users\User\Documents\project\clean data\MDC_PRESS_BLD_ART_ABP_cleaned\';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);

figure;
for ii       = 1 : L
    fileName = Files(ii).name;     
    mX       = csvread([dirPath, fileName]);
    BPsig   = mX(:,2);
    tm       = mX(:,1);

    [BPmax,max_locs] = findpeaks(BPsig, 'MinPeakHeight', mean(BPsig), 'MinPeakDistance', 40);
    [BPmin,min_locs] = findpeaks(-BPsig, 'MinPeakHeight', mean(-BPsig), 'MinPeakDistance', 40);
    
    ave_PP           = mean(BPmax)-mean(abs(BPmin));%average peak to peak
    
    plot(tm, [BPsig, ones(size(tm))*(1.8*ave_PP+mean(abs(BPmin))) ]); hold on;
    plot(tm(max_locs), BPsig(max_locs), 'ro'); hold on;  %max
    plot(tm(min_locs), BPsig(min_locs), 'go'); hold off; %min
    
    title(fileName); 
    drawnow; pause(0.5); %keyboard;
    hold off;
end
