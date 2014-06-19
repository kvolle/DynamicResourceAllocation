function map_indices = get_map_indices(location,x1,x2)
x_index = -1;
y_index = -1;

for i = 1:length(x1)
    if (location(1)==x1(i))
        x_index = i;
    end
end

for i = 1:length(x2)
    if (location(2)==x2(i))
        y_index = i;
    end
end

map_indices = [x_index,y_index];
end