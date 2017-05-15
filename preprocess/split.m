step= 100000;
FLOW_AWAY = csvread('D:\Users\tomerby2\Desktop\MDC_FLOW_AWAY.csv');
[x,y]=size(FLOW_AWAY);
for jj=1:step:x
        FLOW_AWAY_part = FLOW_AWAY(jj:(min(jj+step-1,x)),1:2);
        name = sprintf('FLOW_AWAY_part_%d.csv',jj);
        dlmwrite(name,FLOW_AWAY_part,'delimiter',',','precision',13);
end