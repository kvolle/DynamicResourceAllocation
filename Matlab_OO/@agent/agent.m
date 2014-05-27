classdef agent < handle
    methods
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function robot = agent()
            robot.location = [ceil(rand()*100);ceil(rand()*100)];
            robot.target = -1;
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%%% This needs changed quite a bit
        function robot_loc = relocate(target_loc,robot_loc,targeted)
            % Fly 10% of the way towards the target, this needs to change
            for r=1:length(robot_loc)
                robot_loc(1,r) = 0.00*(target_loc(1,targeted(r))-robot_loc(1,r))+robot_loc(1,r);
                robot_loc(2,r) = 0.00*(target_loc(2,targeted(r))-robot_loc(2,r))+robot_loc(2,r);
            end
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function distance_ordering(robot,target_loc)
            robot.distance = zeros(1,length(target_loc));
            robot.target_order = zeros(1,length(target_loc));
            for j = 1:length(target_loc)
                robot.distance(j) = sqrt((robot.location(1)-target_loc(1,j))^2 + (robot.location(2)-target_loc(2,j))^2);
            end
                [~,robot.target_order(:)]= sort(robot.distance);
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function retarget(robot)
            % Randomly selects target with a probability inversely related to
            % distance
            robot.distance(robot.target) = [];
            inverse_distance = zeros(1,length(robot.distance));
            sum = 0;
            for d = 1:length(robot.distance)
                inverse_distance(d) = 1/robot.distance(d) + sum;
                sum = inverse_distance(d);
            end
            probability = inverse_distance./sum;
            Q = rand();
            for i=1:length(probability)
                if (Q<probability(i))
                    robot.target = i;
                    return
                end
            end
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function state = get_state(targeted,agent,targets)
            state = zeros(1,targets+1);
            state(1) = targeted(agent);
            for i = 0:targets-1
                for j = 1:length(targeted)
                    if (targeted(j) == i) % If robot j is attacking target i
                        state(i+2) = state(i+2) + 1;
                    end
                end
            end

        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function hash = get_hash(state,r,t)
            hash = 0;
            for i =2:length(state)
                hash = hash + state(i)*(r^(i-2));
            end
            hash = hash + state(1)*(r^t);
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function action = get_action(policy,hash)
            action = -1;
            for i=1:length(policy)
                if(hash == policy(i,1))
                    action = policy(i,2);
                end
            end
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    end
    properties
        location
        target
        distance
        target_order
        threshold
    end
end