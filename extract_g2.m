function [FitParams,Data] = extract_g2(filename)

load(filename,'ccdimginfo','viewresultinfo')

g2avg=viewresultinfo.result.g2avg{1,1};
g2avgErr=viewresultinfo.result.g2avgErr{1,1};

time=viewresultinfo.result.delay{1, 1};
g2=reshape(g2avg,[size(g2avg,3),1,1]);
g2_error=reshape(g2avgErr,[size(g2avgErr,3),1,1]);


[fit2data,FitParams(1,1),FitParams(1,2),FitParams(1,3),FitParams(1,4),FitParams(1,5),FitParams(1,6)] = fitstrchexp(time,g2,g2_error);

g2avgFIT2=fit2data;
g2_fit=reshape(g2avgFIT2,[size(g2avgErr,3),1,1]);

figure
hold on

errorbar(time,g2,g2_error,'LineWidth',1.5)
plot(time,g2_fit,'LineWidth',2.5)

set(gca, 'XScale', 'log')
xlim([0 20000]) 
ylim([1 Inf])
xlabel('Time (s)','FontSize',22);
ylabel('g2','FontSize',22);
dim = [.2 .2 .3 .3];
str = ['g2 plat:' num2str(round(FitParams(1,1),4)) '\pm' num2str(round(FitParams(1,4),4)) newline...
    'Tau:' num2str(round(FitParams(1,2),0)) '\pm' num2str(round(FitParams(1,5),0)) newline...
    'Beta:' num2str(round(FitParams(1,3),2)) '\pm' num2str(round(FitParams(1,6),2))];
annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',14);

dim2 = [.8 .95 .005 .005];
loc = strfind(filename,'_');
SampleName=filename;
SampleName(loc(1):end) =[];
annotation('textbox',dim2,'String',SampleName,'FitBoxToText','on','FontSize',14);

loc = strfind(filename,'.');
filename(loc(1):end) =[];
saveas(gcf,strcat(pwd,'\Figures\g2\',filename,'_g2.tif'))
hold off
close(gcf)
Data=cat(2,time,g2,g2_error,g2_fit);
end