close all;
clc;
clear;

%% create sphere 
N = 20;
[x, y, z]          = sphere(N);
x                  = x(:);
y                  = y(:);
z                  = z(:);
vIdx               = z > 0;
x                  = x(vIdx);
y                  = y(vIdx);
z                  = z(vIdx);
X                  = [x, y, z];
mDist              = squareform(pdist(X));

%% sphere - isomap
k = 10;
[mappedX, mapping] = isomap(mDist, 3, k);

%% sphere - diffusion map
 epsilon = 1 * median(mDist(:));
    K       = exp(-mDist.^2 / epsilon.^2);
    A       =  K./sum(K, 2);
    
   [EigVec, EigVal] = eig(A);
%% plot

figure; scatter3(x(:), y(:), z(:), 100, z, 'Fill'); colorbar;
    title('sphere upper half');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    set(gca, 'FontSize', 24);
    
figure; scatter3(mappedX(:,1),mappedX(:,2), mappedX(:,3), 100, z, 'Fill'); colorbar;
    title('isomap of sphere upper half');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    set(gca, 'FontSize', 24);

figure; scatter3(EigVec(:,2), EigVec(:,3), EigVec(:,4), 100, z, 'Fill'); colorbar;
    title('diffusion map of sphere upper half');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
    set(gca, 'FontSize', 24);

