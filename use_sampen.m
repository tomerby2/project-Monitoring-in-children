close all; clc; clear;
ECG = csvread('C:\Users\User\Documents\project\DATA\ECG_ELEC_POTL_II_250hz\ECG_ELEC_POTL_II_250hz_part_1.csv');
[R_peaks,R_location] = findpeaks(ECG(:,2),ECG(:,1),'MinPeakHeight',8000);
R_diff = diff(R_location);
[entropy,A,B]=sampenc(R_diff , 5 , 0.2);