function [] = MultiRelTimePlotter(SampleArray)

load('g2_results.mat','Data','FitParams')
load('TwoTimeFilenames.mat');
filename=[];

Colors=['b' 'g' 'r' 'c' 'm' 'y' 'k'];
ColorIndex=0;
plottitle=[];
for index=SampleArray
    ColorIndex=ColorIndex+1;
    filenameTwoTime=TwoTimeFilenames(index,1).name;
    loc = strfind(filenameTwoTime,'_');
    filenameTwoTime(loc(1):end)=[];
    filename=[filename,'_',filenameTwoTime];
    plottitle=[plottitle,Colors(ColorIndex),filenameTwoTime];
end
filename=[filename(2:end),'_MultiRelTime'];

figure
hold on

ColorIndex=0;

for index=SampleArray
    ColorIndex=ColorIndex+1;
    filenameTwoTime=TwoTimeFilenames(index,1).name;
    load(filenameTwoTime,'ccdimginfo','TwoTimeInfo');
    TT=TwoTimeInfo.C{1,1};
    framespacing=TwoTimeInfo.framespacing;
    SmoothTT = imgaussfilt(TT,20);
    AverageWidth=64
    RelTime_tmp=findrelaxtime(SmoothTT).*framespacing;
    RelTime=movmean(RelTime_tmp,AverageWidth);
    RelTime_first=RelTime(find(isnan(RelTime)==0,1));
    plot((1:1:(size(SmoothTT,1))).*framespacing,(RelTime./RelTime_first),...
        Colors(ColorIndex),'LineWidth',2.5);
end
title(plottitle)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlim([0 20000]) 
%ylim([-Inf Inf])
xlabel('Waiting Time (s)','FontSize',22);
ylabel('Tau/Tau_0 0.8','FontSize',22);

saveas(gcf,strcat(pwd,'\Figures\InstantRelax\',filename,'_RelTime_Norm.tif'))


end
function RelTime_temp = findrelaxtime(SmoothTT)
RelTime_temp=[];
    parfor i = 1:1:size(SmoothTT,1)
    tmp=find((SmoothTT(i,i:size(SmoothTT,1))-1)<(0.8)*(SmoothTT(i,i)-1),1,'first');
        if isempty(tmp)==1
            RelTime_temp(i)=NaN;
        else
            RelTime_temp(i)=tmp-1;
        end
    end

end