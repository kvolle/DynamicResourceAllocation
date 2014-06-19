function closest = nearest(list, new)

count = size(list);
distance = 100;
closest = 1;
for i = 1:count(1)
    tmp = (new(1) -list(i,1))^2 + (new(2)-list(i,2))^2;
    if tmp<distance
        distance = tmp;
        closest = i;
    end
end
