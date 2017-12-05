clear; close all; clc;

%% plotting part of tha data
N                       = 1000; %number of points to show
PLETH_part1         = csvread('C:\Users\יפעת\Desktop\MDC_PULS_OXIM_PLETH\MDC_PULS_OXIM_PLETH_part_1.csv');
figure; grid on; set(gca, 'FontSize', 24); plot(PLETH_part1(1:N, 1), PLETH_part1(1:N, 2), 'LineWidth', 2);
    title('section of "Pulse Oximeter Pleth"');
    xlabel('time');
 
T0                      = PLETH_part1(1, 1); %for normalization of time
%% all files in folder
ii                      = 0;
all_data                = dir(['C:\Users\יפעת\Desktop\MDC_PULS_OXIM_PLETH','\*.csv']);%%has to be changed
[m, ~]                  = size(all_data);
cut_info                = zeros(m,6);
cut_info_sort           = zeros(m,6);
for file                = all_data'
    in_data             = csvread(['C:\Users\יפעת\Desktop\MDC_PULS_OXIM_PLETH\',file.name]);%%again
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
figure; grid on; set(gca, 'FontSize', 24); plot(mean(cut_info_sort(jj,3:4),2), cut_info_sort(jj,5), 'LineWidth', 2); 
    title('avarege distances between peaks of "Pulse Oximeter Pleth" during time');
    xlabel('time [hours]');
    ylabel('PPG per minute');
figure; grid on; set(gca, 'FontSize', 24); histogram(cut_info_sort(jj,5));
    xlabel('PPG per minute');
    ylabel('frequancy');
figure; plot(mean(cut_info_sort(jj,3:4),2), cut_info_sort(jj,6), 'LineWidth', 2); 
    title('variance of distances between peaks of "Pulse Oximeter Pleth" during time');
    xlabel('time [hours]');
