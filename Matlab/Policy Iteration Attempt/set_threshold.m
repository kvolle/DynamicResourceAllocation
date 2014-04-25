function threshold = set_threshold(target_sizes,targeted)
    sum = zeros(1,length(target_sizes));
    for t = 1:length(target_sizes)
        for r = 1:length(targeted)
            if targeted(r) == t
                sum(t) = sum(t)+1;
            end
        end
    end

    threshold = 0.5*(sum-target_sizes)./target_sizes;
end