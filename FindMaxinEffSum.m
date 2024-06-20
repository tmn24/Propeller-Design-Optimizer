avgEff=0;
EFF_by_Radius=0;
BestChords=0;
BestTheta=0;
for i = 1:size(effSum,3)
[m,chord1] = max(effSum(:,:,i));
[m,theta1] = max(m);
    BestChords(i)=chord(chord1(theta1));
    BestTheta(i)=theta(theta1);
    avgEff=avgEff+m;
    EFF_by_Radius(i)=m;
end
EFF_by_Radius=EFF_by_Radius'
avgEff=avgEff/size(effSum,3)
BestChords = BestChords'
BestTheta = (BestTheta*180/pi)'
%save("AH79-100B.mat","EFF_by_Radius","BestTheta","BestChords","avgEff","angVel");