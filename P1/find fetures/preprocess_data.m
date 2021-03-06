clear; close all; clc;

%% all files in folder
ii = 0;
all_data = dir(['D:\Users\tomerby2\Desktop\ECG_ELEC_POTL_II_250hz','\*.csv']);
for file = all_data'
    in_data = csvread(['D:\Users\tomerby2\Desktop\ECG_ELEC_POTL_II_250hz\',file.name]);
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
        f = 1/T;
    end
%% find average and variance R distances 
    [R_pks,R_loc] = findpeaks(in_data(1:end,2), in_data(1:end,1), 'MinPeakHeight', 8350);
    R_diffs =  diff(R_loc);
    if(ii==1)
        cut_info(ii,:) = [in_data(1,1), in_data(end,1), 0, T*L, mean(R_diffs), var(R_diffs)];
    else
        cut_info(ii,:) = [in_data(1,1), in_data(end,1), cut_info(ii-1,4)+T, cut_info(ii-1,4)+T*L, mean(R_diffs), var(R_diffs)];     
    end

end
%% plot means and variances
figure; scatter(mean(cut_info(:,3:4),2),cut_info(:,5),100,'Fill'); 
title(['avarege distances between R pulses in time intervals']);
xlabel('time [sec]');
figure; scatter(mean(cut_info(:,3:4),2),cut_info(:,6),100,'Fill'); 
title(['the variance of the avarege distances between R pulses in time intervals']);
xlabel('time [sec]');