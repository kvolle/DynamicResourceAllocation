classdef environment
    methods
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        function world = environment(Target_sizes,Target_loc)
            world.target_sizes = Target_sizes;
            world.target_loc = Target_loc;
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
        end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    end
    properties
        target_sizes
        target_loc

    end
end