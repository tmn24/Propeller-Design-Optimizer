function [cl,cd] = getCoefVals2(ReOptions,Re,AoA,noSegments,TotalCL,TotalCD)
cl=zeros([noSegments,1]);
cd=zeros([noSegments,1]);
for r=1:noSegments
    if(Re(r)<ReOptions(1))
        cl(r) = TotalCL(floor((AoA(r)+90)/0.25+1),1);
        cd(r) = TotalCD(floor((AoA(r)+90)/0.25+1),1);
    elseif(Re(r)>ReOptions(end))
        cl(r) = TotalCL(floor((AoA(r)+90)/0.25+1),1);
        cd(r) = TotalCD(floor((AoA(r)+90)/0.25+1),1);
    else
        for i=1:length(ReOptions)-1
            if(ReOptions(i)<Re(r))
                dist=ReOptions(i+1)-ReOptions(i);
                lowProportion = (Re(r)-ReOptions(i))/dist;
                highProportion = 1-lowProportion;
                cl(r) = lowProportion*TotalCL(floor((AoA(r)+90)/0.25+1),i)+highProportion*TotalCL(floor((AoA(r)+90)/0.25+1),i+1);
                cd(r) = lowProportion*TotalCD(floor((AoA(r)+90)/0.25+1),i)+highProportion*TotalCD(floor((AoA(r)+90)/0.25+1),i+1);
            end
        end
    end
end