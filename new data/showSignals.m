
% show all patient's signals 

close all
clear;
clc;

dirPath = 'C:\Users\Ifat Abramovich\Documents\project\new data\0000142_1494541440032\';
Files   = dir([dirPath, '*.csv']);
L       = length(Files);


for ii       = 1 : L
    fileName = Files(ii).name;     
    mX       = csvread([dirPath, fileName]);
    ecgsig   = mX(:,2);
    tm       = mX(:,1);  
    total_tm =(tm(end)-tm(1))/60;
   
    figure;
    plot(tm, ecgsig,'linewidth',1.5);  grid on;   
    title(fileName); 
 
end
