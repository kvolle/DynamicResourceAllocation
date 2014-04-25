function state = get_state(targeted,agent,targets)
state = zeros(1,targets+1);
state(1) = targeted(agent);
for i = 0:targets-1
    for j = 1:length(targeted)
        if (targeted(j) == i) % If robot j is attacking target i
            state(i+2) = state(i+2) + 1;
        end
    end
end

end