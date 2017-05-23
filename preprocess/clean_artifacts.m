function [ ] = clean_artifacts( in_data, fileName )

    L = length(in_data);
%% setting nulls for not informative measurements
    
    start = 1; % start of possible informative section of data
    thresh_count = 50;
    safe_bound = 1300;
    prev_val = in_data(1,2);
    count = 1;
    for jj=2:L
        if jj <= start
            continue
        end
        if in_data(jj,2) == prev_val 
            count = count + 1 ;
        else 
                if (count > thresh_count) % cut section of const value
                    begin = max (jj-count-safe_bound,1); % begin of const value
                    final = min(jj+safe_bound,L); % final of const value
                    if start + safe_bound < begin
                        in_data_part = in_data(start:begin,1:2);
                        in_data_part = std_filter(in_data_part,L);
                        name = sprintf('%s_%d.csv', fileName(1:end-4), start);
                        dlmwrite(name,in_data_part,'delimiter',',','precision',13);
                    end
                    start = final+1;
                    prev_val = in_data(start,2);
                    count = 1;
                else % not cut
                    prev_val = in_data(jj,2);
                    count = 1;  
                end
        end
    end

    if (count > thresh_count) % if file ends with const value
        begin = max (jj-count-safe_bound,1);
        if start + safe_bound < begin
            in_data_part = in_data(start:begin,1:2);
            in_data_part = std_filter(in_data_part,L);
            name = sprintf('%s_%d.csv', fileName(1:end-4), start);
            dlmwrite(name, in_data_part, 'delimiter', ',', 'precision', 13);
        end 
    else % if file does not end with const value
         in_data_part = in_data(start:end,1:2);
         in_data_part = std_filter(in_data_part,L);
         name = sprintf('%s_%d.csv', fileName(1:end-4), start);
         dlmwrite(name, in_data_part, 'delimiter', ',', 'precision', 13);
    end

end

