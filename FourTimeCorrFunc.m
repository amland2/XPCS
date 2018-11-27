%function [g4_data] = FourTimeCorrFunc(TwoTimeInfo)

C=TwoTimeInfo.C{1,1};
framespacing=TwoTimeInfo.framespacing;
WaitingTime=(1:1:size(C,1)).*framespacing;

gpu_C=gpuarray(C);
    for index_WaitingTime=1:size(C,1)
        
    end
%end

