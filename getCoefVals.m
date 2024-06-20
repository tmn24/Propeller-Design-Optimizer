function [cl,cd] = getCoefVals(L,Re,AoA,chord,CLReMat,CDReMat)
ReOptions=[100,200,300,400]*1000;
cl=zeros(size(chord));
cd=zeros(size(chord));
TotalCL=zeros(size(CLReMat,1),length(ReOptions));
columnNumber=2;
CLPosStall=max(CLReMat(:,columnNumber));
CLNegStall=min(CLReMat(:,columnNumber));

[posStallIndex,~] = find(abs(CLReMat(:,columnNumber)-max(CLReMat(:,columnNumber)))<0.0000001);
alphaPosStall=CLReMat(posStallIndex(1),1);
[negStallIndex,~] = find(abs(CLReMat(:,columnNumber)-min(CLReMat(:,columnNumber)))<0.0000001);
alphaNegStall=CLReMat(negStallIndex(1),1);

CDPosStall=CDReMat(posStallIndex(1),columnNumber);
CDNegStall=CDReMat(negStallIndex(1),columnNumber);

avgChord=mean(chord);
AR=L/avgChord;
CDMax=1.1+0.018*AR;
A1Pos=CDMax/2;
A2Pos=(CLPosStall-CDMax*sind(alphaPosStall)*cosd(alphaPosStall))*sind(alphaPosStall)/cosd(alphaPosStall)^2;

A1Neg=CDMax/2;
A2Neg=(CLNegStall-CDMax*sind(alphaNegStall)*cosd(alphaNegStall))*sind(alphaNegStall)/cosd(alphaNegStall)^2;

B1Pos=CDMax;
B2Pos=CDPosStall-CDMax*sind(alphaPosStall)^2/cosd(alphaPosStall);

B1Neg=CDMax;
B2Neg=CDNegStall-CDMax*sind(alphaNegStall)^2/cosd(alphaNegStall);

alphaNeg=-90:0.25:alphaNegStall;
alphaPos=alphaPosStall:0.25:90;

CLPos90s=(A1Pos*sind(2*alphaPos)+A2Pos*cosd(alphaPos).^2./sind(alphaPos))';
CLNeg90s=(A1Neg*sind(2*alphaNeg)+A2Neg*cosd(alphaNeg).^2./sind(alphaNeg))';

CDPos90s=(B1Pos*sind(alphaPos).^2+B2Pos*cosd(alphaPos))';
CDNeg90s=(B1Neg*sind(alphaNeg).^2+B2Neg*cosd(alphaNeg))';

TotalCL(:,1)=[CLNeg90s;CLReMat(negStallIndex+1:posStallIndex-1,columnNumber);CLPos90s];
TotalCD(:,1)=[CDNeg90s;CDReMat(negStallIndex+1:posStallIndex-1,columnNumber);CDPos90s];
for i=3:5
    columnNumber=i;
    CLPosStall=max(CLReMat(:,columnNumber));
    CLNegStall=min(CLReMat(:,columnNumber));

    [posStallIndex,~] = find(abs(CLReMat(:,columnNumber)-max(CLReMat(:,columnNumber)))<0.000001);
    alphaPosStall=CLReMat(posStallIndex(1),1);
    [negStallIndex,~] = find(abs(CLReMat(:,columnNumber)-min(CLReMat(:,columnNumber)))<0.000001);
    alphaNegStall=CLReMat(negStallIndex(1),1);

    CDPosStall=CDReMat(posStallIndex(1),columnNumber);
    CDNegStall=CDReMat(negStallIndex(1),columnNumber);
    A1Pos=CDMax/2;
    A2Pos=(CLPosStall-CDMax*sind(alphaPosStall)*cosd(alphaPosStall))*sind(alphaPosStall)/cosd(alphaPosStall)^2;

    A1Neg=CDMax/2;
    A2Neg=(CLNegStall-CDMax*sind(alphaNegStall)*cosd(alphaNegStall))*sind(alphaNegStall)/cosd(alphaNegStall)^2;

    B1Pos=CDMax;
    B2Pos=CDPosStall-CDMax*sind(alphaPosStall)^2/cosd(alphaPosStall);

    B1Neg=CDMax;
    B2Neg=CDNegStall-CDMax*sind(alphaNegStall)^2/cosd(alphaNegStall);

    alphaNeg=-90:0.25:alphaNegStall;
    alphaPos=alphaPosStall:0.25:90;

    CLPos90s=(A1Pos*sind(2*alphaPos)+A2Pos*cosd(alphaPos).^2./sind(alphaPos))';
    CLNeg90s=(A1Neg*sind(2*alphaNeg)+A2Neg*cosd(alphaNeg).^2./sind(alphaNeg))';

    CDPos90s=(B1Pos*sind(alphaPos).^2+B2Pos*cosd(alphaPos))';
    CDNeg90s=(B1Neg*sind(alphaNeg).^2+B2Neg*cosd(alphaNeg))';

    TotalCL1=[CLNeg90s;CLReMat(negStallIndex+1:posStallIndex-1,columnNumber);CLPos90s];
    TotalCD1=[CDNeg90s;CDReMat(negStallIndex+1:posStallIndex-1,columnNumber);CDPos90s];

    TotalCL(:,i-1)=TotalCL1;
    TotalCD(:,i-1)=TotalCD1;
end
getCL=[CLReMat(:,1),TotalCL];
getCD=[CLReMat(:,1),TotalCD];
for r=1:length(chord)
    if(Re(r)<ReOptions)
        cl(r) = TotalCL(floor((AoA(r)+90)/0.25+1),1);
        cd(r) = TotalCD(floor((AoA(r)+90)/0.25+1),1);
    elseif(Re(r)>ReOptions)
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