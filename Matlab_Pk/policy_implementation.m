%clear all
%clc
function [error,sufficient] = policy_implementation()
robots = 15;
targets = 5;

targetSize = [2,2,4,1,6];%[2,5,3,4,1];
%fid = fopen('Policy_P.txt');
%[policy_table(:,1) policy_table(:,2)] = fscanf(fid,'%d %d\n');
%fclose(fid);
policy_table = importdata('Policy_P2.txt');

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
    targeted(r) = target_order(r,1)-1;
end

% Plot the scene
%draw_step(target_loc,robot_loc,targeted);

sum = zeros(1,targets);
for t = 1:targets
    for r = 1:length(targeted)
        if targeted(r) == t-1;
            sum(t) = sum(t)+1;
        end
    end
end
error(1,:) =abs((sum-targetSize));
total_err = 0;
for k = 1:length(error)
    total_err = total_err + error(k);
end

round = 1;
score(round) = total_err;
didnt_work = 0;
while ((total_err > 0.01)&&(round<=500))

    score(round) = total_err;
    round = round +1;
    for r = 1:robots
        state = get_state(targeted,r,targets);
        hash = get_hash(state,robots,targets);
        action = get_action(policy_table,hash);
        if action == -1
            didnt_work = didnt_work + 1;
            disp('Shit');
        else
            targeted(r) = action;
        end
    end



    sum_tar = zeros(1,targets);
    for t = 1:targets
        for r = 1:length(targeted)
            if targeted(r) == t-1
                sum_tar(t) = sum_tar(t)+1;
            end
        end
    end
    error(1,:) =abs((sum_tar-targetSize));
    total_err = 0;
    for k = 1:length(error)
        total_err = total_err + error(k);
    end

end
didnt_work;
%plot(score);
error = score(round-1);

sum_tar = zeros(1,targets);
for t = 1:targets
    for r = 1:length(targeted)
        if targeted(r) == t-1
            sum_tar(t) = sum_tar(t)+1;
        end
    end
end
differences = sum_tar-targetSize;
sufficient = 0;
for d=1:targets
    if differences(d) >=0
        sufficient = sufficient+1;
    end
end