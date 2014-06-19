clear all
clc


% Generate heatmap of attrition rate
mu = [0 0];
Sigma = [.25 .3; .3 1];
x1 = -10:.2:10; x2 = -10:.2:10;
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

surf(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([-10 10 -10 10 0 .1])
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');