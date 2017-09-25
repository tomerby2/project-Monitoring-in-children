close all;
clear;
clc;

    dirPath_wave        = 'C:\Users\User\Documents\project\DATA\new data\150\ECG_150\';
    Files_wave          = dir([dirPath_wave, '*.csv']);
    dirPath_RR          = 'C:\Users\User\Documents\project\DATA\new data\150\RR_wave_ecg\';
    Files_RR            = dir([dirPath_RR, '*.csv']);
    L                   = length(Files_wave);
    
    % cut_info = [section start time , section end time, normalized start time,
    % normalized end time, average beat rate, varience of beat rate]
    cut_info            = zeros(L,9);
    histograms_wave     = zeros(L,99);
    histograms_RR       = zeros(L,99);
    N                   = 2^10;
    abs_F               = zeros(L,N);
    
    for ii = 1 : L
    % reading wave    
        fileName_wave   = Files_wave(ii).name;
        mX              = csvread([dirPath_wave, fileName_wave]);
        ecgsig          = mX(:,2);
        tm              = mX(:,1);
    % find RR wave
        fileName_RR     = Files_RR(ii).name;
        RR_diffs        = csvread([dirPath_RR, fileName_RR]);

    %% find average and variance of RR distances
        cut_info(ii,:)  = [tm(1), tm(end), 0, 0, 60/mean(RR_diffs), 60/var(RR_diffs), 60/max(RR_diffs), 60/min(RR_diffs),0]; % beats per minute
        
    %% creating matrix with histogram rows for wave
        edges                   = linspace(7500,8300,100);
        histograms_wave(ii,:)   = histcounts(ecgsig,edges)/length(ecgsig); 
        
    %% creating matrix with histogram rows for RR   
        edges               = linspace(0.35,0.8,100);
        histograms_RR(ii,:) = histcounts(RR_diffs,edges)/length(RR_diffs); 
        
    %% creating matrix with fourier rows
            abs_F(ii,:)     =  abs(fft(ecgsig-mean(ecgsig),N))';
            
    end
    
    %% show histograms
%     figure;
%     for kk=1:length(histograms_wave)
%         bar(histograms_RR(kk,:));
%         pause(0.3);
%     end
    %% sort the files according to time
    [~,index]               = sort(cut_info(:,1),'ascend');
    
    temp_info               = cut_info;
    cut_info                = temp_info(index,:);
    % classification according to "steps" in mean breaths 
%     cut_info(1:204,9)   = 1;
%     cut_info(205:367,9) = 2;    
%     cut_info(368:496,9) = 1;
%     cut_info(497:557,9) = 3;

    % classification according to end of midical breaths
    cut_info(1:47,9)   = 0;
    cut_info(48:end,9) = 1;  
    
    
    temp_hist               = histograms_wave;
    histograms_wave         = temp_hist(index,:);
    
    temp_hist               = histograms_RR;
    histograms_RR           = temp_hist(index,:);
       
    F_tmp                   = abs_F;
    abs_F                   = F_tmp(index,1:N/2);
    
    % normalization & units
    cut_info(:,3)       = (cut_info(:,1)-cut_info(1,1))/3600; % normalize by first sample
    cut_info(:,4)       = (cut_info(:,2)-cut_info(1,1))/3600; % and change units to hours
    %% diffusion map on histograms wave 
    [EigVec_h_wave, EigVal_h_wave] = diffusion_map(histograms_wave, 1);
    
    %% diffusion map on histograms RR 
    [EigVec_h_RR, EigVal_h_RR] = diffusion_map(histograms_RR, 1);
          
    %% diffusion map on abs fft
    [EigVec_f, EigVal_f] = diffusion_map(abs_F, 1);
     
    %% diffusion map on mean & var & max & min
    [EigVec, EigVal] = diffusion_map(cut_info(:,5:8), 1);
    
    %% plot average heart rate
    figure; hold on; title('average heart rate in cut (about 7 minutes) from ECG 250Hz');
    xlabel('time [hour]'); 
    ylabel('beats per minute'); 
    plot(mean(cut_info(:,3:4),2), cut_info(:,5), 'LineWidth', 1); 
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    
    %% plotting diffusion map of histograms wave colored according to time
    figure; hold on; scatter3(EigVec_h_wave(:,2), EigVec_h_wave(:,3), EigVec_h_wave(:,4), 100, mean(cut_info(:,3:4),2) ,'Fill'); c=colorbar;
    title('diffusion map on histograms of the full wave ');
    xlabel('\psi_1');
    ylabel('\psi_2');
    zlabel('\psi_3');
    c.Label.String = 'time';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of histograms wave colored according to "steps" in mean breaths
