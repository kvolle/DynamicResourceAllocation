% This is a quick example of simulated annealing for Dynamic Allocation

clear all
clc

width = 100;
height = 100;

targets = 5;
robots = 25;

target_sizes = [2,5,7,4,7];

target_loc = zeros(2,targets);
robot_loc = zeros(2,robots);
targeted = ones(1,robots);

%Instantiate 5 targets spaced randomly
for i = 1:targets
    target_loc(:,i)=[ceil(rand()*100);ceil(rand()*100)];
end

% Instantiate 15 robots spaced randomly
for i = 1:robots
   robot_loc(:,i) = [ceil(rand()*100);ceil(rand()*100)];
   %plot(robot_loc(1,i),robot_loc(2,i),'kx');
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                                                                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
[distance,target_order] = distance_ordering(target_loc, robot_loc);

% Initially choose closest target
for r = 1:robots
    targeted(r) = target_order(r,1);
end

% Plot the scene
draw_step(target_loc,robot_loc,targeted);

% Set the threshold for switching based on initial allocation
threshold = set_threshold(target_sizes,targeted);

for i =1:50
    robot_loc = relocate(target_loc,robot_loc,targeted);
    %pause(0.15)
    draw_step(target_loc,robot_loc,targeted);
    for r=1:robots
        if (rand()<threshold(targeted(r)))
            disp('SWITCH');
            targeted(r) = retarget(distance(r,:),targeted(r));
        end
    end
    [distance,target_order] = distance_ordering(target_loc, robot_loc);
    threshold = set_threshold(target_sizes,targeted);
    su = zeros(1,targets);
for t = 1:length(target_sizes)
    for r = 1:length(targeted)
        if targeted(r) == t
            su(t) = su(t)+1;
        end
    end
end
error(i,:) =abs((su-target_sizes));

tot_err(i,1) = sum(error(i,:));
end

figure(2)
plot(tot_err);

%plot(error(:,1),'r');
%hold on
%plot(error(:,2),'b');
%plot(error(:,3),'g');
%plot(error(:,4),'k');
%plot(error(:,5),'c');


