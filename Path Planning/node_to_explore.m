function node_index = node_to_explore(frontier_cost)
    cost = Inf;
    node_index = 0;
    for i = 1:length(frontier_cost)
        if frontier_cost(i) < cost
            cost = frontier_cost
            node_index = i;
        end
    end
end