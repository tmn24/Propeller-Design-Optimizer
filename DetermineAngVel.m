close all

%Power of Motor
motorPower=5; %Watts
%Incoming fluid speed/vehicle velocity
vWater=10; %m/s
%Desired Lift
desiredThrust = 1; %Newtons
%Number of Blades
noBlades = 2;
BestChords
BestTheta;
angVel1=0:1:4000;
TP=zeros(length(angVel1),1);
ttP=zeros(length(angVel1),1);
for j=1:length(angVel1)
angVel=angVel1(j)/60*2*pi;

vFoil=angVel.*radius;
vInf=sqrt(vFoil.^2+vWater^2);
beta=atand(vWater./vFoil);
AoA=(BestTheta-beta);
rad=radius(2)-radius(1);
Re=(density*vInf.*BestChords)/viscosity;
CL1=zeros(noSegments,1);
CD1=zeros(noSegments,1);
for i=1:noSegments
[CL1(i),CD1(i)] = getCoefVals3(ReOptions,Re(i),AoA(i),TotalCL,TotalCD);
end
%Thrust Power
ttP(j) = noBlades*vWater*sum((CL1.*cosd(BestTheta)-CD1.*sind(BestTheta))*0.5*density.*vInf.^2.*BestChords)*rad;
%Torque Power
TP(j)=noBlades*sum(angVel.*radius.*(CD1.*cosd(BestTheta)+CL1.*sind(BestTheta))*0.5*density.*vInf.^2.*BestChords)*rad-motorPower;
end
figure(1)
plot(angVel1,ttP./(TP+motorPower));
xlabel("Angular Velocity RPM")
ylabel("Efficiency")
title("Efficiency (Power out/Power in) vs. Angular Velocity")
axis([min(angVel1),max(angVel1),-1,1])
figure(2)
plot(angVel1,ttP/vWater);
xlabel("Angular Velocity RPM")
ylabel("Thrust (N)")
title("Thrust vs. Angular Velocity")
figure(3)
plot(angVel1,TP+motorPower);
xlabel("Angular Velocity RPM")
ylabel("Power (W)")
title("Torque Power Required (Power in) vs. Angular Velocity")
[x,y]=min(abs(TP));
[x1,y1]=max(ttP./(TP+motorPower));
expectedThrust = ttP(y)
expectedAngVel = angVel1(y)
bestAngVel=angVel1(y1)
percentDifference = (bestAngVel-expectedAngVel)/expectedAngVel
[X,Y]=min(abs(ttP/vWater-desiredThrust));
angVelatDesiredThrust=angVel1(Y)
PoweratDesiredThrust=TP(Y)+motorPower
%axis([min(angVel1),max(angVel1),-1,1])