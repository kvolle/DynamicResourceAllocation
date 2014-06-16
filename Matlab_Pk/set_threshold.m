function threshold =set_threshold(target_pk,targeted)
    sum = zeros(1,length(target_pk));
    for t = 1:length(target_pk)
        for r = 1:length(targeted)
            if targeted(r) == t
                sum(t) = sum(t)+1;
            end
        end
    end
    Pk = ones(1,length(target_pk))-0.3625.^sum;
    %threshold = 0.5*(sum-target_sizes)./target_sizes;
    threshold = zeros(1,length(Pk));
    for i =1:length(Pk)
        threshold(i) = 0.5*isreal(1/log(1-0.3625^(sum(i)-1)-target_pk(i)));%2*log(0.3625)/log(Pk(i)-target_pk(i))*isreal(log(0.3625)/log(Pk(i)-target_pk(i)));
    end
end