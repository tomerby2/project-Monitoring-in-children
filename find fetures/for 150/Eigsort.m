function [ index ] = Eigsort( Eig )
% returens Eig value sorted 

    L               = length(Eig);
    val             = zeros(1,L);
    
    for ii=1:L
        val(ii)     = Eig(ii,ii);
    end
    val             = val.*(val<1);
    [~,index]   = sort(val,'descend');
    
end

