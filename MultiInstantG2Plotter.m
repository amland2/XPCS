function [] = MultiInstantG2Plotter(SampleArray)

load('TwoTimeDataFilenames.mat');

filename=[];

Colors=['b' 'g' 'r' 'c' 'm' 'y' 'k'];
ColorIndex=0;
plottitle=[];
for index=SampleArray
    ColorIndex=ColorIndex+1;
    filenameTwoTime=TwoTimeDataFilenames(index,1).name;
    loc = strfind(filenameTwoTime,'_');
    filenameTwoTime(loc(1):end)=[];
    filename=[filename,'_',filenameTwoTime];
    plottitle=[plottitle,Colors(ColorIndex),filenameTwoTime];
end
filename=[filename(2:end),'_MultiRelTime'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on

ColorIndex=0;

for index=SampleArray
    ColorIndex=ColorIndex+1;
    filenameTwoTime=TwoTimeDataFilenames(index,1).name;
    load(strcat(pwd,'\TwoTimeData\',filenameTwoTime),'TwoTimeData');
    
    InstantFitParams=TwoTimeData.InstantFitParams;
    WaitingTime=TwoTimeData.WaitingTime;
    Tau8=TwoTimeData.Tau8;
    
    errorbar(WaitingTime,InstantFitParams(:,1),InstantFitParams(:,4),...
        Colors(ColorIndex),'LineWidth',2.5);
end
hold off

title(plottitle)
% set(gca, 'XScale', 'log')
% set(gca, 'YScale', 'log')
%xlim([0 20000]) 
%ylim([-Inf Inf])
xlabel('Waiting Time (s)','FontSize',22);
ylabel('G2plat','FontSize',22);

saveas(gcf,strcat(pwd,'\Figures\Multi_InstantG2\G2plat\',filename,'_G2plat.tif'))
close(gcf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on

ColorIndex=0;

for index=SampleArray
    ColorIndex=ColorIndex+1;
    filenameTwoTime=TwoTimeDataFilenames(index,1).name;
    load(strcat(pwd,'\TwoTimeData\',filenameTwoTime),'TwoTimeData');
    
    InstantFitParams=TwoTimeData.InstantFitParams;
    WaitingTime=TwoTimeData.WaitingTime;
    Tau8=TwoTimeData.Tau8;
    

    plot(WaitingTime,Tau8,...
        Colors(ColorIndex),'LineWidth',2.5,'Marker','o');

end
hold off

title(plottitle)
% set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
%xlim([0 20000]) 
%ylim([-Inf Inf])
xlabel('Waiting Time (s)','FontSize',22);
ylabel('Tau 0.8','FontSize',22);

saveas(gcf,strcat(pwd,'\Figures\Multi_InstantG2\Tau8\',filename,'_Tau8.tif'))
close(gcf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on

ColorIndex=0;

for index=SampleArray
    ColorIndex=ColorIndex+1;
    filenameTwoTime=TwoTimeDataFilenames(index,1).name;
    load(strcat(pwd,'\TwoTimeData\',filenameTwoTime),'TwoTimeData');
    
    InstantFitParams=TwoTimeData.InstantFitParams;
    WaitingTime=TwoTimeData.WaitingTime;
    
errorbar(WaitingTime,InstantFitParams(:,3),InstantFitParams(:,6),...
        Colors(ColorIndex),'LineStyle','none','LineWidth',1,'Marker','o');
end
hold off

title(plottitle)
% set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
%xlim([0 20000]) 
ylim([0 4])
xlabel('Waiting Time (s)','FontSize',22);
ylabel('Beta','FontSize',22);

saveas(gcf,strcat(pwd,'\Figures\Multi_InstantG2\Beta\',filename,'_Beta.tif'))
close(gcf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

