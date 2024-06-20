function [cl,cd] = getCoefVals3(ReOptions,Re,AoA,TotalCL,TotalCD)
cl=0;
cd=0;
if(Re<ReOptions(1))
    cl = TotalCL(floor((AoA+90)/0.25+1),1);
    cd = TotalCD(floor((AoA+90)/0.25+1),1);
elseif(Re>ReOptions(end))
    cl = TotalCL(floor((AoA+90)/0.25+1),1);
    cd = TotalCD(floor((AoA+90)/0.25+1),1);
else
    for i=1:length(ReOptions)-1
        if(ReOptions(i)<Re)
            dist=ReOptions(i+1)-ReOptions(i);
            lowProportion = (Re-ReOptions(i))/dist;
            highProportion = 1-lowProportion;
            cl = lowProportion*TotalCL(floor((AoA+90)/0.25+1),i)+highProportion*TotalCL(floor((AoA+90)/0.25+1),i+1);
            cd = lowProportion*TotalCD(floor((AoA+90)/0.25+1),i)+highProportion*TotalCD(floor((AoA+90)/0.25+1),i+1);
        end
    end
end