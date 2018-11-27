clear all

load('TwoTimeFilenames.mat');
%load('TifFilenames.mat');
load('g2Filenames.mat');
if (size(g2Filenames,1) ~= size(TwoTimeFilenames,1))
    warning('Check filename lists!!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = waitbar(0,'Wait pls XD');
for index=1:size(TwoTimeFilenames,1)
    waitbar(index/size(TwoTimeFilenames,1),f)
    %filenameg2=g2Filenames(index,1).name;
    %[FitParams(index,:),Data{index,1}]=extract_g2(filenameg2);
    filenameTwoTime=TwoTimeFilenames(index,1).name;
    try
        FitParams=FitParams;
    catch
        FitParams=Inf.*ones(size(TwoTimeFilenames));
    end
    TwoTimePlotter(filenameTwoTime,FitParams(index,:),GaussFiltParam(index));
end
close(f)

%save g2_results.mat FitParams Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%