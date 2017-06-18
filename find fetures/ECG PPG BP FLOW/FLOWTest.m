
% show FLOW AWAY signal with found peaks

close all
clear;
clc;

% dirPath = 'C:\Users\User\Documents\project\clean data\FLOW_AWAY_cleaned\';
dirPath = 'C:\Users\User\Documents\project\removed data\FLOW_AWAY_removed\';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);

figure;
for ii       = 1 : L
    fileName        = Files(ii).name;     
    mX              = csvread([dirPath, fileName]);
    FLOW_AWAY_sig   = mX(:,2);
    tm              = mX(:,1);

    wt           = modwt(FLOW_AWAY_sig,5);
    wtrec        = zeros(size(wt));
    wtrec(4:5,:) = wt(4:5,:);
    y            = imodwt(wtrec,'db4');
    y            = abs(y).^2;

    [ypeaks,~]  = findpeaks(y,'MinPeakHeight', mean(y), 'MinPeakDistance', 40);
    [~,locs]    = findpeaks(y,'MinPeakHeight', median(ypeaks)/3, 'MinPeakDistance', 40);
    cyc_locs    = locs(FLOW_AWAY_sig(locs)> mean(FLOW_AWAY_sig));
     
%    subplot(1,2,1); 
    plot(tm, FLOW_AWAY_sig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); set(gca, 'FontSize', 24); grid on; hold on;
%     plot(tm(cyc_locs), FLOW_AWAY_sig(cyc_locs), 'ro'); hold off;
%     subplot(1,2,2); plot(y); hold on;
%     plot(locs,y(locs), 'ro'); hold off;
    
    title(fileName); 
    drawnow; pause(1); %keyboard;
    hold off;
end
