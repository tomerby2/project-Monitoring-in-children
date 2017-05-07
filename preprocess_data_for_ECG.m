clear; close all; clc;

%% all files in folder
ii = 0;
all_data = dir(['C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II_250hz','\*.csv']);
[m,~] = size(all_data);
cut_info = zeros(m,6);
for file = all_data'
    in_data = csvread(['C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II_250hz\',file.name]);
    ii = ii+1;
%% clean artifacts
%     L = length(in_data);
%     l = floor(L/100);
%     for jj=l:l:L
%         mid_int = median(in_data((jj-l+1):jj,2));
%         var_int = var(in_data((jj-l+1):jj,2));
%         for kk=(jj-l+1):min(jj,L)
%             if (abs(in_data(kk,2)-mid_int)/sqrt(var_int)>5)
%                 in_data(kk,2) = mid_int;
%             end
%         end
%     end
%% find frequency and time resolution of data
    if ii==1
        T = in_data(2,1)-in_data(1,1);
        Fs = 1/T;
        T0 = in_data(1,1);
    end
%% find average, variance R distances and entropy 
    [R_pks,R_loc] = findpeaks(in_data(:,2), in_data(:,1), 'MinPeakHeight', mean(in_data(:,2))+200);
    R_diffs =  diff(R_loc);
    cut_info(ii,:) = [in_data(1,1), in_data(end,1), in_data(1,1)-T0, in_data(end,1)-T0, 60/mean(R_diffs), var(R_diffs)];
end
%% sort acording to time
[~,index] = sort(cut_info(:,1),'ascend');
temp = cut_info;
cut_info(:,1:end) = temp(index,1:end);
%% plot means and variances
ii=[1:145,147:226,234:256,258:length(cut_info)];
cut_info_print = cut_info(ii,:);
figure; plot(mean(cut_info_print(:,3:4),2)/3600, cut_info_print(:,5),'LineWidth', 2); 
title(['avarege distances between R pulses in time intervals']);
xlabel('time [hour]'); grid on; set(gca, 'FontSize', 24);
figure; plot(mean(cut_info_print(:,3:4),2)/3600, cut_info_print(:,6), 'LineWidth', 2); 
title(['the variance of the avarege distances between R pulses in time intervals']);
xlabel('time [hour]'); grid on; set(gca, 'FontSize', 24);
figure; histogram(cut_info_print(:,5), 200); grid on; set(gca, 'FontSize', 24);
title('histogram of avarege distances between R pulses in time intervals');
xlabel('beats per minute'); grid on; set(gca, 'FontSize', 24);
figure; histogram(cut_info_print(:,6), 200); grid on; set(gca, 'FontSize', 24);
title('histogram of the variance of the avarege distances between R pulses in time intervals');
%% plot after downsample
ds_cut_info = downsample(cut_info_print,2);
figure; plot(mean(ds_cut_info(:,3:4),2)/3600, ds_cut_info(:,5),'LineWidth', 2); 
title(['avarege distances between R pulses in time intervals']);
xlabel('time [hour]'); ylabel('beats per minute'); grid on; set(gca, 'FontSize', 24);
figure; plot(mean(ds_cut_info(:,3:4),2)/3600, ds_cut_info(:,6), 'LineWidth', 2); 
title(['the variance of the avarege distances between R pulses in time intervals']);
xlabel('time [hour]'); grid on; set(gca, 'FontSize', 24);
figure; histogram(ds_cut_info(:,5), 200); grid on; set(gca, 'FontSize', 24);
title('histogram of avarege distances between R pulses in time intervals');
xlabel('beats per minute');
figure; histogram(ds_cut_info(:,6), 200); grid on; set(gca, 'FontSize', 24);
title('histogram of the variance of the avarege distances between R pulses in time intervals');