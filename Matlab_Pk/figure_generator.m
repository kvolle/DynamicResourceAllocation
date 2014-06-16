clear all
clc

% 10 Targets
candidate_targets = 1:10;
candidate_distance = [15,10,27,34,42,5,21,32,11,19];
            
%candidate_targets(3) = [];
candidate_distance(3) = [Inf];
exclude = [];
%{
for i = 1:length(candidate_targets)
    if delta_heading(i) > 30
        exclude = [exclude i]
    end
end
candidate_targets(exclude) =[];
candidate_distance(exclude) = [];
%}
inverse_distance = zeros(1,length(candidate_distance));
sum = 0;
for d = 1:length(candidate_distance)
    inverse_distance(d) = 1/candidate_distance(d) + sum;
    sum = inverse_distance(d);
end
probability = inverse_distance./sum;

prob = probability(1)*ones(1,10);
for i = 2:10;
    prob(i) = probability(i) - probability(i-1);
end
bar(prob);
title('Probability Distribution - Target 3 Overengaged')
xlabel('Target ID');
ylabel('Probability');

figure(2)
bar([0 0 1 0 0 0 0 0 0 0])
title('Probability Distribution - Target 3 Underengaged')
xlabel('Target ID');
ylabel('Probability');
%{
Q = rand();
for i=1:length(probability)
    if (Q<probability(i))
        robot.target = candidate_targets(i);
        return
    end
end
%}