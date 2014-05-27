classdef environment
    methods
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function world = environment(Target_sizes,Target_loc,Robot_loc)
            world.target_sizes = Target_sizes;
            world.target_loc = Target_loc;
            world.robot_loc = Robot_loc;
            world.targeted =-1*ones(1,length(Robot_loc);
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function [distance,target_order] = distance_ordering(world);
        %function [distance,target_order] = distance_ordering(target_loc, robot_loc)
            distance = zeros(length(world.robot_loc),length(world.target_loc));
            target_order = zeros(length(world.robot_loc),length(world.target_loc));
    
            for i = 1:length(world.robot_loc)
                for j = 1:length(world.target_loc)
                    distance(i,j) = sqrt((world.robot_loc(1,i)-world.target_loc(1,j))^2 + (world.robot_loc(2,i)-world.target_loc(2,j))^2);
                end
                [~,target_order(i,:)]= sort(distance(i,:));
            end
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function draw_step(world)
        %function draw_step(target_loc,robot_loc,targeted)
            % This function draws the updated scene
            hold off
            clf
            axis([0 100 0 100])
            hold on
            axis square
            color = ['r','b','g','k','c','m','k','r','b','g','k','c','m','k','r','b','g','k','c','m','k'];
        
            for i = 1:length(worldtarget_loc)
                plot(world.target_loc(1,i),world.target_loc(2,i),'o','color',color(i),'markerfacecolor',color(i),'markersize',10);
            end
            for r = 1:length(world.robot_loc)
                plot(world.robot_loc(1,r),world.robot_loc(2,r),'o','color',color(world.targeted(r)));
            end
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function threshold = set_threshold(world)
        %function draw_step(target_loc,robot_loc,targeted)
            sum = zeros(1,length(world.target_sizes));
            for t = 1:length(world.target_sizes)
                for r = 1:length(world.targeted)
                    if world.targeted(r) == t
                        sum(t) = sum(t)+1;
                    end
                end
            end
            threshold = 0.5*(sum-world.target_sizes)./world.target_sizes;
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    end
    properties
        target_sizes
        target_loc
        robot_loc
        targeted
    end
end