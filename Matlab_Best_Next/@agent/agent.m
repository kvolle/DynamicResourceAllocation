classdef agent < handle
    methods
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function robot = agent(ID)
            robot.id = ID-1;
            robot.location = [ceil(rand()*50);ceil(rand()*50)];
            robot.target = -1;
            robot.velocity = [0;0];
            robot.heading = pi/2;
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%%% This needs changed quite a bit
        function relocate(robot,dt)
            robot.location = robot.location + robot.velocity*dt;
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function adjust_velocity(robot,target_loc)
            goal_loc = target_loc(:,robot.target);
            goal_dist = goal_loc-robot.location;
            robot.heading = atan2(goal_dist(2),goal_dist(1));
            tot_dist = norm([goal_dist;0]);
            if tot_dist>0.5
                robot.velocity = 0.25*[cos(robot.heading);sin(robot.heading)];
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
        function get_model(robot,targeted,numTargets)
            robot.model = zeros(1,numTargets);
            for t = 1:numTargets
                for r = 1:length(targeted)
                    if targeted(r) == t
                        robot.model(t) = robot.model(t)+1;
                    end
                end
            end
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function score = get_score(robot,state,target_pk)
             pk = zeros(1,length(state));
            for i = 1:length(state)
                pk(i) = 1- 0.3625^state(i);
            end
            score = sum(abs(pk-target_pk));
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function retarget(robot,target_loc,target_pk)
            for i = 1:length(target_loc)
                candidate_targets(i) = i;
            end
            %candidate_targets(robot.target) = [];
            %score = zeros(1,length(candidate_targets));
            max_score =10000;
            new_target = robot.target;
            for i = 1:length(candidate_targets)
                result = robot.model;
                result(robot.target) = result(robot.target)-1;
                result(i) = result(i)+1;
                score = robot.get_score(result,target_pk);
                if (score < max_score)
                    max_score = score;
                    new_target = i;
                end
            end
            robot.target = new_target;
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%{
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
%}
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    end
    properties
        id
        location
        velocity
        heading
        target
        distance
        target_order
        threshold
        model
    end
end