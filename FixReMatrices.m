I=0;
columnNumber = 2;
for i=1:length(CLReMat)
    if(CLReMat(i,columnNumber) ~= 0)
        I=i;
        break;
    end
end
increment = 1;
increment2 = 0;
lastNonZeroPos=increment2;
noZeros = 0;
lastNonZero = CLReMat(I,columnNumber);
while(increment < length(CL))
    CLReMat(I+increment2,columnNumber)
    CL(increment)
    increment
    increment2=increment2+1;
    if(CLReMat(I+increment2,columnNumber) ~= 0)
        nextNonZero=CLReMat(I+increment2,columnNumber);
        if(noZeros ~= 0)
        interpol = linspace(lastNonZero,nextNonZero,noZeros+2)'
        CLReMat(I+lastNonZeroPos:I+lastNonZeroPos+noZeros+1,columnNumber)=interpol;
        end
        lastNonZero=nextNonZero;
        lastNonZeroPos=increment2;
        increment = increment+1;
        noZeros=0;
    else
    noZeros =noZeros+1;
    end
end
I=0;
for i=1:length(CDReMat)
    if(CDReMat(i,columnNumber) ~= 0)
        I=i;
        break;
    end
end
increment = 1;
increment2 = 0;
lastNonZeroPos=increment2;
noZeros = 0;
lastNonZero = CDReMat(I,columnNumber);
while(increment < length(CD))
    increment2=increment2+1;
    if(CDReMat(I+increment2,columnNumber) ~= 0)
        nextNonZero=CDReMat(I+increment2,columnNumber);
        if(noZeros ~= 0)
        interpol = linspace(lastNonZero,nextNonZero,noZeros+2)'
        CDReMat(I+lastNonZeroPos:I+lastNonZeroPos+noZeros+1,columnNumber)=interpol;
        end
        lastNonZero=nextNonZero;
        lastNonZeroPos=increment2;
        increment = increment+1;
        noZeros=0;
    else
    noZeros =noZeros+1;
    end
end