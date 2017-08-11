close all;
clear;
clc;

    dirPath = 'C:\Users\Ifat Abramovich\Documents\project\new data\0000135_1488712397544\';
    fileName = '0000135_1488712397544_MDC_ECG_ELEC_POTL_I.csv';     
    mX       = csvread([dirPath, fileName]);
    ecgsig   = mX(:,2);
    tm       = mX(:,1);
    total_tm = (tm(end)-tm(1))/60;

    wt           = modwt(ecgsig,5);
    wtrec        = zeros(size(wt));
    wtrec(4:5,:) = wt(4:5,:);
    y            = imodwt(wtrec,'sym4');
    y            = abs(y).^2;
    [ypeaks,ylocs]  = findpeaks(y,'MinPeakHeight', mean(y), 'MinPeakDistance', 100);
    [qrspeaks,locs] = findpeaks(y,'MinPeakHeight', mean(ypeaks)/2, 'MinPeakDistance', 100);
    rr_locs         = locs(ecgsig(locs)> mean(ecgsig));
    RR_diffs        = diff(rr_locs);
    rr_tm = (tm(rr_locs) - tm(rr_locs(1)))/60;

     
    %% diffusion map on RR_diffs
    [EigVec, EigVal] = diffusion_map(RR_diffs', 1);
    
    %% plotting 
    figure; hold on; scatter(EigVec(:,2), EigVec(:,3), 100 , rr_tm(1:end-1) , 'Fill'); c = colorbar;
    title('diffusion map of RR diffs');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    c.Label.String = 'time[min]';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;