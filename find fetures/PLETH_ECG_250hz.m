%clear; close all; clc;

%% ECG
%% all files in folder
ii = 0;
all_data = dir(['C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II_250hz','\*.csv']);
[m,~] = size(all_data);
cut_info = zeros(m,6);
for file = all_data'
    in_data = csvread(['C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II_250hz\',file.name]);
    ii = ii+1;
%% clean artifacts
    L = length(in_data);
    l = floor(L/100);
    for jj=l:l:L
        mid_int = median(in_data((jj-l+1):jj,2));
        var_int = var(in_data((jj-l+1):jj,2));
        for kk=(jj-l+1):min(jj,L)
            if (abs(in_data(kk,2)-mid_int)/sqrt(var_int)>5)
                in_data(kk,2) = mid_int;
            end
        end
    end
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
ii = [1:145,147:226,234:256,258:length(cut_info)];
cut_info_print = cut_info(ii,:);
ds_cut_info = downsample(cut_info,2);
%% PLETH
%% plotting part of tha data
PLETH_part1         = csvread('C:\Users\User\Documents\project\DATA\MDC_PULS_OXIM_PLETH\MDC_PULS_OXIM_PLETH_part_1.csv');
T0                      = PLETH_part1(1, 1); %for normalization of time
%% all files in folder
ii                      = 0;
all_data                = dir(['C:\Users\User\Documents\project\DATA\MDC_PULS_OXIM_PLETH','\*.csv']);%%has to be changed
[m, ~]                  = size(all_data);
cut_info                = zeros(m,6);
cut_info_sort           = zeros(m,6);
for file                = all_data'
    in_data             = csvread(['C:\Users\User\Documents\project\DATA\MDC_PULS_OXIM_PLETH\',file.name]);%%again
    ii                  = ii+1;

%% find average and variance of peaks
    [pks,loc]               = findpeaks(in_data(1:end,2), in_data(1:end,1), 'MinPeakHeight', 2500);
    diffs                   = diff(loc);

    %  cut_info = [original start time, original end time, normalized start time,
    % normalized end time, mean of section, variance of section]
    cut_info(ii,1:6)        = [ in_data(1,1), in_data(end,1), (in_data(1,1)-T0)/3600, (in_data(end,1)-T0)/3600, (0.2222/60)*mean(diffs), var(diffs)];     
end
%% sort according to time
[~,index]               = sort(cut_info(:,3),'ascend');
cut_info_sort(:,1:end)  = cut_info(index,1:end);

%% plot means and variances
jj                      = [1:72,74:234, 236:length(cut_info)];

%% plot
figure; hold on; title('ECG & PLETH');
xlabel('time [hour]'); 
yyaxis left; ylabel('beats per minute'); 
plot(mean(ds_cut_info(:,3:4),2)/3600, ds_cut_info(:,5), 'LineWidth', 2); 
set(gca, 'FontSize', 24);
yyaxis right; ylabel('PPG');
plot(mean(cut_info_sort(jj,3:4),2), cut_info_sort(jj,5),'LineWidth', 2);
legend('avarege distances between R pulses in time intervals','avarege distances between peaks of "Pulse Oximeter Pleth" during time');