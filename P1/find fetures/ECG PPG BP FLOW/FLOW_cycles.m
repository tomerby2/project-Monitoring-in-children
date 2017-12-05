% calculate cycles distances from FLOW AWAY signal
% using 'db4' wavelet

dirPath = 'C:\Users\User\Documents\project\clean data\FLOW_AWAY_cleaned\';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);

for ii       = 1 : L
        fileName        = Files(ii).name;     
        mX              = csvread([dirPath, fileName]);
        FLOW_AWAY_sig   = mX(:,2);
        tm              = mX(:,1);

        wt              = modwt(FLOW_AWAY_sig,5);
        wtrec           = zeros(size(wt));
        wtrec(4:5,:)    = wt(4:5,:);
        y               = imodwt(wtrec,'db4');
        y               = abs(y).^2;

    [ypeaks,~]  = findpeaks(y,'MinPeakHeight', mean(y), 'MinPeakDistance', 40);
    [~,locs]    = findpeaks(y,'MinPeakHeight', median(ypeaks)/3, 'MinPeakDistance', 40);
    cyc_locs    = tm(locs(FLOW_AWAY_sig(locs)> mean(FLOW_AWAY_sig)));
    cyc_diffs   = diff(cyc_locs);
    name        = ['C:\Users\User\Documents\project\clean data\cyc_diffs_FLOW_AWAY\cyc_', fileName];
    dlmwrite(name, cyc_diffs, 'delimiter', ',', 'precision', 13);
     
  
end
