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
    [min_val, min_locs] = findpeaks(ecgsig, 'MinPeakHeight', mean(ecgsig)/1.01, 'MinPeakDistance', 60);
    tm_min              = tm(min_locs);
    interp_pks          = interp1(tm_min, -min_val, tm, 'spline');
    interp_RR           = [tm, interp_pks];
    
    
    plot(tm, -ecgsig, 'linewidth',1.5); xlabel('time'); ylabel('amplitude'); grid on; hold on;
    plot(tm(min_locs), -ecgsig(min_locs), 'go'); hold on;
    plot(interp_RR(:,1),interp_RR(:,2),'linewidth',1.5); hold off; 
    pause(1);
    
%     RR_diffs            = diff(tm_min);
%     name                = ['C:\Users\User\Documents\project\DATA\new data\150\RR_wave_ecg\RR_', fileName];
%     dlmwrite(name, RR_diffs, 'delimiter', ',', 'precision', 13);
    
%     name                = ['C:\Users\User\Documents\project\DATA\new data\150\RR_wave_interp_ecg\RR_interp', fileName];
%     dlmwrite(name, interp_RR, 'delimiter', ',', 'precision', 13);

end

