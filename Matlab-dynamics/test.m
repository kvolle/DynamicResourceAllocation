clear all
clc

blah = agent(1);

target_loc = [70.7;70.7];

blah.Target = 1;
for i = 1:1000
   tmp1(i) = blah.State(1);
   tmp2(i) = blah.State(2);
   tmp3(i) = -blah.State(3);
   blah.get_trajectory(target_loc);
   blah.velocity_hack();
   blah.RK4();
end
plot3(tmp1,tmp2,tmp3);