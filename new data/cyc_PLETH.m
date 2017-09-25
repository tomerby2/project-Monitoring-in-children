% calculate PLETH cycles from PLETH signal
% using the max points

    dirPath             = 'C:\Users\User\Documents\project\DATA\new data\150\PLETH_150\';
    Files               = dir([dirPath, '*.csv']);
    L                   = length(Files);
%   figure;
for ii = 1 : L
    fileName            = Files(ii).name;
    mX                  = csvread([dirPath, fileName]);
    sig                 = mX(:,2);
    tm                  = mX(:,1);
    [~, max_locs]       = findpeaks(sig, 'MinPeakHeight', median(sig)-100, 'MinPeakDistance', 30, 'MinPeakDistance', 50);
    tm_max              = tm(max_locs);
    
%     plot(tm, sig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); grid on; hold on;
%     plot(tm(max_locs), sig(max_locs), 'go', 'color', 'r'); hold off;
%     pause(0.8);
    
    cyc_diffs           = diff(tm_max);
    name                = ['C:\Users\User\Documents\project\DATA\new data\150\cyc_PLETH\cyc_', fileName];
    dlmwrite(name, cyc_diffs, 'delimiter', ',', 'precision', 13);
    
end

