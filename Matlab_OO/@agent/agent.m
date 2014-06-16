classdef agent < handle
    methods
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function robot = agent(ID)
            robot.id = ID-1;
            robot.location = [ceil(rand()*50);ceil(rand()*50)];
            robot.target = -1;
            robot.velocity = [0;0];
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%%% This needs changed quite a bit
        function relocate(robot,dt)
            robot.location = robot.location + robot.velocity*dt;
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function adjust_velocity(robot,target_loc)
            goal_loc = target_loc(robot.target);
            goal_dist = goal_loc-robot.location;
            if goal_dist(1)^2+goal_dist(2)^2 >0.25
                robot.velocity = .01*goal_dist/(goal_dist(1)^2+goal_dist(2)^2);
            else
                robot.velocity = [0;0];
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
        function retarget(robot,target_loc)
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
        function state = get_state(robot,targeted,targets)
            state = zeros(1,targets+1);
            state(1) = targeted(robot.id+1)-1;
            for i = 0:targets-1
                for j = 1:length(targeted)
                    if (targeted(j) == i+1) % If robot j is attacking target i
                        state(i+2) = state(i+2) + 1;
                    end
                end
            end

        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    end
    properties
        id
        location
        velocity
        target
        distance
        target_order
        threshold
    end
end