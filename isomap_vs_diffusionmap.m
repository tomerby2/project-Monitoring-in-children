close all;
clc;
clear;

%% sphere - isomap
% N = 50;
% k = 4;
% [x ,y , z] = sphere(N);
% figure; plot3(x(:),y(:),z(:));
% X = [x(:) , y(:) , z(:)];
% mDist = squareform(pdist(X));
% [mappedX, mapping] = isomap(mDist,2,k);
% 
% plot(mappedX(:,1),mappedX(:,2));

%% circle - isomap
k = 2;
theta = linspace(0, 2*pi ,100);
x = cos(theta);
y = sin(theta);
figure; plot(x,y);
X = [x(:) , y(:)];
mDist = squareform(pdist(X));
[mappedX, mapping] = isomap(mDist,1,k);

figure; plot(mappedX);
