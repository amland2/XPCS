function [] = MakeTTCFimgs()
% Choose file
    if nargin == 0 % if no input path...
        [FileName,PathName] = uigetfile('*.*','Select the wfs file');
    end

    if(isunix)
        path = strcat(PathName, FileName);
    else
        path = strcat(PathName, '\',FileName);
    end
    
load(path)

FileName(strfind(FileName,'.mat'):end)=[];

GaussFiltParam=20
FitParams(1)=mean(TwoTimeInfo.g2full(1:10))-1

TT=TwoTimeInfo.C{1,1};
framespacing=TwoTimeInfo.framespacing;
TwoTimeData.framespacing=framespacing;

SmoothTT = imgaussfilt(TT,GaussFiltParam);

plottitle=FileName;
plottitle(strfind(plottitle,'_'):end)=[];
imagesc(SmoothTT,'XData',[1,size(SmoothTT,1)]*framespacing,...
        'YData',[1,size(SmoothTT,1)]*framespacing);axis image;axis xy;colorbar;colormap('jet');title(plottitle);
   
    %xlabel('t_1 (sec)');ylabel('t_2 (sec)')
    %caxis([1 1+1.1*FitParams(1)])
    caxis([1 Inf])
    set(gca,'fontsize',20)
    set(gca,'fontweight','bold')
set(gcf,'Units','normalized');
set(gcf,'Position',[0 0 1 1]);
set(gcf,'PaperPosition',[.25 .25 8 8])

figname_fig=strcat(pwd,'\TTCF_Figs\',FileName,'.fig');
figname_tif=strcat(pwd,'\TTCF_Tifs\',FileName,'.tif');
saveas(gcf,figname_fig)
saveas(gcf,figname_tif)

close(gcf)
end