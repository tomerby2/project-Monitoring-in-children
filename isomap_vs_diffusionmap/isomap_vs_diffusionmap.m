close all;
clc;
clear;

%% sphere - isomap
N = 20;
k = 4;
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
[mappedX, mapping] = isomap(mDist, 2, k);
%% sphere - diffusion map
 epsilon = 1 * median(mDist(:));
    K       = exp(-mDist.^2 / epsilon.^2);
    A       =  K./sum(K, 2);
    
     [EigVec, EigVal] = eig(A);
    %  EigVec = EigVec.*sum(K, 2); i want to use the same coordinates
%% plot
% figure; plot3(x(:), y(:), z(:), '.');
figure; scatter3(x(:), y(:), z(:), 100, z, 'Fill');
figure; scatter3(mappedX(:,1),mappedX(:,2), mappedX(:,1), 100, 'Fill');
    title('isomap of sphere upper half');
    xlabel('x');
    ylabel('y');
    zlabel('z');

figure; scatter3(EigVec(:,2), EigVec(:,3), EigVec(:,4), 100, z, 'Fill'); colorbar;
    title('diffusion map of sphere upper half');
    xlabel('\psi_2');
    ylabel('\psi_3');
    zlabel('\psi_4');
%% circle - isomap
% k = 2;
% theta = linspace(0, 2*pi ,100);
% x = cos(theta);
% y = sin(theta);
% figure; plot(x,y);
% X = [x(:) , y(:)];
% mDist = squareform(pdist(X));
% [mappedX, mapping] = isomap(mDist,1,k);
% 
% figure; plot(mappedX);


