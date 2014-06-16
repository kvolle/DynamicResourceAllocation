clear all
clc

prob_table = zeros(10,21);
for target_size = 1:10
    target_pk = 1 - 0.3625^target_size;
   for numAgents = 1:21
       Pk = 1 - 0.3625^(numAgents-1);
       prob_table(target_size,numAgents) =(0.5*(numAgents-target_size)/target_size)*isreal(log(0.3625)/log(Pk-target_pk));%log(0.3625)/log(Pk-target_pk)*isreal(log(0.3625)/log(Pk-target_pk));
   end
end

plot([0:20],prob_table(1,:),'r');
hold on
plot([0:20],prob_table(2,:),'g');
plot([0:20],prob_table(3,:),'b');
plot([0:20],prob_table(4,:),'k');
plot([0:20],prob_table(5,:),'c');
%{
plot([0:20],prob_table(6,:),'r-.');
plot([0:20],prob_table(7,:),'g-.');
plot([0:20],prob_table(8,:),'b-.');
plot([0:20],prob_table(9,:),'k-.');
plot([0:20],prob_table(10,:),'c-.');
%}
legend('1','2','3','4','5','6','7','8','9','10')