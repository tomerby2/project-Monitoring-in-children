% calculate BP cycles from BP signal
% using the max points

    dirPath             = 'C:\Users\User\Documents\project\DATA\new data\150\BP_150\';
    Files               = dir([dirPath, '*.csv']);
    L                   = length(Files);
%   figure;
for ii = 1 : L
    fileName            = Files(ii).name;
    mX                  = csvread([dirPath, fileName]);
    sig                 = mX(:,2);
    tm                  = mX(:,1);
    [max_vals, max_locs]= findpeaks(sig, 'MinPeakHeight', mean(sig), 'MinPeakDistance', 25, 'MinPeakDistance', 50);
    tm_max              = tm(max_locs);
    interp_pks          = interp1(tm_max, max_vals, tm, 'spline');
    interp_cyc          = [tm, interp_pks];
    
    plot(tm, sig,'linewidth',1.5); xlabel('time'); ylabel('amplitude'); grid on; hold on;
    plot(tm(max_locs), sig(max_locs), 'go', 'color', 'r'); hold on;
    plot(interp_cyc(:,1),interp_cyc(:,2),'linewidth',1.5); hold off; 
    pause(1);
    
%     cyc_diffs           = diff(tm_max);
%     name                = ['C:\Users\User\Documents\project\DATA\new data\150\cyc_BP\cyc_', fileName];
%     dlmwrite(name, cyc_diffs, 'delimiter', ',', 'precision', 13);
    
%     name                = ['C:\Users\User\Documents\project\DATA\new data\150\cyc_interp_BP\cyc_interp', fileName];
%     dlmwrite(name, interp_cyc, 'delimiter', ',', 'precision', 13);

end

