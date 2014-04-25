function robot_loc = relocate(target_loc,robot_loc,targeted)
    % Fly 10% of the way towards the target, this will probably change
    for r=1:length(robot_loc)
        robot_loc(1,r) = 0.00*(target_loc(1,targeted(r))-robot_loc(1,r))+robot_loc(1,r);
        robot_loc(2,r) = 0.00*(target_loc(2,targeted(r))-robot_loc(2,r))+robot_loc(2,r);
    end
end