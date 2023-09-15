function z=indexSelect(i,j,n,neighborhoodRadius)
tempX1=(i-neighborhoodRadius):1:(i+neighborhoodRadius);
tempY2=(j-neighborhoodRadius):1:(j+neighborhoodRadius);
tempY1=j*ones(1,numel(tempX1));
tempX2=i*ones(1,numel(tempY2));
tempX=[];
tempY=[];
for h=1:neighborhoodRadius-1
    Indexj=j+h;
    for t=1:neighborhoodRadius-h
        tempY=[tempY Indexj];
        tempX=[tempX i+t];
        tempY=[tempY Indexj];
        tempX=[tempX i-t];
    end 
    
    Indexj=j-h;
    for t=1:neighborhoodRadius-h
        tempY=[tempY Indexj];
        tempX=[tempX i+t];
        tempY=[tempY Indexj];
        tempX=[tempX i-t];
    end 
end

z=[ tempX1 tempX2  tempX
    tempY1 tempY2  tempY];
index1=find(z(1,:)>0 & z(1,:)<=n);
index2=find(z(2,:)>0 & z(2,:)<=n);
index=intersect(index1,index2);

z=z(:,index);
end