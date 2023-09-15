n=12;

Sigma=[1 1];
Num=100;
numberOfTrain=3*Num;
nVar=2;
f1     = mvnrnd([1 10], Sigma, Num);
f2     = mvnrnd([10 1], Sigma, Num);
f3     = mvnrnd([5 5], Sigma, Num);

data=[f1 1*ones(Num,1)
    f2 2*ones(Num,1)
    f3 3*ones(Num,1)];

for p=1:2
    min1=min(data(:,p));
    max1=max(data(:,p));
    data(:,p)=(data(:,p)-min1)/(max1-min1);
end



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

randperm1=randperm(3*Num);
data=data(randperm1,:);

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
        node.Target((i-1)*(n)+j)=-1;
    end
end

maxEpoch=50;

neighborhoodRadius=12;
eta0=0.1;

disW=zeros(1,n*n);
for iter=1:maxEpoch

    eta=eta0*exp(-1*iter/maxEpoch);
    %     neighborhoodRadius=10;
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
        %         setColorFun(i,j);
        indexNN=indexSelect(i,j,n,neighborhoodRadius);
        %         for p=1:size(indexNN,2)
        %             %             setColorFun(indexNN(1,p),indexNN(2,p));
        %         end
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
        %     i
        %     j
        %     indexMin
        som((i-1)*(n)+j).Target=target;
        setColorFun(i,j,target);
    end
     pause(0.05);
end






%  patch([14,15,15,14],[14,14,15,15],[rand rand rand]) % [r g b] values
% % text(1.25,2.5,'Start')
%  patch([1,2,2,1],[1,1,2,2],[1 0 1]) % [r g b] values
% text(10.25,10.5,'Goal')

% figure(2);
% A = zeros(15,15)
% % A(5,1:3) = 0;
% % A(8:10,2:3) = 0;
% % A(5:7,6:7) = 0;
% % A(1:3,8:10) = 0;
% pcolor(A)
% colormap(gray(2))