%Expected RPM of Propeller
RPM=5000;
angVel = RPM/60*2*pi; %Rad/s
%viscosity=0.001; %Water
viscosity=1.81*10^-5; %Air %Pa*s
%density=997; %Water
density=1.225; %Air kg/m^3
%How many different segments to test at
noSegments=5;

noThetaOptions=500;
noChordOptions=200;

theta=linspace(0*pi/180,90*pi/180,noThetaOptions); %Rad
chord=linspace(0.02,0.1,noChordOptions); %m
%Create theta and chord
disp("Made chord and theta")
%Radii of propeller segments
radius = linspace(0.0254*0.25,2*0.0254,noSegments)';
%Incoming Fluid velocity/Vehicle Velocity
vW=linspace(0,30,floor(100)); %m/s

%theta=[0.613065233053470,0.433838985495733,0.468158905240832;0.713065233053470,0.463838985495733,0.968158905240832]';
% hd2galaxy.com
ReOptions=[100,200,300,400]*1000;
TotalCL=zeros(size(CLReMat,1),length(ReOptions));
TotalCD=zeros(size(CLReMat,1),length(ReOptions));
columnNumber=2;%dont change
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

disp("Made TotalCL")
effSum=zeros(noChordOptions,noThetaOptions,noSegments);

nVw=length(vW);
tic
for vWater=vW
    %tic
    for s=1:noSegments
        for c=1:noChordOptions
            for t=1:noThetaOptions
                chord1=chord(c);
                theta1=theta(t);
                vFoil=angVel*radius(s);
                vInf=sqrt(vFoil.^2+vWater^2);
                beta=atan(vWater./vFoil);
                AoA=(theta1-beta)*180/pi;
                Re=(density*vInf.*chord1)/viscosity;
                [cl,cd] = getCoefVals3(ReOptions,Re,AoA,TotalCL,TotalCD);
                thrustPower = vWater*(cl*cos(theta1)-cd*sin(theta1));
                torquePower=angVel*radius(s)*(cd*cos(theta1)+cl*sin(theta1));
                effSum(c,t,s)=effSum(c,t,s)+sign(thrustPower)*abs(thrustPower/torquePower);
            end
        end
    end
    %vWater
    %toc
end
toc
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