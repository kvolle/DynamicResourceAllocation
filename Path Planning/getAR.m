function attrition_rate = getAR(x1,x2,F,new)
x_index = -1;
y_index = -1;
for i = 1:length(x1)
    if (new(1)==x1(i))
        x_index = i;
    end
end

for i = 1:length(x2)
    if (new(2)==x2(i))
        y_index = i;
    end
end

if ((x_index <0)||(y_index<0))
    attrition_rate = -1;
else
    attrition_rate = F(x_index,y_index);
end
end