function [cut_info] = fetures_ECG_250Hz()

    dirPath     = 'C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II_250hz_cleaned/';
    Files       = dir([dirPath, '*.csv']);
    L           = length(Files);
    cut_info    = zeros(L,6);
    % cut_info = [section start time , section end time, normalized start time,
    % normalized end time, average beat rate, varience of beat rate]

    for ii = 1 : L
        fileName    = Files(ii).name;
        mX          = csvread([dirPath, fileName]);
        ecgsig      = mX(:,2);
        tm          = mX(:,1);
    %% find RR wave
        wt           = modwt(ecgsig,5);
        wtrec        = zeros(size(wt));
        wtrec(4:5,:) = wt(4:5,:);
        y            = imodwt(wtrec,'sym4');
        y            = abs(y).^2;
        [ypeaks,ylocs] = findpeaks(y,'MinPeakHeight', mean(y), 'MinPeakDistance', 1);
        [qrspeaks,locs] = findpeaks(y,'MinPeakHeight', mean(ypeaks)/2, 'MinPeakDistance', 1);
        rr_locs              = tm(locs(ecgsig(locs)> mean(ecgsig)));
    %% find average and variance of RR distances
        RR_diffs =  diff(rr_locs);
        cut_info(ii,:) = [tm(1), tm(end), 0, 0, 60/mean(RR_diffs), var(RR_diffs)];
    end
    %% sort the files according to time
    [~,index]           = sort(cut_info(:,1),'ascend');
    temp                = cut_info;
    cut_info(:,1:end)   = temp(index,1:end);
    cut_info(:,3)       = (cut_info(:,1)-cut_info(1,1))/3600; % normalize by first sample
    cut_info(:,4)       = (cut_info(:,2)-cut_info(1,1))/3600; % and change units to hours
    %% plot 
    ii = [1:146,148:L];
    figure; hold on; title('average heart rate in cut (about 7 minutes) form ECG 250Hz');
    xlabel('time [hour]'); 
    ylabel('beats per minute'); 
    plot(mean(cut_info(ii,3:4),2), cut_info(ii,5), 'LineWidth', 2); 
    set(gca, 'FontSize', 24);
end