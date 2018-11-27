function [D] = MyTwoTime(img)

FrameFraction=0.5
FrameLength=round(min(size(img)).*FrameFraction,0);
MaxLength=min(size(img));
Iqt=[];
movie_stack=[];
for i = 0:MaxLength-FrameLength
%     movie_frame=img(1+i:FrameLength+i,1+i:FrameLength+i);
%     movie_stack=cat(4,movie_stack,movie_frame);
    temp_frame=reshape(img(1+i:FrameLength+i,1:FrameLength),[],1);
    temp_frame=temp_frame./mean(temp_frame);
    Iqt=cat(2,Iqt,temp_frame);
    clear temp_frame
end
%C=zeros(MaxLength-FrameLength+1,MaxLength-FrameLength+1);

% for j = 1:MaxLength-FrameLength+1
%     for k = j:MaxLength-FrameLength+1
%         C(j,k)=mean(Iqt(:,j).*Iqt(:,k))/(mean(Iqt(:,j))*mean(Iqt(:,k)));
%         C(k,j)=C(j,k);
%     end
% end
C{1}=twotimeCPUorGPU(Iqt);

D = twotimediagonal(C{1});
end
