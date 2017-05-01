clear; close all; clc;

%% all files in folder
ii = 0;
all_data = dir(['C:\Users\User\Desktop\New folder','\*.csv']);
for file = all_data'
    in_data = csvread(['C:\Users\User\Desktop\New folder\',file.name]);
    ii = ii+1;
%% find frequency and time resolution of data
    if ii==1
        T = in_data(2,1)-in_data(1,1);
        f = 1/T;
    end
%% find average and variance R distances 
    [R_pks,R_loc] = findpeaks(in_data(1:end,2), in_data(1:end,1), 'MinPeakHeight', 8500);
    R_diffs =  diff(R_loc);
    cut_info(ii,:) = [in_data(1,1), in_data(end,1), mean(R_diffs), var(R_diffs)];
%% clean artifacts
    l = length(in_data)/100;
    jj = l;
    for (jj=l:l:length(in_data))
        mid_int = median(in_data((jj-l+1):jj,2));
        var_int = var(in_data((jj-l+1):jj,2));
        for(kk=(jj-l+1):jj)
            if ((in_data(kk)-mid_int)/sqrt(var_int)>5)
                in_data(kk) = mid_int;
            end
        end
    end
        
        



end
