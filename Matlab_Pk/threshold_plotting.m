clear all
clc

prob_table = zeros(10,21);
%%%%% FIX THIS MESS
for target_size = 1:10
    target_pk = 0.55 +target_size/30;%1 - 0.3625^target_size;
   for numAgents = 1:20
       Pk = numAgents/20%1 - 0.3625^(numAgents-1);
       prob_table(target_size,numAgents) =(log((1-Pk)/(1-target_pk))/log(0.3625))*isreal(log(1-0.3625^(numAgents-2)-target_pk))/20;%log(0.3625)/log(Pk-target_pk)*isreal(log(0.3625)/log(Pk-target_pk));
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