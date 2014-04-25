function draw_step(target_loc,robot_loc,targeted)
        % This function draws the updated scene
        hold off
        clf
        axis([0 100 0 100])
        hold on
        axis square
        color = ['r','b','g','k','c','m','k','r','b','g','k','c','m','k','r','b','g','k','c','m','k'];
        
        for i = 1:length(target_loc)
            plot(target_loc(1,i),target_loc(2,i),'o','color',color(i),'markerfacecolor',color(i),'markersize',10);
        end
        for r = 1:length(robot_loc)
            plot(robot_loc(1,r),robot_loc(2,r),'o','color',color(targeted(r)));
        end
end

