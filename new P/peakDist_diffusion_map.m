% diffusion map on cycle distances (one file)

close all;
clear;
clc;

    %% read file

    dirPath     = 'C:\Users\User\Documents\project\DATA\new data\150\ECG_150\';
    fileName    = '0000142_1494541440032_MDC_PRESS_BLD_ART.csv';     
    mX          = csvread([dirPath, fileName]);
    sig         = mX(:,2);
    tm          = mX(:,1);
    tot_tm    = (tm(end)-tm(1))/3600; % total time in hours
    
    %% find peaks

    [~,max_locs]    = findpeaks(sig, 'MinPeakHeight', mean(sig), 'MinPeakDistance', 40);
    diffs           = diff(max_locs);
    rr_tm           = (tm(max_locs) - tm(1))/3600;

    %% diffusion map on RR_diffs
    [EigVec, EigVal] = diffusion_map(diffs(1:4000),1);
    
    %% plotting 9
    figure; hold on; scatter3(EigVec(:,2), EigVec(:,3),EigVec(:,4), 100 , rr_tm(1:4000) , 'Fill'); c = colorbar;
    title('diffusion map of RR diffs');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    c.Label.String = 'time[min]';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;