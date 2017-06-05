close all;
clear;
clc;

    dirPath_wave        = 'C:\Users\User\Documents\project\clean data\FLOW_AWAY_cleaned\';
    Files_wave          = dir([dirPath_wave, '*.csv']);
    dirPath_cyc         = 'C:\Users\User\Documents\project\clean data\cyc_diffs_FLOW_AWAY\';
    Files_cyc           = dir([dirPath_cyc, '*.csv']);
    L                   = length(Files_wave);
    
    % cut_info = [section start time , section end time, normalized start time,
    % normalized end time, average beat rate, varience of beat rate]
    cut_info            = zeros(L,8);
    histograms_wave     = zeros(L,99);
    histograms_cyc      = zeros(L,99);
    N                   = 2^10;
    abs_F               = zeros(L,N);
    
    for ii = 1 : L
    % reading wave    
        fileName_wave   = Files_wave(ii).name;
        mX              = csvread([dirPath_wave, fileName_wave]);
        ecgsig          = mX(:,2);
        tm              = mX(:,1);
    % find cycle
        fileName_cyc    = Files_cyc(ii).name;
        cyc_diffs       = csvread([dirPath_cyc, fileName_cyc]);

    %% find average and variance of cycle distances
        cut_info(ii,:)  = [tm(1), tm(end), 0, 0, 60/mean(cyc_diffs), 60/var(cyc_diffs), 60/max(cyc_diffs), 60/min(cyc_diffs)]; % beats per minute
        
    %% creating matrix with histogram rows for wave
        edges                   = linspace(1700,2300,100);
        histograms_wave(ii,:)   = histcounts(ecgsig,edges)/length(ecgsig); 
        
    %% creating matrix with histogram rows for cyc   
        edges               = linspace(1,6,100);
        histograms_cyc(ii,:) = histcounts(cyc_diffs,edges)/length(cyc_diffs); 
        
    %% creating matrix with fourier rows
            abs_F(ii,:)     =  abs(fft(ecgsig-mean(ecgsig),N))';
            
    end
    %% show histograms
%     figure;
%     for kk=1:length(histograms_RR)
%         bar(histograms_RR(kk,:));
%         pause(0.3);
%     end
    %% sort the files according to time
    [~,index]               = sort(cut_info(:,1),'ascend');
    
    temp_info               = cut_info;
    cut_info                = temp_info(index,:);
    
    temp_hist               = histograms_wave;
    histograms_wave         = temp_hist(index,:);
    
    temp_hist               = histograms_cyc;
    histograms_cyc           = temp_hist(index,:);
       
    F_tmp                   = abs_F;
    abs_F                   = F_tmp(index,1:N/2);
    
    % normalization & units
    cut_info(:,3)       = (cut_info(:,1)-cut_info(1,1))/3600; % normalize by first sample
    cut_info(:,4)       = (cut_info(:,2)-cut_info(1,1))/3600; % and change units to hours
    %% diffusion map on histograms wave 
    [EigVec_h_wave, EigVal_h_wave] = diffusion_map(histograms_wave, 1);
    
    %% diffusion map on histograms cyc 
    [EigVec_h_cyc, EigVal_h_cyc] = diffusion_map(histograms_cyc, 1);
          
    %% diffusion map on abs fft
    [EigVec_f, EigVal_f] = diffusion_map(abs_F, 1);
     
    %% diffusion map on mean & var & max & min
    [EigVec, EigVal] = diffusion_map(cut_info(:,5:8), 1);
    
    %% plot average heart rate
    figure; hold on; title('average breath rate in cut (about 13 minutes) from FLOW AWAY');
    xlabel('time [hour]'); 
    ylabel('bearths per minute'); 
    plot(mean(cut_info(:,3:4),2), cut_info(:,5), 'LineWidth', 1); 
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    
    %% plotting diffusion map of histograms wave
    figure; hold on; scatter3(EigVec_h_wave(:,2), EigVec_h_wave(:,3), EigVec_h_wave(:,4), 100, mean(cut_info(:,3:4),2) ,'Fill'); colorbar;
    title('diffusion map on histograms of the full FLOW AWAY wave ');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of histograms cyc
    figure; hold on; scatter3(EigVec_h_cyc(:,2), EigVec_h_cyc(:,3), EigVec_h_cyc(:,4), 100, mean(cut_info(:,3:4),2) ,'Fill'); colorbar;
    title('diffusion map on histograms of the cyc distances of FLOW AWAY');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    set(gca, 'FontSize', 24);
    grid on;
    hold off;
    %% plotting diffusion map of abs fft
    figure; hold on; scatter3(EigVec_f(:,2), EigVec_f(:,3), EigVec_f(:,4), 100 ,mean(cut_info(:,3:4),2), 'Fill'); colorbar;
    title('diffusion map of abs fft of FLOW AWAY');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;
    %% plotting diffusion map of mean & var & max & min
    figure; hold on; scatter3(EigVec(:,2), EigVec(:,3), EigVec(:,4), 100 ,mean(cut_info(:,3:4),2), 'Fill'); colorbar;
    title('diffusion map of mean & var & max & min of FLOW AWAY');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    set(gca, 'FontSize', 24); 
    grid on;
    hold off;