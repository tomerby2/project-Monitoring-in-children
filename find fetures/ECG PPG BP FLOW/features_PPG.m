function [cut_info] = fetures_PPG()

    dirPath  = 'C:\Users\ifatabr\Desktop\MDC_PULS_OXIM_PLETH_cleaned\';
    Files    = dir([dirPath, '*.csv']);
    L        = length(Files);
    cut_info = zeros(L,6);
     % cut_info = [section start time , section end time, normalized start time,
    % normalized end time, average beat rate, varience of beat rate]
    
    for ii = 1 : L

        fileName = Files(ii).name;     
        mX       = csvread([dirPath, fileName]);
        PPGsig   = mX(:,2);
        tm       = mX(:,1);

        [PPGpeaks,locs] = findpeaks(PPGsig,'MinPeakHeight',mean(PPGsig),'MinPeakDistance',40);

        %%find average and variance of peaks distances
        diffs =  diff(tm(locs));
        cut_info(ii,:) = [tm(1), tm(end), 0, 0, 60/mean(diffs), var(diffs)]; %beats per minute

    end

    %% sort the files according to time
    [~,index]           = sort(cut_info(:,1),'ascend');
    temp                = cut_info;
    cut_info(:,1:end)   = temp(index,1:end);
    cut_info(:,3)       = (cut_info(:,1)-cut_info(1,1))/3600; % normalize by first sample
    cut_info(:,4)       = (cut_info(:,2)-cut_info(1,1))/3600; % and change units to hours
    
    %% plot 
    figure; hold on; title('average heart rate in cut (about 7 minutes) from PPG');
    xlabel('time [hour]'); 
    ylabel('beats per minute'); 
    plot(mean(cut_info(:,3:4),2), cut_info(:,5), 'LineWidth', 2); 
    set(gca, 'FontSize', 24);
    hold off;
end