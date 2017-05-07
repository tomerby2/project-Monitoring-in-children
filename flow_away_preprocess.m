clear; close all; clc;

%% plotting part of tha data
N                       = 3000; %number of points to show
FLOW_AWAY_part1         = csvread('C:\Users\User\Documents\project\DATA\FLOW_AWAY\FLOW_AWAY_part_1.csv');
figure; plot(FLOW_AWAY_part1(1:N, 1), FLOW_AWAY_part1(1:N, 2), 'LineWidth', 2);
    title('section of FLOW AWAY');
    xlabel('time');
 
T0                      = FLOW_AWAY_part1(1, 1); %for normalization of time
 
 %% finding frequency of part1
 L                      = length(FLOW_AWAY_part1);
 T                      = FLOW_AWAY_part1(2, 1) - FLOW_AWAY_part1(1, 1);
 Fs                     = 1/T;
 f                      = (Fs*((-L/2):(L/2-1))/L)';
 FFT                    = fft(FLOW_AWAY_part1(:,2));
 figure; plot(f, log(1+abs(fftshift(FFT))), 'LineWidth', 2);
    title('fft of first part in FLOW AWAY');
    xlabel('freq');
 
%% all files in folder
ii                      = 0;
all_data                = dir(['C:\Users\User\Documents\project\DATA\FLOW_AWAY','\*.csv']);%%has to be changed
[m, ~]                  = size(all_data);
cut_info                = zeros(m,6);
cut_info_sort           = zeros(m,6);
for file                = all_data'
    in_data             = csvread(['C:\Users\User\Documents\project\DATA\FLOW_AWAY\',file.name]);%%again
    ii                  = ii+1;
    
    %%ploting anomaly
    if( ii == 273)
        figure; plot(in_data(:, 1), in_data(:, 2), 'LineWidth', 2);
            title('anomaly');
            xlabel('time');
    end

%% find average and variance of "FLOW OUT"  peaks
[pks,loc]               = findpeaks(in_data(1:end,2), in_data(1:end,1), 'MinPeakHeight', 2050);
diffs                   = diff(loc);

%  cut_info = [original start time, original end time, normalized start time,
% normalized end time, mean of section, variance of section]
cut_info(ii,1:6)        = [ in_data(1,1), in_data(end,1), (in_data(1,1)-T0)/3600, (in_data(end,1)-T0)/3600, (40/3)*mean(diffs), (40/3)*var(diffs)];     


end
%% sort according to time
[~,index]               = sort(cut_info(:,3),'ascend');
cut_info_sort(:,1:end)  = cut_info(index,1:end);

%% plot means and variances
jj                      = [1:72,74:length(cut_info)];
figure; plot(mean(cut_info_sort(jj,3:4),2), cut_info_sort(jj,5), 'LineWidth', 2); 
    title('avarege distances between peaks of "FLOW OUT" during time');
    xlabel('time [hours]');
    ylabel('flow out per minute');
figure; histogram(cut_info_sort(jj,5));
figure; plot(mean(cut_info_sort(jj,3:4),2), cut_info_sort(jj,6), 'LineWidth', 2); 
    title('variance of distances between peaks of "FLOW OUT" during time');
    xlabel('time [hours]');
