

% calculate RR distances from ECG signal
% using 'sym4' wavelet

    dirPath             = 'C:\Users\User\Documents\project\DATA\new data\142\ECG_142\';
    Files               = dir([dirPath, '*.csv']);
    L                   = length(Files);

for ii = 1 : L
    fileName        = Files(ii).name;
    mX              = csvread([dirPath, fileName]);
    ecgsig          = mX(:,2);
    tm              = mX(:,1);
    wt              = modwt(ecgsig,5);
    wtrec           = zeros(size(wt));
    wtrec(4:5,:)    = wt(4:5,:);
    y               = imodwt(wtrec, 'sym4');
    y               = abs(y).^2;
    [ypeaks,~]      = findpeaks(y, 'MinPeakHeight', mean(y), 'MinPeakDistance', 1);
    [~,locs]        = findpeaks(y, 'MinPeakHeight', mean(ypeaks)/2, 'MinPeakDistance', 1);
    rr_locs         = tm(locs(ecgsig(locs)> mean(ecgsig)));
    RR_diffs        = diff(rr_locs);
    name            = ['C:\Users\User\Documents\project\new clean data\RR_diffs_ECG_142\RR_', fileName];
    dlmwrite(name, RR_diffs, 'delimiter', ',', 'precision', 13);
    
end

