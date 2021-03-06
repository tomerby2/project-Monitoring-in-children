
% show ECG signal with found peaks

close all
clear;
clc;

dirPath = 'C:\Users\User\Documents\project\clean data\ECG_ELEC_POTL_II_250hz_cleaned\';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);

figure;
for ii       = 1 : L
    fileName = Files(ii).name;     
    mX       = csvread([dirPath, fileName]);
    ecgsig   = mX(:,2);
    tm       = mX(:,1);

    wt           = modwt(ecgsig,5);
    wtrec        = zeros(size(wt));
    wtrec(4:5,:) = wt(4:5,:);
    y            = imodwt(wtrec,'sym4');
    y            = abs(y).^2;

    [ypeaks,ylocs]  = findpeaks(y,'MinPeakHeight', mean(y), 'MinPeakDistance', 1);
    [qrspeaks,locs] = findpeaks(y,'MinPeakHeight', mean(ypeaks)/2, 'MinPeakDistance', 1);
    rr_locs         = locs(ecgsig(locs)> mean(ecgsig));
     
%     subplot(1,2,1); 
    plot(tm, ecgsig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); set(gca, 'FontSize', 24); grid on; hold on;
     plot(tm(rr_locs), ecgsig(rr_locs), 'ro'); grid on;   hold off;
%     subplot(1,2,2); plot(y); hold on;
%     plot(locs,y(locs), 'ro'); hold off;
    
    title(fileName); 
    drawnow; pause(1); %keyboard;
    hold off;
end
