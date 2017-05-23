close all
clear;
clc;

% dirPath = 'C:\Users\Oryair\Desktop\Workarea\ECG\ECG_ELEC_POTL_II_250hz\';
dirPath = 'C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II_250hz_cleaned/';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);

figure;
for ii = 1 : L
    fileName = Files(ii).name;
    mX       = csvread([dirPath, fileName]);
    ecgsig   = mX(:,2);
    tm       = mX(:,1);

    wt           = modwt(ecgsig,5);
    wtrec        = zeros(size(wt));
    wtrec(4:5,:) = wt(4:5,:);
    y            = imodwt(wtrec,'sym4');
    y            = abs(y).^2;
    % [qrspeaks,locs] = findpeaks(y,'MinPeakHeight',0.35,'MinPeakDistance',0.150);
    [ypeaks,ylocs] = findpeaks(y,'MinPeakHeight', mean(y), 'MinPeakDistance', 1);
    [qrspeaks,locs] = findpeaks(y,'MinPeakHeight', mean(ypeaks)/2, 'MinPeakDistance', 1);
    rr_locs              = locs(ecgsig(locs)> mean(ecgsig));
%     RR_locs              = rr_locs(ecgsig(rr_locs)>0.985*mean(ecgsig(rr_locs)));
     
    subplot(1,2,1); 
    plot(tm, ecgsig); hold on;
    plot(tm(rr_locs), ecgsig(rr_locs), 'ro'); hold off;
    subplot(1,2,2); plot(y); hold on;
    plot(locs,y(locs), 'ro'); hold off;
%     plot(tm, ecgsig); hold on;
%     plot(tm(RR), ecgsig(RR), 'ro'); hold off;
    
    title(fileName); 
     drawnow; pause(0.3); %keyboard;
    hold off;
end
