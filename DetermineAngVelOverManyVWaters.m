close all

%Power of Motor
motorPower=5; %Watts
%Incoming fluid speed/vehicle velocity
vW=0:0.1:30; %m/s
%Desired Lift
desiredThrust = 1; %Newtons
%Number of Blades
noBlades = 2;
BestChords
BestTheta;
angVel1=5000:100:5100;
TP=zeros(length(angVel1),length(vW));
ttP=zeros(length(angVel1),length(vW));
for k=1:length(vW)
vWater=vW(k);
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
ttP(j,k) = noBlades*vWater*sum((CL1.*cosd(BestTheta)-CD1.*sind(BestTheta))*0.5*density.*vInf.^2.*BestChords)*rad;
%Torque Power
TP(j,k)=noBlades*sum(angVel.*radius.*(CD1.*cosd(BestTheta)+CL1.*sind(BestTheta))*0.5*density.*vInf.^2.*BestChords)*rad-motorPower;
end
end
figure(1)
[vWW,aV] = meshgrid(vW,angVel1);
surf(aV,vWW,ttP./(TP+motorPower));
xlabel("Angular Velocity RPM")
ylabel("Fluid Velocity (m/s)")
zlabel("Efficiency")
title("Efficiency (Power out/Power in) vs. Angular Velocity and Fluid Speed")
axis([min(angVel1),max(angVel1),min(vW),max(vW),-1,1])
figure(2)
surf(aV,vWW,ttP./vWW);
xlabel("Angular Velocity RPM")
ylabel("Fluid Velocity (m/s)")
zlabel("Thrust (N)")
title("Thrust vs. Angular Velocity and Fluid Speed")
figure(3)
surf(aV,vWW,TP+motorPower);
xlabel("Angular Velocity RPM")
ylabel("Fluid Velocity (m/s)")
zlabel("Power (W)")
title("Torque Power Required (Power in) vs. Angular Velocity and Fluid Speed")
[x,y]=min(abs(TP));
[x1,y1]=max(ttP./(TP+motorPower));
expectedThrust = ttP(y)
expectedAngVel = angVel1(y)
bestAngVel=angVel1(y1)
percentDifference = (bestAngVel-expectedAngVel)/expectedAngVel
[X,Y]=min(abs(ttP./vWW-desiredThrust));
angVelatDesiredThrust=angVel1(Y)
PoweratDesiredThrust=TP(Y)+motorPower
figure
[x,y]=max((ttP./(TP+motorPower)));
THRUST=ttP./vWW;
plot(vW,THRUST(sub2ind(size(THRUST),y,1:141)))
xlabel("Fluid Velocity (m/s)")
ylabel("Thrust (N)")
title("Thrust at Peak Efficiency vs. Fluid Speed")
figure
surf(aV,vWW,ttP./vWW.*ttP./(TP+motorPower).*sign(ttP))
xlabel("Angular Velocity RPM")
ylabel("Fluid Velocity (m/s)")
zlabel("Efficiency*Thrust (N)")
title("Efficiency*Thrust vs. Angular Velocity")
axis([min(angVel1),max(angVel1),min(vW),max(vW),-1,max(max(ttP./vWW.*ttP./(TP+motorPower).*sign(ttP)))])
%axis([min(angVel1),max(angVel1),-1,1])