%     figure; hold on; scatter3(EigVec_h_wave(1:557,2), EigVec_h_wave(1:557,3), EigVec_h_wave(1:557,4), 100, cut_info(1:557,9) ,'Fill'); c=colorbar;
%     title('diffusion map on histograms of the full wave ');
%     xlabel('\psi_1');
%     ylabel('\psi_2');
%     zlabel('\psi_3');
%     c.Label.String = 'step';
%     set(gca, 'FontSize', 24); 
%     grid on;
%     hold off;
    %% plotting diffusion map of histograms wave colored according to end of midical breaths
    figure; hold on; scatter3(EigVec_h_wave(:,2), EigVec_h_wave(:,3), EigVec_h_wave(:,4), 100, cut_info(:,9) ,'Fill'); c=colorbar;
    title('diffusion map on histograms of the full wave ');
    xlabel('\psi_1');
    ylabel('\psi_2');
    zlabel('\psi_3');
    c.Label.String = 'with or without';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of histograms RR colored according to time
    figure; hold on; scatter3(EigVec_h_RR(:,2), EigVec_h_RR(:,3), EigVec_h_RR(:,4), 100, mean(cut_info(:,3:4),2) ,'Fill'); c=colorbar;
    title('diffusion map on histograms of the RR distances');
    xlabel('\psi_1');
    ylabel('\psi_2');
    zlabel('\psi_3');
    c.Label.String = 'time';
    set(gca, 'FontSize', 24);
    grid on;
    hold off;
    %% plotting diffusion map of histograms RR colored according to "steps" in mean breaths
%     figure; hold on; scatter3(EigVec_h_RR(1:557,2), EigVec_h_RR(1:557,3), EigVec_h_RR(1:557,4), 100, cut_info(1:557,9) ,'Fill'); c=colorbar;
%     title('diffusion map on histograms of the RR distances');
%     xlabel('\psi_1');
%     ylabel('\psi_2');
%     zlabel('\psi_3');
%     c.Label.String = 'step';
%     set(gca, 'FontSize', 24);
%     grid on;
%     hold off;
    %% plotting diffusion map of histograms RR colored according to end of midical breaths
    figure; hold on; scatter3(EigVec_h_RR(:,2), EigVec_h_RR(:,3), EigVec_h_RR(:,4), 100, cut_info(:,9) ,'Fill'); c=colorbar;
    title('diffusion map on histograms of the RR distances');
    xlabel('\psi_1');
    ylabel('\psi_2');
    zlabel('\psi_3');
    c.Label.String = 'with or without';
    set(gca, 'FontSize', 24);
    grid on;
    hold off;
    %% plotting diffusion map of abs fft colored according to time
    figure; hold on; scatter3(EigVec_f(:,2), EigVec_f(:,3), EigVec_f(:,4), 100 ,mean(cut_info(:,3:4),2), 'Fill'); c=colorbar;
    title('diffusion map of abs fft');
    xlabel('\psi_1');
    ylabel('\psi_2');
    zlabel('\psi_3');
    c.Label.String = 'time';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of abs fft colored according to "steps" in mean breaths
%     figure; hold on; scatter3(EigVec_f(1:557,2), EigVec_f(1:557,3), EigVec_f(1:557,4), 100 ,cut_info(1:557,9), 'Fill'); c=colorbar;
%     title('diffusion map of abs fft');
%     xlabel('\psi_1');
%     ylabel('\psi_2');
%     zlabel('\psi_3');
%     c.Label.String = 'step';
%     set(gca, 'FontSize', 24); 
%     grid on;
%     hold off;
    %% plotting diffusion map of abs fft colored according to end of midical breaths
    figure; hold on; scatter3(EigVec_f(:,2), EigVec_f(:,3), EigVec_f(:,4), 100 ,cut_info(:,9), 'Fill'); c=colorbar;
    title('diffusion map of abs fft');
    xlabel('\psi_1');
    ylabel('\psi_2');
    zlabel('\psi_3');
    c.Label.String = 'with or without';
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of mean & var & max & min
    figure; hold on; scatter3(EigVec(:,2), EigVec(:,3), EigVec(:,4), 100 ,mean(cut_info(:,3:4),2), 'Fill'); colorbar;
    title('diffusion map of mean & var & max & min');
    xlabel('\psi_1');
    ylabel('\psi_2');
    zlabel('\psi_3');
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;