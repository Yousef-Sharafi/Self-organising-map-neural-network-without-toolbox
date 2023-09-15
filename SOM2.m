n=20; %size of grid

Sigma=[1.2 1.2];
Num=50;
NumberOfTestData=500;
numberOfTrain=5*Num;
maxEpoch=100;
neighborhoodRadius=10;
eta0=0.1;
nVar=2;

f1     = mvnrnd([1 10], Sigma, Num);
f2     = mvnrnd([10 1], Sigma, Num);
f3     = mvnrnd([5 5], Sigma, Num);
f4     = mvnrnd([10 10], Sigma, Num);
f5     = mvnrnd([0 0], Sigma, Num);

data=[f1 1*ones(Num,1)
    f2 2*ones(Num,1)
    f3 3*ones(Num,1)
    f4 4*ones(Num,1)
    f5 5*ones(Num,1)];

for p=1:2
    min1=min(data(:,p));
    max1=max(data(:,p));
    data(:,p)=(data(:,p)-min1)/(max1-min1);
end

dataTX=unifrnd(0,1,[1 NumberOfTestData]);
dataTY=unifrnd(0,1,[1 NumberOfTestData]);

dataTestN=[dataTX' dataTY' zeros(NumberOfTestData,1)];

subplot(1,2,1),plot(data(1:Num,1),data(1:Num,2),'o',...
    'MarkerSize',9,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','b')
hold on;
subplot(1,2,1),plot(data(Num+1:2*Num,1),data(Num+1:2*Num,2),'o',...
    'MarkerSize',9,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r')

hold on;
subplot(1,2,1),plot(data(2*Num+1:3*Num,1),data(2*Num+1:3*Num,2),'o',...
    'MarkerSize',9,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g')
hold on;
subplot(1,2,1),plot(data(3*Num+1:4*Num,1),data(3*Num+1:4*Num,2),'o',...
    'MarkerSize',9,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','black')
hold on;
subplot(1,2,1),plot(data(4*Num+1:5*Num,1),data(4*Num+1:5*Num,2),'o',...
    'MarkerSize',9,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','y')
hold on;
subplot(1,2,1),plot(dataTX,dataTY,'*',...
    'MarkerSize',7,...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor','black');

node.w=[];
node.pos=[];
node.disInput=[];
node.Target=[];
som=repmat(node,[1 n*n]);

for i=1:n
    for j=1:n
        som((i-1)*(n)+j).w=unifrnd(0.0001,1,[1 nVar]);
        som((i-1)*(n)+j).pos=[i j];
        som((i-1)*(n)+j).disInput=0;
        som((i-1)*(n)+j).Target=-1;
    end
end

disW=zeros(1,n*n);
for iter=1:maxEpoch
    iter
    randperm1=randperm(5*Num);
    data=data(randperm1,:);
    eta=eta0*exp(-1*iter/maxEpoch);
    %neighborhoodRadius=10;
    for index=1:numberOfTrain
        input=data(index,1:nVar);
        for t=1:n*n
            som(t).disInput=norm(som(t).w-input);
        end
        [valueMin,indexMin]=min([som.disInput]);
        i=round(indexMin/n);
        if(i==0)
            i=1;
        end
        j=mod(indexMin,n);
        indexNN=indexSelect(i,j,n,neighborhoodRadius);
        for m=1:size(indexNN,2)
            i1=indexNN(1,m);
            j1=indexNN(2,m);
            n1=(i1-1)*(n)+j1;
            som(n1).w=som(n1).w+0.01*eta*(input-som(n1).w);
        end
    end
    
    if(mod(iter,n)==0)
        neighborhoodRadius=neighborhoodRadius-1;
        if neighborhoodRadius==0
            neighborhoodRadius=1;
        end
    end
    %****************************
    A = zeros(n,n);
    subplot(1,2,2),pcolor(A)
    colormap(gray(2))
    for index=1:numberOfTrain
        input=data(index,1:nVar);
        target=data(index,1+nVar);
        for t=1:n*n
            som(t).disInput=norm(som(t).w-input);
        end
        [valueMin,indexMin]=min([som.disInput]);
        i=round(indexMin/n);
        if(i==0)
            i=1;
        end
        j=mod(indexMin,n);
        if(j==0)
            j=n;
        end
        som((i-1)*(n)+j).Target=target;
        setColorFun(i,j,target);
    end
     pause(0.05);
end





for index=1:NumberOfTestData
        input=dataTestN(index,1:nVar);
        for t=1:n*n
            som(t).disInput=norm(som(t).w-input);
        end
        [valueMin,indexMin]=min([som.disInput]);
        i=round(indexMin/n);
        if(i==0)
            i=1;
        end
        j=mod(indexMin,n);
        if(j==0)
            j=n;
        end
        dataTestN(index,nVar+1)=som((i-1)*(n)+j).Target;
end

index1=[];
index2=[];
index3=[];
index4=[];
index5=[];

for t=1:NumberOfTestData
    if(dataTestN(t,3)==1)
        index1=[index1 t];
    end
    if(dataTestN(t,3)==2)
        index2=[index2 t];
    end
    if(dataTestN(t,3)==3)
        index3=[index3 t];
    end
    if(dataTestN(t,3)==4)
        index4=[index4 t];
    end
    if(dataTestN(t,3)==5)
        index5=[index5 t];
    end
end

hold on;
subplot(1,2,1),plot(dataTestN(index1,1),dataTestN(index1,2),'*',...
    'MarkerSize',7,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','b');
hold on;
subplot(1,2,1),plot(dataTestN(index2,1),dataTestN(index2,2),'*',...
    'MarkerSize',7,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','r');
hold on;
subplot(1,2,1),plot(dataTestN(index3,1),dataTestN(index3,2),'*',...
    'MarkerSize',7,...
    'MarkerEdgeColor','g',...
    'MarkerFaceColor','g');
hold on;
subplot(1,2,1),plot(dataTestN(index4,1),dataTestN(index4,2),'*',...
    'MarkerSize',7,...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor','black');
hold on;
subplot(1,2,1),plot(dataTestN(index5,1),dataTestN(index5,2),'*',...
    'MarkerSize',7,...
    'MarkerEdgeColor','y',...
    'MarkerFaceColor','y');





