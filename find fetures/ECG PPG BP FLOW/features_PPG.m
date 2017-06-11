close all;
clear;
clc;

    dirPath  = 'C:\Users\User\Documents\project\clean data\MDC_PULS_OXIM_PLETH_cleaned\';
    Files    = dir([dirPath, '*.csv']);
    L        = length(Files);

    % cut_info = [section start time , section end time, normalized start time,
    % normalized end time, average beat rate, varience of beat rate]
    cut_info            = zeros(L,9);
    histograms_wave     = zeros(L,99);
    histograms_peaks    = zeros(L,99);
    N                   = 2^10;
    abs_F               = zeros(L,N);
    
    for ii = 1 : L

        fileName    = Files(ii).name;     
        mX          = csvread([dirPath, fileName]);
        PPGsig      = mX(:,2);
        tm          = mX(:,1);

        [~,diffs]    = findpeaks(PPGsig,'MinPeakHeight',mean(PPGsig),'MinPeakDistance',40);

        %% find average and variance of peaks distances
            diffs                   =  diff(tm(diffs));
            cut_info(ii,:)          = [tm(1), tm(end), 0, 0, 60/mean(diffs), 60/var(diffs), 60/max(diffs), 60/min(diffs),0]; %beats per minute

        %% creating matrix with histogram rows for wave
            edges                   = linspace(1000,3100,100);
            histograms_wave(ii,:)   = histcounts(PPGsig,edges)/length(PPGsig); 
        %% creating matrix with histogram rows for peaks   
            edges                   = linspace(0.3,1.2,100);
            histograms_peaks(ii,:)  = histcounts(diffs,edges)/length(diffs); 
       
        %% creating matrix with fourier rows
            abs_F(ii,:)             =  abs(fft(PPGsig-mean(PPGsig),N))';
            
    end

    %% sort the files according to time
    [~,index]               = sort(cut_info(:,1),'ascend');
    
    temp_info               = cut_info;
    cut_info                = temp_info(index,:);
    
    % classification according to "steps" in mean breaths 
    cut_info(1:121,9)   = 1;
    cut_info(122:218,9) = 2;    
    cut_info(219:299,9) = 1;
    cut_info(300:340,9) = 3;
    
    temp_hist               = histograms_wave;
    histograms_wave         = temp_hist(index,:);
    
    temp_hist               = histograms_peaks;
    histograms_peaks        = temp_hist(index,:);
       
    F_tmp                   = abs_F;
    abs_F                   = F_tmp(index,1:N/2);
    
    % normalization & units
    cut_info(:,3)       = (cut_info(:,1)-cut_info(1,1))/3600; % normalize by first sample
    cut_info(:,4)       = (cut_info(:,2)-cut_info(1,1))/3600; % and change units to hours
    
    %% diffusion map on histograms wave 
    [EigVec_h_wave, EigVal_h_wave] = diffusion_map(histograms_wave, 4);
    
    %% diffusion map on histograms peaks 
    [EigVec_h_peaks, EigVal_h_peak] = diffusion_map(histograms_peaks, 1);
          
    %% diffusion map on abs fft
    [EigVec_f, EigVal_f]            = diffusion_map(abs_F, 1);
    %% diffusion map on mean & var & max & min
    [EigVec, EigVal] = diffusion_map(cut_info(:,5:8), 3);
    
    %% plot average heart rate
    figure; hold on; title('average heart rate in cut (about 13 minutes) from BP');
    xlabel('time [hour]'); 
    ylabel('beats per minute'); 
    plot(mean(cut_info(:,3:4),2), cut_info(:,5), 'LineWidth', 1); 
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    
    %% plotting diffusion map of histograms wave colored according to time
    figure; hold on; scatter3(EigVec_h_wave(:,2), EigVec_h_wave(:,3), EigVec_h_wave(:,4), 100, mean(cut_info(:,3:4),2) ,'Fill'); c=colorbar;
    title('diffusion map on histograms of the full wave ');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    c.Label.String = 'time';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of histograms wave colored according to "steps" in mean breaths
    figure; hold on; scatter3(EigVec_h_wave(1:340,2), EigVec_h_wave(1:340,3), EigVec_h_wave(1:340,4), 100, cut_info(1:340,9) ,'Fill'); c=colorbar;
    title('diffusion map on histograms of the full wave ');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    c.Label.String = 'step';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of histograms peaks colored according to time
    figure; hold on; scatter3(EigVec_h_peaks(:,2), EigVec_h_peaks(:,3), EigVec_h_peaks(:,4), 100, mean(cut_info(:,3:4),2) ,'Fill'); c=colorbar;
    title('diffusion map on histograms of the peaks distances');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    c.Label.String = 'time';
    set(gca, 'FontSize', 24);
    grid on;
    hold off;
    %% plotting diffusion map of histograms peaks colored according to "steps" in mean breaths
    figure; hold on; scatter3(EigVec_h_peaks(1:340,2), EigVec_h_peaks(1:340,3), EigVec_h_peaks(1:340,4), 100, cut_info(1:340,9) ,'Fill'); c=colorbar;
    title('diffusion map on histograms of the RR distances');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    c.Label.String = 'step';
    set(gca, 'FontSize', 24);
    grid on;
    hold off;
    %% plotting diffusion map of abs fft colored according to time
    figure; hold on; scatter3(EigVec_f(:,2), EigVec_f(:,3), EigVec_f(:,4), 100 ,mean(cut_info(:,3:4),2), 'Fill'); c=colorbar;
    title('diffusion map of abs fft');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    c.Label.String = 'time';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of abs fft colored according to "steps" in mean breaths
    figure; hold on; scatter3(EigVec_f(1:340,2), EigVec_f(1:340,3), EigVec_f(1:340,4), 100 ,cut_info(1:340,9), 'Fill'); c=colorbar;
    title('diffusion map of abs fft');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    c.Label.String = 'step';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of mean & var & max & min
    figure; hold on; scatter3(EigVec(:,2), EigVec(:,3), EigVec(:,4), 100 ,mean(cut_info(:,3:4),2), 'Fill'); colorbar;
    title('diffusion map of mean & var & max & min');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;