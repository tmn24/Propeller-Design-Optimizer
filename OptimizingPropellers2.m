angVel = 1000/60*2*pi;
viscosity=0.001;
density=997;
noSegments=3;
noThetaOptions=3;
noChordOptions=1;
%Four options for Theta and Chord
thetaOptions=linspace(23*pi/180,36*pi/180,noThetaOptions);
chordOptions=linspace(0.02,0.1,noChordOptions);

theta=zeros(noSegments,noThetaOptions^noSegments);
chord=zeros(noSegments,noChordOptions^noSegments);
%Create theta and chord
noTheta = length(thetaOptions);
I=ones(1,noSegments);
increment=1;
while(any(I ~= ones(1,noSegments)*noTheta))
    theta(:,increment) = thetaOptions(I)';
    increment=increment+1;
    I(1)=I(1)+1;
    for j=2:noSegments
        if(I(j-1)==noTheta+1)
            I(j)=I(j)+1;
            I(j-1)=1;
        end
    end
end
theta(:,end) = thetaOptions(I)';
noChord = length(chordOptions);
I=ones(1,noSegments);
increment=1;
while(any(I ~= ones(1,noSegments)*noChord))
    chord(:,increment) = chordOptions(I)';
    increment=increment+1;
    I(1)=I(1)+1;
    for j=2:noSegments
        if(I(j-1)==noChord+1)
            I(j)=I(j)+1;
            I(j-1)=1;
        end
    end
end
chord(:,end) = chordOptions(I)';
disp("Made chord and theta")
%theta = table2array(combinations(thetaOptions,thetaOptions,thetaOptions,thetaOptions,thetaOptions))';
%chord = table2array(combinations(chordOptions,chordOptions,chordOptions,chordOptions,chordOptions))';
radius = linspace(0.02,0.06,noSegments)';

%theta=[0.613065233053470,0.433838985495733,0.468158905240832;0.713065233053470,0.463838985495733,0.968158905240832]';

ReOptions=[100,200,300,400]*1000;
TotalCL=zeros(size(CLReMat,1),length(ReOptions));
TotalCD=zeros(size(CLReMat,1),length(ReOptions));
columnNumber=2;
CLPosStall=max(CLReMat(:,columnNumber));
CLNegStall=min(CLReMat(:,columnNumber));

[posStallIndex,~] = find(abs(CLReMat(:,columnNumber)-max(CLReMat(:,columnNumber)))<0.0000001);
alphaPosStall=CLReMat(posStallIndex(1),1);
[negStallIndex,~] = find(abs(CLReMat(:,columnNumber)-min(CLReMat(:,columnNumber)))<0.0000001);
alphaNegStall=CLReMat(negStallIndex(1),1);

CDPosStall=CDReMat(posStallIndex(1),columnNumber);
CDNegStall=CDReMat(negStallIndex(1),columnNumber);

%avgChord=mean(chord);
%AR=L/avgChord;
%CDMax=1.1+0.018*AR;
CDMax=1.28;
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
noThetaCombinations=noThetaOptions^noSegments;
noChordCombinations=noChordOptions^noSegments;

disp("Made TotalCL")
effSum=zeros(noChordCombinations,noThetaCombinations);
vW=2:0.2:5;
nVw=length(vW);
for vWater=vW
    tic
    for c=1:noChordCombinations
        for t=1:noThetaCombinations
            chord1=chord(:,c);
            theta1=theta(:,t);
            vFoil=angVel*radius;
            vInf=sqrt(vFoil.^2+vWater^2);
            beta=atan(vWater./vFoil);
            AoA=(theta1-beta)*180/pi;
            Re=(density*vInf.*chord1)/viscosity;
            L=max(radius)-min(radius);
            [cl,cd] = getCoefVals2(ReOptions,Re,AoA,noSegments,TotalCL,TotalCD);
            eff=0;
            for i=1:length(chord1)
                thrustPower = vWater*(cl(i)*cos(theta1(i))-cd(i)*sin(theta1(i)));
                torquePower=angVel*radius(i)*(cd(i)*cos(theta1(i))+cl(i)*sin(theta1(i)));
                eff=eff+thrustPower/torquePower;
            end
            effSum(c,t)=effSum(c,t)+eff;
        end
    end
    vWater
    toc
end
effSum=effSum/nVw;
disp("done!")

%{
for vWater = 2:0.5:5
vFoil=angVel*radius;
Re=(angVel*radius.*chord)/viscosity;
beta=atan(vWater./vFoil);
AoA=(theta-beta)*180/pi;
[coefLift,coefDrag]=getCoefVals(Re,AoA,chord,CLReMat,CDReMat);
efficiency=(coefLift.*cos(theta)-coefDrag.*sin(theta))./(radius.*(coefDrag.*cos(theta)+coefLift.*sin(theta)));
effSum=effSum+efficiency;
end
%}