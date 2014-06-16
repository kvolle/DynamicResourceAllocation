function action = get_action(policy,hash)
    action = -2;
    for i=1:length(policy)
        if(hash == policy(i,1))
            action = policy(i,2);
        end
    end
end