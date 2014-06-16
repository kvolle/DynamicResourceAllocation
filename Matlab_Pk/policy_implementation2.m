% This is an example of simulated annealing for Dynamic Allocation
% This is the object oriented version
clear all
clc
%function err = policy_implementation2()

% Import the policy
policy_table = importdata('Policy_P2.txt');
% Define the workspace
width = 100;
height = 100;

% Define the number of targets and agents
robots = 15;
targets = 5;

% Define the sizes of the targets
target_sizes = [2,5,4,1,3];%[2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7];
target_threshold = [0.835,0.988,0.973,0.595,0.933];
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

error_exists = true;
valid_hashes = true;
i = 0;
reward = zeros(1,10);

while (error_exists && i<10 && valid_hashes)
    i=i+1;
    for r=1:robots
        state = robot_array(r).get_state(targeted,targets);
        hash = get_hash(state,robots,targets);
        robot_array(r).target = get_action(policy_table,hash)+1;
        targeted(r) = robot_array(r).target;
        if targeted(r) <0
            valid_hashes = false;
            disp('PROBLEM');
        end
    end
    su = zeros(1,targets);
    for t = 1:length(target_sizes)
        for r = 1:length(targeted)
            if targeted(r) == t
                su(t) = su(t)+1;
            end
        end
    end
    for tar=2:6
        tmp_pk=1;
        for a=0:state(tar)
            tmp_pk=tmp_pk*0.405;
        end
        reward(i) = reward(i)+(1-tmp_pk-target_threshold(tar-1));
    end
    error(i,:) =abs((su-target_sizes));
    tot_err(i) = sum(error(i,:));   
    if tot_err(i)==0
        error_exists = false;
    end
end
%targeted
i;

%figure(2)
%plot(tot_err);
plot(reward);
err =tot_err(i);
%{
for tar=2:6
    tmp_pk=1;
    for a=0;state(tar)
        tmp_pk=tmp_pk*0.405;
    end
    disp('Reward');
    (1-tmp_pk)
    disp('Threshold');
    target_threshold(tar-1)
end
%}


%end

%plot(error(:,1),'r');
%hold on
%plot(error(:,2),'b');
%plot(error(:,3),'g');
%plot(error(:,4),'k');
%plot(error(:,5),'c');
%}