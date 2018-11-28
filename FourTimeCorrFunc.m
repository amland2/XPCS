%function [g4_data] = FourTimeCorrFunc(TwoTimeInfo)

C=TwoTimeInfo.C{1,1};
framespacing=TwoTimeInfo.framespacing;
%% 
WaitingTime=((1:1:size(C,1)).*framespacing)';

SmoothC=imgaussfilt(C,5);
%SmoothC=C;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Standard Deviation
    for index_C=1:size(SmoothC,1)
        C_diagarray=diag(SmoothC,index_C-1);
        VarianC(index_C,1)=var(C_diagarray);
    end

MaxTauFactor=0.75; %SET LESS THAN ONE
MaxTauFactor=min(MaxTauFactor,0.99);
Tau=((1:1:round(MaxTauFactor*size(SmoothC,1),0)).*framespacing)';
VarianC=VarianC(1:round(MaxTauFactor*size(SmoothC,1),0),1);

TwoTimeInfo.FourTime.VarianC=VarianC;
TwoTimeInfo.FourTime.Tau=Tau;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GapTime Tau  
    
MaxGapFactor=0.75; %SET LESS THAN ONE %This factor will determine what the max gaptime will be wrt the length in time of the diagonal at the given Tau;
MaxGapFactor=min(MaxGapFactor,0.99);

g4=[];
g4_WaitingTime=[];
tic
    for index_Tau=1:size(Tau,1)
        C_diagarray=diag(SmoothC,index_Tau-1);
        MaxGapIndex=round(MaxGapFactor*size(C_diagarray,1),0); %This is an array index, not a time
        
        g4_temp=[];
        for index_GapTime = 1:MaxGapIndex
            C_One=C_diagarray(1:size(C_diagarray,1)-index_GapTime);
            C_Two=C_diagarray(index_GapTime+1:size(C_diagarray,1));
            g4_temp(index_GapTime,1)=mean(C_One.*C_Two)./(mean(C_diagarray)).^2;
        end
        g4{index_Tau,1}=g4_temp;
        g4_WaitingTime{index_Tau,1}=(1:1:MaxGapIndex).*framespacing;
    end
toc

plot(Tau,VarianC)

%end