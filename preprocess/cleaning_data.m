close all;
clear;
clc;

dirPath = 'C:\Users\ifatabr\Desktop\ECG_ELEC_POTL_II_250hz\';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);
for ii = 1 : L
    fileName    = Files(ii).name;
    data_in     = csvread([dirPath, fileName]);
    clean_artifacts(data_in, fileName);
    
end