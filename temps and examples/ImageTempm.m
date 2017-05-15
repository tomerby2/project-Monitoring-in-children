close all
clear;

I = double( imread('cameraman.tif') );
figure; imshow(I, []);

IF = fft2(I - mean(I(:)));
figure; imshow(fftshift(abs(IF)), []);