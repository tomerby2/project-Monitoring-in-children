function [ out_data ] = clean_artifacts( in_data )

    L = length(in_data);
%% setting nulls for not informative measurements
    
    thresh_count = 50;
    safe_bound = 1300;
    prev_val = in_data(1,2);
    count = 1;
    for jj=2:L
        if in_data(jj,2) == prev_val 
            count = count + 1 ;
        else 
                if (count > thresh_count)
                    begin = max (jj-count-safe_bound,1);
                    final = min(jj+safe_bound,L);
                    in_data(begin:final, 2) = NaN;
                end
                prev_val = in_data(jj,2);
                count = 1;     
        end
    end

    if (count > thresh_count)
        begin = max (jj-count-safe_bound,1);
        final = min(jj+safe_bound,L);
        in_data(begin:final, 2) = NaN;
    end    
               
%% filtering by using standard diviation  
    l = floor(L/100);
    for jj=l:l:L
        mid_int = median(in_data((jj-l+1):jj,2));
        var_int = var(in_data((jj-l+1):jj,2));
        for kk=(jj-l+1):min(jj,L)
            if (abs(in_data(kk,2)-mid_int)/sqrt(var_int)>1)
                in_data(kk,2) = mid_int;
            end
        end
    end
%% out         
    out_data = in_data;    
end

