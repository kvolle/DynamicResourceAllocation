clear all
clc


% Generate heatmap of attrition rate
mu = [0 0];
Sigma = [.25 .3; .3 1];
x1 = -10:.1:10; x2 = -10:.1:10;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));

for i = 1:10
    mu =[floor(rand()*20)-10 floor(rand()*20)-10];
    anti_diag = rand();
    Sigma = [anti_diag+rand() anti_diag; anti_diag anti_diag+rand()];
    tmp = mvnpdf([X1(:) X2(:)],mu,Sigma);
    tmp = reshape(tmp,length(x2),length(x1));
    F = F+tmp;
end

F = F./(10*max(max(F)));

%surf(x1,x2,F);
%caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
%axis([-10 10 -10 10 0 .1])
%xlabel('x1'); ylabel('x2'); zlabel('Probability Density');
contourf(x1,x2,F);

start = [-10,-10];
goal = [10,10];

list = start;
parent = [NaN];
ar = [0];

tmp = [0,0];

figure(2)
goalFound = false;
tic
while ((tmp(1)<10000)&&(~goalFound))
    
    new = [random('unif',0,20)-10,random('unif',0,20)-10];
    closest = nearest(list,new);
    distX = new(1)-list(closest,1);
    distY = new(2)-list(closest,2);

    distance = sqrt(distX^2 + distY^2);
    if distance>02.5
        distX = 0.25*distX/distance;
        distY = 0.25*distY/distance;
    end
    new = [round(10*(list(closest,1)+distX))/10, round(10*(list(closest,2)+distY))/10];

    plot(linspace(list(closest,1),new(1)),linspace(list(closest,2),new(2)),'b');
    hold on
    list = vertcat(list,new);
    parent = vertcat(parent,closest);
    ar = vertcat(ar,getAR(x1,x2,F,new));
   
    if ((abs(new(1)-goal(1)) <0.2)&& (abs(new(2)-goal(2))<0.2))
        goalFound = true;
        disp('GOOOOOAAAALL!');
    end
    
    tmp = size(list);
end
toc