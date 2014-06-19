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

explored = [];
frontier = goal;
explored_cost = [];
frontier_cost = [0];

while ((~goalFound) && (rows(frontier) >0))

    node_index = node_to_explore(frontier_cost);
    map_indices = get_map_indices(frontier(node_index));
    
    %% CHANGE TO MAP INDICES
    north = [frontier(node_index,1),frontier(node_index,2)+0.1];
    east = [frontier(node_index,1)+0.1,frontier(node_index,2)];
    south = [frontier(node_index,1),frontier(node_index,2)-0.1];
    west = [frontier(node_index,1)-0.1,frontier(node_index,2)];
    explored = [explored;frontier(node_index)];
    explored_cost = [explored_cost;frontier_cost(node_index)];
    frontier(node_index) = [];
    frontier_cost(node_index) = [];
    
    if north(2)<10
        frontier = [frontier;north];
        frontier_cost = [frontier_cost,

   
end
toc