function [] = TwoTimePlotter(filename,FitParams,GaussFiltParam)
load(filename,'ccdimginfo','TwoTimeInfo');
TwoTimeData.filename=filename;
filename(strfind(filename,'.mat'):end)=[];

TwoTimeData.GaussFiltParam=GaussFiltParam;

TT=TwoTimeInfo.C{1,1};
framespacing=TwoTimeInfo.framespacing;
TwoTimeData.framespacing=framespacing;

SmoothTT = imgaussfilt(TT,GaussFiltParam);
TwoTimeData.SmoothTT=SmoothTT;
TwoTimeData.AverageWidth=64;

%SmoothTT=TT;
[OneOverE_X_1,OneOverE_Y_1]=OneOverE(SmoothTT,0.1353);
%[OneOverE_X_2,OneOverE_Y_2]=OneOverE(SmoothTT,0.3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TTCF with lines
plottitle=filename;
plottitle(strfind(plottitle,'_'):end)=[];
imagesc(SmoothTT,'XData',[1,size(SmoothTT,1)]*framespacing,...
        'YData',[1,size(SmoothTT,1)]*framespacing);axis image;axis xy;colorbar;colormap('jet');title(plottitle);
   
    hold on
    plot(OneOverE_X_1*framespacing,OneOverE_Y_1*framespacing,'g',OneOverE_Y_1*framespacing,OneOverE_X_1*framespacing,'r','LineWidth',2);
    %plot(OneOverE_X_2*framespacing,OneOverE_Y_2*framespacing,'r',OneOverE_Y_2*framespacing,OneOverE_X_2*framespacing,'r','LineWidth',2);
    xlabel('t_1 (sec)');ylabel('t_2 (sec)')
    caxis([1 1+1.1*FitParams(1)])
    hold off

set(gca,'fontsize',20)
set(gcf,'Units','normalized');
set(gcf,'Position',[0 0 1 1]);
set(gcf,'PaperPosition',[.25 .25 8 8])

figname1=strcat(pwd,'\Figures\TwoTime\',filename,'.tif');
try
    saveas(gcf,figname1)
catch
    mkdir(strcat(pwd,'\Figures\TwoTime\'))
    saveas(gcf,figname1)
end
close(gcf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TTCF sans lines

plottitle=filename;
plottitle(strfind(plottitle,'_'):end)=[];
imagesc(SmoothTT,'XData',[1,size(SmoothTT,1)]*framespacing,...
        'YData',[1,size(SmoothTT,1)]*framespacing);axis image;axis xy;colorbar;colormap('jet');title(plottitle);
   
    xlabel('t_1 (sec)');ylabel('t_2 (sec)')
    caxis([1 1+1.1*FitParams(1)])

set(gca,'fontsize',20)
set(gcf,'Units','normalized');
set(gcf,'Position',[0 0 1 1]);
set(gcf,'PaperPosition',[.25 .25 8 8])

figname3=strcat(pwd,'\Figures\TwoTime\SansDecayLines\',filename,'.tif');
try
    saveas(gcf,figname3)
catch
    mkdir(strcat(pwd,'\Figures\TwoTime\SansDecayLines\'))
    saveas(gcf,figname3)
end
close(gcf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Intensity

plot((1:1:size(TwoTimeInfo.I0t,2)).*framespacing,TwoTimeInfo.I0t,'LineWidth',2);
set(gca,'fontsize',20)
set(gcf,'Units','normalized');
set(gcf,'Position',[0 0 1 0.25]);

figname2=strcat(pwd,'\Figures\TwoTime\',filename,'_Intensity.tif');
try
    saveas(gcf,figname2)
catch
    mkdir(strcat(pwd,'\Figures\TwoTime\'))
    saveas(gcf,figname2)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TTCF Intensity combo
img1=imread(figname1);
img2=imread(figname2);
size1=size(img1);
size2=size(img2);
img2=imresize(img2,[size2(1)*(size1(2)/size2(2)) size1(2)]);
img3=[img1; img2];
imshow(img3,'Border','tight')


try
saveas(gcf,strcat(pwd,'\Figures\TwoTime\Combined\',filename,'_Combined.tif'))
catch
    mkdir(strcat(pwd,'\Figures\TwoTime\Combined\'))
    saveas(gcf,strcat(pwd,'\Figures\TwoTime\Combined\',filename,'_Combined.tif'))
end

hold off
close(gcf)

delete(figname2)

%[TwoTimeData] = InstantG2(SmoothTT,TwoTimeData);
try
save(strcat(pwd,'\TwoTimeData\',filename,'Data.mat'),'TwoTimeData');
catch
    mkdir(strcat(pwd,'\TwoTimeData\'));
    save(strcat(pwd,'\TwoTimeData\',filename,'Data.mat'),'TwoTimeData');
end

end