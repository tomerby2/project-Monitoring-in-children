function [ ] = clean_artifacts( in_data, fileName )

    % cut file in case of: 
    % 1) discontinuity in time 
    % 2) const value
    % 3) special case of blood pressure 

    L = length(in_data);
    start           = 1; % start of possible informative section of data
    thresh_count    = 150; %50 for ecg 250 Hz
    safe_bound      = 1500;
    prev_val        = in_data(1,2);
    count           = 1;
    delta_t         = diff(in_data(:,1));
    T0              = min(delta_t);
    
    epsilon         = 3;
    
    % handle special case of blood pressure
    sig              = in_data(:,2);
    [BPmax,max_locs] = findpeaks(sig, 'MinPeakHeight', mean(sig), 'MinPeakDistance', 40);
    [BPmin,~]        = findpeaks(-sig, 'MinPeakHeight', mean(-sig), 'MinPeakDistance', 40);
    ave_PP           = mean(BPmax) - mean(abs(BPmin)); %average peak to peak distance
    height_thresh_BP = 1.8*ave_PP + mean(abs(BPmin));
    safe_bound_BP      = 3500;
    thresh_BP        = 10;
    count_BP         = 0;
    ii               = 1;
    
    for jj=2:L
        if jj <= start
            continue
        end
        
        
%         % handle special case of blood pressure 
%         if (ii <= size(max_locs,1)) && (jj == max_locs(ii)) % check if jj is an index of maximum peak
%             if BPmax(ii) > height_thresh_BP
%                 if count_BP== 0
%                     jj_start = jj;
%                 end
%                 count_BP = count_BP + 1;
%             elseif count_BP > thresh_BP
%                 begin = max (jj_start-safe_bound_BP,1); 
%                 final = min(jj+safe_bound_BP,L); 
%                 in_data_part = in_data(start:begin,1:2);
%                 in_data_part = std_filter(in_data_part,L);
%                 name = sprintf('%s_%d.csv', fileName(1:end-4), start);
%                 %dlmwrite(name,in_data(begin:final,1:2),'delimiter',',','precision',13);
%                 dlmwrite(name,in_data_part,'delimiter',',','precision',13);
%                 start = final+1;
%                 count_BP = 0;
%                 continue;
%             else
%                 count_BP = 0;
%             end
%             ii = ii+1;  
%         end
        
        
        
        % handle const value
        if abs(in_data(jj,2)- prev_val) < epsilon
            count = count + 1 ;
            continue;
        else 
                if (count > thresh_count) % cut section of const value
                    begin = max (jj-count-safe_bound,1); % begin of const value
                    final = min(jj+safe_bound,L); % final of const value
                    name = sprintf('%s_%d.csv', fileName(1:end-4), start);
                    if start + safe_bound < begin
                        in_data_part = in_data(start:begin,1:2);
                        in_data_part = std_filter(in_data_part,L);
                        %dlmwrite(name,in_data(begin:final,1:2),'delimiter',',','precision',13);
                        dlmwrite(name,in_data_part,'delimiter',',','precision',13)
%                     else % do not forget!!!
%                          dlmwrite(name,in_data(start:final,1:2),'delimiter',',','precision',13);
                     end
                    
                    start = final+1;
                    prev_val = in_data(start,2);
                    count = 1;
                else % not cut
                    prev_val = in_data(jj,2);
                    count = 1;  
                end
        end
        
          % handle discontinuity in time
        if delta_t(jj-1) > 2*T0 
               in_data_part = in_data(start:jj-1,1:2);
               in_data_part = std_filter(in_data_part,L);
               name = sprintf('%s_%d.csv', fileName(1:end-4), start);
               dlmwrite(name,in_data_part,'delimiter',',','precision',13);
               start = jj+1;
               continue
        end
    end
    
    
    if (count > thresh_count) % if file ends with const value
        begin = max (jj-count-safe_bound,1);
        if start + safe_bound < begin
            in_data_part = in_data(start:begin,1:2);
            in_data_part = std_filter(in_data_part,L);
            name = sprintf('%s_%d.csv', fileName(1:end-4), start);
            %dlmwrite(name,in_data(begin:end,1:2),'delimiter',',','precision',13);
            dlmwrite(name, in_data_part, 'delimiter', ',', 'precision', 13);
        end
    elseif count_BP > thresh_BP % if file ends with special case of blood pressure
                begin = max (jj_start-safe_bound_BP,1); 
                in_data_part = in_data(start:begin,1:2);
                in_data_part = std_filter(in_data_part,L);
                name = sprintf('%s_%d.csv', fileName(1:end-4), start);
                %dlmwrite(name,in_data(begin:end,1:2),'delimiter',',','precision',13);
                dlmwrite(name,in_data_part,'delimiter',',','precision',13)
    else % if file does not end with const value or special case of blood pressure
         in_data_part = in_data(start:end,1:2);
         in_data_part = std_filter(in_data_part,L);
         name = sprintf('%s_%d.csv', fileName(1:end-4), start);
         dlmwrite(name, in_data_part, 'delimiter', ',', 'precision', 13);
    end

end

