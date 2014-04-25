function [distance,target_order] = distance_ordering(target_loc, robot_loc)
    distance = zeros(length(robot_loc),length(target_loc));
    target_order = zeros(length(robot_loc),length(target_loc));
    
    for i = 1:length(robot_loc)
        for j = 1:length(target_loc)
            distance(i,j) = sqrt((robot_loc(1,i)-target_loc(1,j))^2 + (robot_loc(2,i)-target_loc(2,j))^2);
        end
        [tmp,target_order(i,:)]= sort(distance(i,:));
        %targeted(i) = target_order(i,1);
    end

end