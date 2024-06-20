CLPosStall=max(CLReMat(:,columnNumber));
CLNegStall=min(CLReMat(:,columnNumber));

[posStallIndex,~] = find(abs(CLReMat-max(CLReMat(:,columnNumber)))<0.0000001);
alphaPosStall=CLReMat(posStallIndex,1);
[negStallIndex,~] = find(abs(CLReMat-min(CLReMat(:,columnNumber)))<0.0000001);
alphaNegStall=CLReMat(negStallIndex,1);

CDPosStall=CDReMat(posStallIndex,columnNumber);
CDNegStall=CDReMat(negStallIndex,columnNumber);

L=1;
avgChord=1;
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

TotalCL=[CLNeg90s;CLReMat(negStallIndex+1:posStallIndex-1,columnNumber);CLPos90s];
TotalCD=[CDNeg90s;CDReMat(negStallIndex+1:posStallIndex-1,columnNumber);CDPos90s];