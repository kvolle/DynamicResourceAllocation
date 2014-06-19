function attrition_rate = getAR(x1,x2,F,new)

for i = 1:length(x1)
    if (new(1)>x1(i))
        x_min = i;
    end
end

for i = 1:length(x2)
    if (new(2)>x2(i))
        y_min = i;
    end
end

%fprintf(1,' X - Min: %3f Value: %3f Max: %3f\n',x1(x_min),new(1),x1(x_min+1));
%fprintf(1,'Y - Min: %3f Value: %3f Max: %3f\n\n',x2(y_min),new(2),x2(y_min+1));

%{
tmp1 = F(x_min,y_min)*(x1(x_min+1)-new(1))/(x1(x_min+1)-x1(x_min)) + F(x_min+1,y_min)*(new(1)-x1(x_min))/(x1(x_min+1)-x1(x_min));
tmp2 = F(x_min,y_min+1)*(x1(x_min+1)-new(1))/(x1(x_min+1)-x1(x_min)) + F(x_min+1,y_min+1)*(new(1)-x1(x_min))/(x1(x_min+1)-x1(x_min));

attrition_rate = tmp1*(x2(y_min+1)-new(2))/(x2(y_min+1)-x2(y_min)) + tmp2*(new(2)-x2(y_min))/(x2(y_min+1)-x2(y_min));
%}

attrition_rate = (1/(x1(x_min+1)-x1(x_min))*(x2(y_min+1)-x2(y_min)))*(F(x_min,y_min)*(x1(x_min+1)-new(1))*(x2(y_min+1)-new(2)) + F(x_min+1,y_min)*(new(1)-x1(x_min))...
    *(x2(y_min+1)-new(2)) + F(x_min,y_min+1)*(x1(x_min+1)-new(1))*(new(2)-x2(y_min)) + F(x_min+1,y_min+1)*(new(1)-x1(x_min))*(new(2)-x2(y_min)));


end