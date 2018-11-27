function [] = MultiG2Plotter(SampleArray)

load('g2_results.mat','Data','FitParams')
load('g2Filenames.mat');
filename=[];
Colors=['b' 'g' 'r' 'c' 'm' 'y' 'k'];
ColorIndex=0;
plottitle=[];
for index=SampleArray
    ColorIndex=ColorIndex+1;
    filenameg2=g2Filenames(index,1).name;
    loc = strfind(filenameg2,'_');
    filenameg2(loc(1):end)=[];
    filename=[filename,'_',filenameg2];
    plottitle=[plottitle,Colors(ColorIndex),filenameg2];
end
filename=[filename(2:end),'_g2'];

figure
hold on


ColorIndex=0;

for index=SampleArray
    ColorIndex=ColorIndex+1;
    Data_temp=Data{index,1};
    time=Data_temp(:,1);g2=Data_temp(:,2);g2_error=Data_temp(:,3);g2_fit=Data_temp(:,4);
    
    plot(time,g2_fit,Colors(ColorIndex),'LineWidth',2.5);
    errorbar(time,g2,g2_error,Colors(ColorIndex),'LineWidth',0.25)
    
end

title(plottitle)
set(gca, 'XScale', 'log')
xlim([0 20000]) 
ylim([1 inf])
xlabel('Time (s)','FontSize',22);
ylabel('g2','FontSize',22);

saveas(gcf,strcat(pwd,'\Figures\Multi_g2\',filename,'.tif'))
hold off
close(gcf)

ColorIndex=0;
figure
hold on
for index=SampleArray
    ColorIndex=ColorIndex+1;
    Data_temp=Data{index,1};
    time=Data_temp(:,1);g2_norm=(Data_temp(:,2)-1)./FitParams(index,1);
    g2_fit_norm=(Data_temp(:,4)-1)./FitParams(index,1);
    
    plot(time,g2_fit_norm,Colors(ColorIndex),'LineWidth',2.5)
    plot(time,g2_norm,Colors(ColorIndex),'LineWidth',0.25)
%errorbar(time,g2,g2_error,ColorIndex(index),'LineWidth',1.5)
end
title(plottitle)
set(gca, 'XScale', 'log')
xlim([0 20000]) 
ylim([0 1.1])
xlabel('Time (s)','FontSize',22);
ylabel('g2','FontSize',22);

saveas(gcf,strcat(pwd,'\Figures\Multi_g2\',filename,'_Normalized.tif'))
hold off
close(gcf)
end

