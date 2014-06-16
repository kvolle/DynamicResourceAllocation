clear all
clc

policy_table = importdata('Policy_P2.txt');

robots = 15;
targets = 5;
target_sizes = [2 5 4 1 3];
cntr = 0;
n = 10000;
iterations = 10;
score_init = zeros(iterations,n);
hash_record = [];
while cntr <n
    state(1) = floor(rand()*targets);
    tmp = rand(targets);
    tmp = round(15*tmp/sum(tmp));
    state(2:targets+1)= tmp;
    %state = typecast(state,'int8');

    if sum(state(2:targets+1))==15
        cntr = cntr+1;
        score(1,cntr) = sum(abs(state(2:targets+1)-target_sizes));
        for j = 2:iterations
            hash = get_hash(state,robots,targets);
            hash_record = [hash_record,hash];
            action = get_action(policy_table,hash);
            if action >-1
                state(state(1)+2) = state(state(1)+2)-1;
                state(1) = action;
                state(action+2) = state(action+2)+1;
                score(j,cntr)= sum(abs(state(2:targets+1)-target_sizes));
            else
                disp('Bad hash');
            end
        end
    end
end
%{
hist(score(1,:),0.5:1:15.5);
figure(2)
hist(score(2,:),0.5:1:15.5);
figure(3)
hist(score(3,:),0.5:1:15.5);
%}
for i = 1:iterations
    mean_err(i) = mean(score(i,:));
end
plot(mean_err)
figure(2)
hist(hash_record,15300)