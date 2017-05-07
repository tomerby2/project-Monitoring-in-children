clear; close all; clc;

%% all files in folder
ii = 0;
all_data = dir(['C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II','\*.csv']);
for file = all_data'
    in_data = csvread(['C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II\',file.name]);
    ii = ii+1;
%% clean artifacts
    L = length(in_data);
    l = floor(L/100);
    jj = l;
    for (jj=l:l:L)
        mid_int = median(in_data((jj-l+1):jj,2));
        var_int = var(in_data((jj-l+1):jj,2));
        for(kk=(jj-l+1):min(jj,L))
            if (abs(in_data(kk,2)-mid_int)/sqrt(var_int)>3)
                in_data(kk,2) = mid_int;
            end
        end
    end
%% find frequency and time resolution of data
    if ii==1
        T = in_data(2,1)-in_data(1,1);
        Fs = 1/T;
    end
%% find average, variance R distances and entropy 
    [R_pks,R_loc] = findpeaks(in_data(1:end,2), in_data(1:end,1), 'MinPeakHeight', 8350);
    R_diffs =  diff(R_loc);
    if(ii==1)
        cut_info(ii,:) = [in_data(1,1), in_data(end,1), 0, T*L, mean(R_diffs), var(R_diffs)];
   %insert entropy   -  cut_info(ii,7) = SampEn(,0.2*cut_info(ii,6),R_diffs);
    else
        cut_info(ii,:) = [in_data(1,1), in_data(end,1), cut_info(ii-1,4)+T, cut_info(ii-1,4)+T*L, mean(R_diffs), var(R_diffs)];     
    end
    fft_of_R_diffs = fftshift(fft(R_diffs));
    f = [0:(2*pi/length(R_diffs)):((2*pi)-(2*pi/length(R_diffs)))].';
end
%% sort acording to time
[~,index] = sort(cut_info(:,1),'ascend');
temp = cut_info;
cut_info(:,1:end) = temp(index,1:end);
%% plot means and variances
ii = [1:290,292:512,514:575,577:length(cut_info)];
figure; scatter(mean(cut_info(ii,3:4),2), cut_info(ii,5), 50, 'Fill'); 
title(['avarege distances between R pulses in time intervals']);
xlabel('time [sec]');
figure; scatter(mean(cut_info(ii,3:4),2), cut_info(ii,6), 50, 'Fill'); 
title(['the variance of the avarege distances between R pulses in time intervals']);
figure; histogram(cut_info(ii,5), 200); 
title('histogram of avarege distances between R pulses in time intervals');
xlabel('time [sec]');
figure; histogram(cut_info(ii,6), 200); 
title('histogram of the variance of the avarege distances between R pulses in time intervals');
figure; scatter(f, abs(fft_of_R_diffs), 50, 'Fill');
title('dft of the avarege distances between R pulses in time intervals');
xlabel('rad');