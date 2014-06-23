% Point mass dynamics
classdef agent < handle
    methods(Static)
        function score = get_score(state,target_pk)
             pk = zeros(1,length(state));
            for i = 1:length(state)
                pk(i) = 1- 0.3625^state(i);
            end
            score = sum(abs(pk-target_pk));
        end
    end
    methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Constructor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = agent(ID)
            % Indexing from 1
            obj.ID = ID;
            obj.Target = -1;
            % North, East, Down convention
            obj.State = [0;0;-100;0;0;0];%[ceil(rand()*50);ceil(rand()*50);-100;0;0;0];
            obj.Mass = 5; % 5 kg, placeholder mostly
            obj.Force = [0;0;0];
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Dynamics and Controls Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [] = get_trajectory(obj,target_loc)
            velocity_mag = 10; %m/s placeholder
            vel = (target_loc(:,obj.Target)-obj.State(1:2));
            range = norm([vel;0]);
            if (range >10)
                vel = (1/range)*vel;
                descent_rate = -obj.State(3)/range;
                obj.Trajectory = velocity_mag*[vel;descent_rate];
            else
                obj.Trajectory = [vel; -0.5*obj.State(3)];
            end
        end
        function [] = velocity_hack(obj)
            obj.State(4:6) = obj.Trajectory;
        end
        function dstate = stateDiff(obj, y)
            dstate(1:3) = y(4:6);
            dstate(4:6) = (1/obj.Mass)*obj.Force;
            dstate = dstate';
        end
        function [] = RK4(obj)
            dt = 0.01;
            k1 = obj.stateDiff(obj.State);
            size(obj.State)
            size(k1)
            k2 = obj.stateDiff(obj.State+(dt/2)*k1);
            k3 = obj.stateDiff(obj.State+(dt/2)*k2);
            k4 = obj.stateDiff(obj.State+dt*k3);
            obj.State = obj.State + (dt/6)*(k1+2*k2+2*k3+k4);
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Planning Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function retarget_sa(robot,target_loc,target_pk)
            for i = 1:length(target_loc)
                candidate_targets(i) = i;
                candidate_angle(i) = atan2(target_loc(2,i)-robot.location(2),target_loc(1,i)-robot.location(1))-robot.heading;
            end
            candidate_targets(robot.target) = [];
            candidate_angle(robot.target) = [];

            inverse_angle = zeros(1,length(candidate_angle));
            sum = 0;
            for d = 1:length(candidate_angle)
                inverse_angle(d) = 1/candidate_angle(d) + sum;
                sum = inverse_angle(d);
            end
            %probability = inverse_angle./sum;
            %
            for i =1:length(inverse_angle)
                probability(i) = (1-isreal(log(1-target_pk-0.3625^robot.model(i))))*inverse_angle(i)/sum;
            end
            %}
            Q = rand();
            for i=1:length(probability)
                if (Q<probability(i))
                    robot.target = candidate_targets(i);
                    return
                end
            end
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function retarget_bn(obj,target_loc,target_pk)
            for i = 1:length(target_loc)
                candidate_targets(i) = i;
            end
            %candidate_targets(robot.target) = [];
            %score = zeros(1,length(candidate_targets));
            max_score =Inf;
            new_target = obj.Target;
            for i = 1:length(candidate_targets)
                result = obj.Model;
                result(obj.Target) = result(obj.Target)-1;
                result(i) = result(i)+1;
                score = agent.get_score(result,target_pk);
                if (score < max_score)
                    max_score = score;
                    new_target = i;
                end
            end
            obj.Target = new_target;
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Communication/Sensing Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function get_model(obj,targeted,numTargets)
            obj.Model = zeros(1,numTargets);
            for t = 1:numTargets
                for r = 1:length(targeted)
                    if targeted(r) == t
                        obj.Model(t) = obj.Model(t)+1;
                    end
                end
            end
        end
    end
    properties
        ID
        Target
        State
        Mass
        Force
        Trajectory
        Model
    end
end
            