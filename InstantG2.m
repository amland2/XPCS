function [TwoTimeData] = InstantG2(SmoothTT,TwoTimeData)
size_TT=size(SmoothTT,1);

filename=TwoTimeData.filename;
loc = strfind(filename,'_T');
filename(loc(1):end) =[];
plottitle=filename;
plottitle(strfind(plottitle,'_'):end)=[];
    
AverageWidth=TwoTimeData.AverageWidth;
framespacing=TwoTimeData.framespacing;    
    
    TT_Diagonal=NaN(size_TT,size_TT);
    TT_Diagonal_Error=NaN(size_TT,size_TT);
    for i = 0:size_TT-1
        tmp1=movmean(diag(SmoothTT,-i),AverageWidth);
        tmp2=movstd(diag(SmoothTT,-i),AverageWidth);
        TT_Diagonal(1:size(tmp1,1),i+1)=tmp1;
        TT_Diagonal_Error(1:size(tmp2,1),i+1)=tmp2;
    end

    figure
    hold on
    g2_wf=[];
    g2_wf_error=[];
    InstantFitParams=[];
    Tau8=[];
    for i = 1:AverageWidth:size_TT-mod(size_TT,AverageWidth)
        j=i+AverageWidth/2;
        
        g2_tmp=TT_Diagonal(j,:)';
        g2_tmp_error=TT_Diagonal_Error(j,:)';
        time=(1:size(g2_tmp,1))'.*framespacing;
        
        [multi_time,g2,g2_error] = g2full2multi(time,g2_tmp);
        
        g2_wf=cat(2,g2_wf,g2);
        g2_wf_error=cat(2,g2_wf_error,g2_error);
        
        
        size_IFP=size(InstantFitParams,1);
        [g2_fit,InstantFitParams(size_IFP+1,1),InstantFitParams(size_IFP+1,2),InstantFitParams(size_IFP+1,3),...
            InstantFitParams(size_IFP+1,4),InstantFitParams(size_IFP+1,5),InstantFitParams(size_IFP+1,6)]...
            = fitstrchexp(multi_time,g2,0.*g2_error);%'Fit uses 0 error'
        
        
        %tmp_tau8=(0.1116.^(1/InstantFitParams(size_IFP+1,3))).*InstantFitParams(size_IFP+1,2);
        %tmp_tau8_index=find((g2-1)<0.8*g2(1),1,'first');
        tmp_tau8_index=find((g2_fit-1)<0.8*InstantFitParams(size_IFP+1,1),1,'first');
    if isempty(tmp_tau8_index)==1
        Tau8(size_IFP+1,1)=NaN;
    else
        Tau8(size_IFP+1,1)=multi_time(tmp_tau8_index);
    end
        %g2_tmp(isnan(g2_tmp))=[];
        %plot3((1:size(g2_tmp,1)).*framespacing,g2_tmp,ones(size(g2_tmp,1),1).*j);
        
    end
    
    X=1:AverageWidth:size_TT-mod(size_TT,AverageWidth);
    WaitingTime=(X+AverageWidth/2).*framespacing;
    %Time=(1:size_TT).*framespacing;
    
    multi_time=[11.08;22.16;33.23;44.31;55.39;66.47;77.54;88.62;110.78;...
            132.93;155.09;177.24;221.56;265.87;310.18;354.49;443.11;531.73;...
            620.36;708.98;886.22;1063.47;1240.71;1417.95;1772.44;2126.93;...
            2481.42;2835.91;3544.89;4253.86;4962.84;5671.82;7089.77;8507.73;9925.68;11343.64;14180.12;17016.6];
    'This part of code is dependent on framespacing; Use with CAUTION!'
    multi_time(size(g2_wf',2)+1:end)=[];
    fig1=waterfall(multi_time,WaitingTime,g2_wf');
    set(gca, 'XScale', 'log');title(plottitle);
    plot3(Tau8,WaitingTime,1+0.8*InstantFitParams(:,1),'-o');
    
    
    figname=strcat(pwd,'\Figures\InstantG2\',filename,'_InstantG2.fig');
    try
    saveas(gcf,figname)
    catch
    mkdir(strcat(pwd,'\Figures\InstantG2\'))
    saveas(gcf,figname)
    end
    
    hold off
    close(gcf)
    
    TwoTimeData.InstantFitParams=InstantFitParams;
    TwoTimeData.WaitingTime=WaitingTime;
    TwoTimeData.InstantG2Plot.multi_time=multi_time;
    TwoTimeData.InstantG2Plot.g2_waterfall=g2_wf;
    TwoTimeData.InstantG2Plot.g2_waterfall_error=g2_wf_error;
    TwoTimeData.Tau8=Tau8;
    
    errorbar(WaitingTime,InstantFitParams(:,1),InstantFitParams(:,4));
    xlim([0 Inf]);title(plottitle);
    xlabel('Time (sec)');ylabel('G2plat')
    figname=strcat(pwd,'\Figures\InstantG2\G2plat\',filename,'_InstantG2_G2plat.tif');
    try
    saveas(gcf,figname)
    catch
    mkdir(strcat(pwd,'\Figures\InstantG2\G2plat\'))
    saveas(gcf,figname)
    end
    close(gcf)
    
    errorbar(WaitingTime,InstantFitParams(:,2),InstantFitParams(:,5));
    set(gca, 'YScale', 'log');title(plottitle);
    xlabel('Time (sec)');ylabel('Tau (sec)')
    figname=strcat(pwd,'\Figures\InstantG2\Tau\',filename,'_InstantG2_Tau.tif');
    try
    saveas(gcf,figname)
    catch
    mkdir(strcat(pwd,'\Figures\InstantG2\Tau\'))
    saveas(gcf,figname)
    end
    close(gcf)
    
    plot(WaitingTime,Tau8,'-o');
    set(gca, 'YScale', 'log');title(plottitle);
    xlabel('Time (sec)');ylabel('Tau8 (sec)')
    figname=strcat(pwd,'\Figures\InstantG2\Tau8\',filename,'_InstantG2_Tau8.tif');
    try
    saveas(gcf,figname)
    catch
    mkdir(strcat(pwd,'\Figures\InstantG2\Tau8\'))
    saveas(gcf,figname)
    end
    close(gcf)
    
    errorbar(WaitingTime,InstantFitParams(:,3),InstantFitParams(:,6));
    title(plottitle);
    xlabel('Time (sec)');ylabel('Beta')
    figname=strcat(pwd,'\Figures\InstantG2\Beta\',filename,'_InstantG2_Beta.tif');
    try
    saveas(gcf,figname)
    catch
    mkdir(strcat(pwd,'\Figures\InstantG2\Beta\'))
    saveas(gcf,figname)
    end
    close(gcf)
end

