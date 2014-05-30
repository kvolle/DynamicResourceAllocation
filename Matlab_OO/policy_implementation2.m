% This is an example of simulated annealing for Dynamic Allocation
% This is the object oriented version
%clear all
%clc
function err = policy_implementation2()
% Import the policy
policy_table = importdata('Policy_P2.txt');
% Define the workspace
width = 100;
height = 100;

% Define the number of targets and agents
robots = 11;
targets = 4;

% Define the sizes of the targets
target_sizes = [2,2,4,3];%[2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7];

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
    robot_array(r) = agent(r);
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
valid_hashes = true;
i = 0;

streak = 0;
while (error_exists && i<1000 && valid_hashes)
    i=i+1;
    %robot_loc = relocate(target_loc,robot_loc,targeted);
    %pause(0.15)
    %draw_step(target_loc,robot_loc,targeted);
    %if streak<10
        for r=1:robots
            state = robot_array(r).get_state(targeted,targets);
            hash = get_hash(state,robots,targets);
            robot_array(r).target = get_action(policy_table,hash)+1;
            targeted(r) = robot_array(r).target;
            if targeted(r) <0
                valid_hashes = false;
            end
        end
    %else
    %    disp('Beat the streak')
    %    for r=1:robots
    %        robot_array(r) = ceil(rand()*targets);
    %        targeted(r) = robot_array(r).target;
    %    end
    %end
    
    su = zeros(1,targets);
    for t = 1:length(target_sizes)
        for r = 1:length(targeted)
            if targeted(r) == t
                su(t) = su(t)+1;
            end
        end
    end
    error(i,:) =abs((su-target_sizes));

    tot_err(i) = sum(error(i,:));

    if tot_err(i)==0
        error_exists = false;
    end
    %{
    if i >2
        if error(i) == error(i-1)
            streak = streak+1;
        else
            streak = 0;
        end
    end
%}
end
%targeted
i

%figure(2)
plot(tot_err);
err =tot_err(i);
end
%plot(error(:,1),'r');
%hold on
%plot(error(:,2),'b');
%plot(error(:,3),'g');
%plot(error(:,4),'k');
%plot(error(:,5),'c');
%}