

    dirPath             = 'C:\Users\User\Documents\project\clean data\ECG_ELEC_POTL_II_250hz_cleaned\';
    Files               = dir([dirPath, '*.csv']);
    L                   = length(Files);
    cut_info            = zeros(L,6);
    histograms          = zeros(L,99);
    N                   = 100000;
    abs_F               = zeros(L,N/10);
    % cut_info = [section start time , section end time, normalized start time,
    % normalized end time, average beat rate, varience of beat rate]
    for ii = 1 : L
        fileName        = Files(ii).name;
        mX              = csvread([dirPath, fileName]);
        ecgsig          = mX(:,2);
        tm              = mX(:,1);
    %% find RR wave
        wt              = modwt(ecgsig,5);
        wtrec           = zeros(size(wt));
        wtrec(4:5,:)    = wt(4:5,:);
        y               = imodwt(wtrec,'sym4');
        y               = abs(y).^2;
        [ypeaks,ylocs]  = findpeaks(y,'MinPeakHeight', mean(y), 'MinPeakDistance', 1);
        [qrspeaks,locs] = findpeaks(y,'MinPeakHeight', mean(ypeaks)/2, 'MinPeakDistance', 1);
        rr_locs         = tm(locs(ecgsig(locs)> mean(ecgsig)));
    %% find average and variance of RR distances
        RR_diffs        =  diff(rr_locs);
        cut_info(ii,:)  = [tm(1), tm(end), 0, 0, 60/mean(RR_diffs), 60/var(RR_diffs)]; % beats per minute
    %% creating matrix with histogram rows
        edges               = linspace(7300,9100,100);
        histograms(ii,:)    = histcounts(ecgsig,edges)/length(ecgsig); 
    %% creating matrix with fourier rows
        if length(ecgsig) > 10000 % do not take very short sections
            ecgsig_ds       = downsample(ecgsig,10);
            abs_F(ii,:)     =  abs(fft(ecgsig,N/10))';
        end
    end
    %% sort the files according to time
    [~,index]               = sort(cut_info(:,1),'ascend');
    temp_info               = cut_info;
    cut_info                = temp_info(index,:);
    
    temp_hist               = histograms;
    histograms              = temp_hist(index,:);
    
    F_tmp                   = abs_F;
    abs_F                   = F_tmp(index,:);
    abs_F(~any(abs_F,2),:)  = [];
    
    % normalization & units
    cut_info(:,3)       = (cut_info(:,1)-cut_info(1,1))/3600; % normalize by first sample
    cut_info(:,4)       = (cut_info(:,2)-cut_info(1,1))/3600; % and change units to hours
    %% diffusion map on histograms 
    mDist   = squareform(pdist(histograms));
    epsilon = 1 * median(mDist(:));
    K       = exp(-mDist.^2 / epsilon.^2);
    A       = bsxfun(@rdivide, K, sum(K, 2));

    [EigVec_h, EigVal_h] = eig(A);
      
    %% diffusion map on abs fft
    mDist_f     = squareform(pdist(abs_F(:,1:100)')); 
    epsilon_f   = 1 * median(mDist_f(:));
    K_f         = exp(-mDist_f.^2 / epsilon_f.^2);
    A_f         = bsxfun(@rdivide, K_f, sum(K_f, 2));

    [EigVec_f, EigVal_f] = eig(A_f);
    %% plot average heart rate
    figure; hold on; title('average heart rate in cut (about 7 minutes) from ECG 250Hz');
    xlabel('time [hour]'); 
    ylabel('beats per minute'); 
    plot(mean(cut_info(:,3:4),2), cut_info(:,5), 'LineWidth', 2); 
    set(gca, 'FontSize', 24); 
    hold off;
    
    %% plotting diffusion map of histograms
    figure; scatter3(EigVec_h(:,2), EigVec_h(:,3), EigVec_h(:,4), 100, mean(cut_info(:,3:4),2) ,'Fill'); colorbar;
    title('diffusion map of histograms');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
   
    %% plotting diffusion map of abs fft
    figure; scatter3(EigVec_f(:,2), EigVec_f(:,3), EigVec_f(:,4), 100 ,mean(cut_info(1:667,3:4),2), 'Fill'); colorbar;
    title('diffusion map of abs fft');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');