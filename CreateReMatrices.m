columnNumber=2;
for i=1:length(CLReMat)
    bool = 0;
    for j=1:length(angle)
    if(abs(CLReMat(i,1)-angle(j)) < 0.07)
        CLReMat(i,columnNumber)=CL(j);
        bool=1;
    end
    end
    if(bool == 0)
        CLReMat(i,columnNumber)=0;
    end
end
for i=1:length(CDReMat)
    bool = 0;
    for j=1:length(angle)
    if(abs(CDReMat(i,1)-angle(j)) < 0.07)
        CDReMat(i,columnNumber)=CD(j);
        bool=1;
    end
    end
    if(bool == 0)
        CDReMat(i,columnNumber)=0;
    end
end