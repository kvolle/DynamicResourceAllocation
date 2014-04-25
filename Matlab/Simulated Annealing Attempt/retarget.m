function new_target = retarget(distance,target)
    % Randomly selects target with a probability inversely related to
    % distance
    distance(target) = [];
    
    inverse_distance = zeros(1,length(distance));
    sum = 0;
    
    for d = 1:length(distance)
        inverse_distance(d) = 1/distance(d) + sum;
        sum = inverse_distance(d);
    end
    
    probability = inverse_distance./sum;
    
    Q = rand();
    
    for i=1:length(probability)
        if (Q<probability(i))
            new_target = i;
            return
        end
    end
end