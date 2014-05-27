% This is an example of simulated annealing for Dynamic Allocation
% This is the object oriented version
clear all
clc

% Define the workspace
width = 100;
height = 100;

% Define the number of targets and agents
targets = 30;
robots = 150;

% Define the sizes of the targets
target_sizes = [2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7];

%Instantiate targets spaced randomly
target_loc = zeros(2,targets);
for i = 1:targets
    target_loc(:,i)=[ceil(rand()*100);ceil(rand()*100)];
end

% Declare the world object
world = environment(target_sizes,target_loc);

% The negative one is for debugging since it should never exist after this
% This will be replaced with communication eventually
targeted = -1*ones(1,robots);


% Instantiate robots spaced randomly
% Select the nearest target
for r = 1:robots
    robot_array(r) = agent();
    robot_array(r).distance_ordering(target_loc);
    robot_array(r).target = robot_array(r).target_order(1);
    % Fill the ground truth array of who everyone is targeting
    targeted(r) = robot_array(r).target;
end

% Plot the scene
%figure(1)
%draw_step(target_loc,robot_loc,targeted);


% Set the threshold for switching based on initial allocation
threshold = set_threshold(target_sizes,targeted);

error_exists = true;
i = 0;
tic
while (error_exists && i<1000)
    i=i+1;
    %robot_loc = relocate(target_loc,robot_loc,targeted);
    %pause(0.15)
    %draw_step(target_loc,robot_loc,targeted);
    for r=1:robots
        % threshold times sigmoid function based on distance
        if (rand()<threshold(targeted(r))/(1+exp(-.2*(robot_array(r).distance(targeted(r))-15))))
            robot_array(r).retarget();
            targeted(r) = robot_array(r).target;
            robot_array(r).distance_ordering(target_loc);
        end
    end
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

    if tot_err(i,1)==0
        error_exists = false;
    end

end
toc
figure(2)
plot(tot_err);

%plot(error(:,1),'r');
%hold on
%plot(error(:,2),'b');
%plot(error(:,3),'g');
%plot(error(:,4),'k');
%plot(error(:,5),'c');
%}