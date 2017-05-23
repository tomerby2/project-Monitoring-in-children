function [ out_data ] = std_filter( in_data,L )
%% filtering by using standard diviation  
    l = floor(L/100);
    for jj=l:l:length(in_data)
        mid_int = median(in_data((jj-l+1):jj,2));
        var_int = var(in_data((jj-l+1):jj,2));
        for kk=(jj-l+1):min(jj,L)
            if (abs(in_data(kk,2)-mid_int)/sqrt(var_int)>5)
                in_data(kk,2) = mid_int;
            end
        end
    end     
    
    out_data = in_data;    
end

