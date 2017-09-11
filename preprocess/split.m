step= 100000;
ECG_150 = csvread('C:\Users\User\Documents\project\DATA\new data\150\0000150_1496373935344_MDC_ECG_ELEC_POTL_II.csv');
[x,y]=size(ECG_150);
for jj=1:step:x
        ECG_150_part = ECG_150(jj:(min(jj+step-1,x)),1:2);
        name = sprintf('ECG_150_part_%d.csv',jj);
        dlmwrite(name,ECG_150_part,'delimiter',',','precision',13);
end