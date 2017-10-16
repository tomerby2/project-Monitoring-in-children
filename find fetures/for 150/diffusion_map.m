function [ EigVec, EigVal ] = diffusion_map( features, k )

% diffusion map on features matrix 

    mDist   = squareform(pdist(features));
    epsilon = k * median(mDist(:));
    K       = exp(-mDist.^2 / epsilon.^2);
    A       = bsxfun(@rdivide, K, sum(K, 2));

    [EigVec, EigVal] = eig(A);


end

