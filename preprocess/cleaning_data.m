close all;
clear;
clc;

dirPath = 'C:\Users\User\Documents\project\DATA\MDC_PULS_OXIM_PLETH\';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);
for ii = 1 : L
    fileName    = Files(ii).name;
    data_in     = csvread([dirPath, fileName]);
    clean_artifacts(data_in, fileName);
    
end