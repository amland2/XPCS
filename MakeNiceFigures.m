function [] = MakeNiceFigures()
    
    if nargin == 0
        FileNamesStruct=dir('*.fig');
        FileNamesStruct=struct2cell(FileNamesStruct);
        filenames=FileNamesStruct(1,:)';
    end
    try
        mkdir Tifs
    catch
    end
    for i=1:numel(filenames)
        openfig(filenames{i});
        ax=gca;
        ax.Title=[];
        ax.YTick=ax.XTick;
        ax.FontSize=34;
        ax.FontWeight='bold';
        figname=filenames{i};
        figname(strfind(figname,'_'):end)=[];
        ax.YLabel=[];
        saveas(gcf,strcat(pwd,'\Tifs\',figname,'.tif'))
        close(gcf)
    end
    
end