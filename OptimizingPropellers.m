angVel = 1000/60*2*pi;
viscosity=0.001;
density=997;
%Four options for Theta and Chord
thetaOptions=linspace(0,40*pi/180,4);
chordOptions=linspace(0.02,0.1,4);

theta = table2array(combinations(thetaOptions,thetaOptions,thetaOptions,thetaOptions))';
chord = table2array(combinations(chordOptions,chordOptions,chordOptions,chordOptions))';
radius = linspace(0.02,0.06,4)';

noChordOptions = size(chord,2);
noThetaOptions = size(theta,2);

effSum=zeros(noChordOptions,noThetaOptions);
for vWater=2:1:5
    tic
    for c=1:noChordOptions
        for t=1:noThetaOptions
            chord1=chord(:,c);
            theta1=theta(:,t);
            vFoil=angVel*radius;
            vInf=sqrt(vFoil.^2+vWater^2);
            beta=atan(vWater./vFoil);
            AoA=(theta1-beta)*180/pi;
            Re=(density*vInf.*chord1)/viscosity;
            L=max(radius)-min(radius);
            [cl,cd] = getCoefVals(L,Re,AoA,chord1,CLReMat,CDReMat);
            eff=0;
            for i=1:length(chord1)
                eff=eff+(cl(i)*cos(theta1(i))-cd(i)*sin(theta1(i)))/(radius(i)*(cd(i)*cos(theta1(i))+cl(i)*sin(theta1(i))));
            end
            effSum(c,t)=effSum(c,t)+eff;
        end
    end
    vWater
    toc
end
effSum;
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