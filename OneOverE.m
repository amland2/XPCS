function [X,Y] = OneOverE(SmoothTT,Factor,AverageWidth)
size_C=size(SmoothTT,1);
if nargin<2
    Factor = 0.8
end
if nargin<3
AverageWidth=64
end
X=[];
Y=[];
%Factor=0.8;
for i = 1:1:size_C
    tmp=find((SmoothTT(i,i:size_C)-1)<Factor*(SmoothTT(i,i)-1),1,'first');
    if isempty(tmp)==1
        X(i)=i;
        Y(i)=NaN;
    else
        X(i)=i;
        Y(i)=tmp+i-1;
    end
end
Y=movmean(Y,AverageWidth);
end