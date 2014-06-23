clear all
clc

r = 150;
t = 30;

targeted = -1*ones(1,r);
for i = 1:r
    robot_array(i) = agent(i);
    robot_array(i).Target = ceil(rand()*t);
    targeted(i) = robot_array(i).Target;
end

target_loc = zeros(2,t);
for j = 1:t
    target_loc(:,j) = [ceil(rand()*50)+100;ceil(rand()*50)+100];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This isn't very high-fidelity to the real world

% Define the sizes of the targets
target_size = [2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7];
for z=1:length(target_size);
    target_pk(z) = 1-0.3625^target_size(z);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


errorExists = true;
i =0;
tic
while((i<200) && (errorExists))
    magicNumber = floor(rand()*50);
   for r = 1:length(robot_array)
       if (mod(r,50) == magicNumber)
       % Move this next line to the end of this inner loop
        robot_array(r).get_model(targeted,t);
        robot_array(r).retarget_bn(target_loc,target_pk)
       end
   end
 i = i +1;
end
toc