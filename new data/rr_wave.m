% calculate RR distances from ECG signal
% using the min points

    dirPath             = 'C:\Users\User\Documents\project\DATA\new data\150\ECG_150\';
    Files               = dir([dirPath, '*.csv']);
    L                   = length(Files);
%   figure;
for ii = 1 : L
    fileName            = Files(ii).name;
    mX                  = csvread([dirPath, fileName]);
    ecgsig              = -1*(mX(:,2));
    tm                  = mX(:,1);
    [~,min_locs]        = findpeaks(ecgsig, 'MinPeakHeight', mean(ecgsig)/1.01, 'MinPeakDistance', 60);
    tm_min              = tm(min_locs);
    
%     plot(tm, ecgsig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); grid on; hold on;
%     plot(tm(min_locs), ecgsig(min_locs), 'go'); hold off;
%     pause(0.8);
    
    RR_diffs            = diff(tm_min);
    name                = ['C:\Users\User\Documents\project\DATA\new data\150\RR_wave_ecg\RR_', fileName];
    dlmwrite(name, RR_diffs, 'delimiter', ',', 'precision', 13);
    
end

