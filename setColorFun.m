function setColorFun(i,j,iColor)
    if(iColor==1)
        iC='b';%[1 0 0];
    end
    if(iColor==2)
        iC='r';%[0 1 0];
    end
    if(iColor==3)
        iC='g';%[0 0 1];
    end
    if(iColor==4)
        iC='black';%[1 0 1];
    end
    if(iColor==5)
        iC='y';%[0 1 1];
    end
    patch([i,i+1,i+1,i],[j,j,j+1,j+1],iC);
end