function hash = get_hash(state,r,t)
    hash = 0;
    for i =2:length(state)
        hash = hash + state(i)*(r^(i-2));
    end
    hash = hash + state(1)*(r^t);
end