function [multi_time,g2,g2_error] = g2full2multi(time,g2_full,varargin)

Delay=[1 1 1 1 1 1 1 1 2 2 2 2 4 4 4 4 8 8 8 8 16 16 16 16 32 32 32 32 64 64 64 64 128 128 128 128 256 256 256 256];

'g2full2multi is dependent on framespacing; Use with CAUTION!'

    if isempty(varargin)
        multi_time=[11.08;22.16;33.23;44.31;55.39;66.47;77.54;88.62;110.78;...
            132.93;155.09;177.24;221.56;265.87;310.18;354.49;443.11;531.73;...
            620.36;708.98;886.22;1063.47;1240.71;1417.95;1772.44;2126.93;...
            2481.42;2835.91;3544.89;4253.86;4962.84;5671.82;7089.77;8507.73;9925.68;11343.64;14180.12;17016.6];
    else
        multi_time=varargin{1,1};
    end
    
index_tmp=find(multi_time<time(end),1,'last');
multi_time(index_tmp+1:end)=[];

    if (size(multi_time,1)>8)

        g2=g2_full(1:8);
        g2_error(1:8,1)=g2_full(1:8).*0;

        for i = 9:size(multi_time,1)
            [~,loc]=min(abs(time-multi_time(i)));
            if loc+Delay(i)/2-1<size(time,1)
                g2(i,1)=mean(g2_full(loc-Delay(i)/2:loc+Delay(i)/2-1));
                g2_error(i,1)=std(g2_full(loc-Delay(i)/2:loc+Delay(i)/2-1));
            else
                'Averaging Truncated!'
                g2(i,1)=mean(g2_full(loc-Delay(i)/2:end));
                g2_error(i,1)=std(g2_full(loc-Delay(i)/2:end));
            end
        end

    else
        g2=g2_full;
        g2_error=g2.*0;
        multi_time=time;
    end

end

