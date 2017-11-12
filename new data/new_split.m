
% splittng according to time interval (and not according to number of
% points)

% time interval: 5 minutes

close all
clear;
clc

mX      = csvread('C:\Users\User\Documents\project\3-53_3\MDC_ECG_ELEC_POTL_II_250hz.csv');
sig     = mX(:,2);
tm      = mX(:,1);
dt      = tm(2)- tm(1);
step    = round(5*60/dt); % number of sampels in 5 minutes

[x,y]   = size(sig);
ii      = 1;
for jj  = 1:step:x
        part    = mX(jj:(min(jj+step-1,x)),1:2);
        name    = sprintf('P1_ECG_part_%d.csv',ii);
        dlmwrite(name, part, 'delimiter', ',', 'precision', 13);
        ii      = ii + 1; 
end